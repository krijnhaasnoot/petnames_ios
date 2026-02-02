-- Migration: Add push notification support
-- Run this in Supabase SQL Editor

-- 1. Add push_token column to profiles
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS push_token TEXT;

-- 2. Create index for faster token lookups
CREATE INDEX IF NOT EXISTS idx_profiles_push_token 
ON public.profiles(push_token) 
WHERE push_token IS NOT NULL;

-- 3. Create a function to get push tokens for a household (excluding a specific user)
CREATE OR REPLACE FUNCTION get_household_push_tokens(
    p_household_id UUID,
    p_exclude_user_id UUID DEFAULT NULL
)
RETURNS TABLE(user_id UUID, push_token TEXT)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.push_token
    FROM profiles p
    WHERE p.household_id = p_household_id
      AND p.push_token IS NOT NULL
      AND (p_exclude_user_id IS NULL OR p.id != p_exclude_user_id);
END;
$$;

-- 4. Create a notifications log table (optional, for debugging)
CREATE TABLE IF NOT EXISTS public.notification_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID REFERENCES public.households(id),
    user_id UUID REFERENCES public.profiles(id),
    type TEXT NOT NULL, -- 'match', 'new_member'
    payload JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Enable RLS on notification_log
ALTER TABLE public.notification_log ENABLE ROW LEVEL SECURITY;

-- 6. Policy: Users can only see their own household's notifications
CREATE POLICY "Users can view own household notifications"
ON public.notification_log
FOR SELECT
USING (
    household_id IN (
        SELECT household_id FROM profiles WHERE id = auth.uid()
    )
);

-- ============================================
-- EDGE FUNCTION SETUP (deploy separately)
-- ============================================
-- 
-- You need to create a Supabase Edge Function to actually send push notifications.
-- Here's the structure:
--
-- 1. Create edge function: supabase functions new send-push-notification
-- 
-- 2. Edge function code (TypeScript):
-- 
-- import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
-- 
-- serve(async (req) => {
--   const { tokens, title, body, data } = await req.json()
--   
--   // Use APNs or a service like OneSignal/Firebase
--   // For APNs, you need to set up certificates in Apple Developer Portal
--   
--   // Example with a push service:
--   const responses = await Promise.all(
--     tokens.map(async (token: string) => {
--       // Send to push service
--     })
--   )
--   
--   return new Response(JSON.stringify({ success: true }), {
--     headers: { "Content-Type": "application/json" }
--   })
-- })
--
-- ============================================
-- DATABASE TRIGGERS (alternative approach)
-- ============================================

-- Trigger function for new matches
CREATE OR REPLACE FUNCTION notify_on_match()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_name TEXT;
    v_household_id UUID;
BEGIN
    -- Get the name that was matched
    SELECT n.name INTO v_name
    FROM names n
    WHERE n.id = NEW.name_id;
    
    -- Get household_id
    v_household_id := NEW.household_id;
    
    -- Log the notification (the edge function can poll this or use realtime)
    INSERT INTO notification_log (household_id, user_id, type, payload)
    VALUES (
        v_household_id,
        NEW.user_id,
        'match',
        jsonb_build_object('name', v_name, 'name_id', NEW.name_id)
    );
    
    RETURN NEW;
END;
$$;

-- Note: You'd need additional logic to detect when a swipe creates a match
-- This is a simplified example

-- Trigger function for new household members
CREATE OR REPLACE FUNCTION notify_on_new_member()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_display_name TEXT;
BEGIN
    -- Only trigger when household_id changes from NULL to a value (joining)
    IF OLD.household_id IS NULL AND NEW.household_id IS NOT NULL THEN
        v_display_name := COALESCE(NEW.display_name, 'Iemand');
        
        -- Log the notification
        INSERT INTO notification_log (household_id, user_id, type, payload)
        VALUES (
            NEW.household_id,
            NEW.id,
            'new_member',
            jsonb_build_object('member_name', v_display_name, 'member_id', NEW.id)
        );
    END IF;
    
    RETURN NEW;
END;
$$;

-- Create trigger for new members
DROP TRIGGER IF EXISTS on_new_household_member ON public.profiles;
CREATE TRIGGER on_new_household_member
    AFTER UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION notify_on_new_member();

-- ============================================
-- TRIGGER: Send push on match
-- ============================================

-- Function to check if a swipe creates a match and send push
CREATE OR REPLACE FUNCTION check_and_notify_match()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_likes_count INT;
    v_name TEXT;
    v_edge_function_url TEXT;
BEGIN
    -- Only process likes
    IF NEW.decision != 'like' THEN
        RETURN NEW;
    END IF;
    
    -- Count how many people in this household liked this name
    SELECT COUNT(*) INTO v_likes_count
    FROM swipes
    WHERE household_id = NEW.household_id
      AND name_id = NEW.name_id
      AND decision = 'like';
    
    -- If this is the 2nd like (creates a match), send notifications
    IF v_likes_count = 2 THEN
        -- Get the name
        SELECT name INTO v_name FROM names WHERE id = NEW.name_id;
        
        -- Log the match notification
        INSERT INTO notification_log (household_id, user_id, type, payload)
        VALUES (
            NEW.household_id,
            NEW.user_id,
            'match',
            jsonb_build_object('name', v_name, 'name_id', NEW.name_id)
        );
        
        -- Call edge function to send push (async via pg_net if available)
        -- Note: This requires pg_net extension enabled in Supabase
        -- Alternative: Use Supabase Realtime to listen for notification_log inserts
        
        -- If pg_net is enabled, uncomment this:
        -- PERFORM net.http_post(
        --     url := 'https://YOUR_PROJECT_REF.supabase.co/functions/v1/send-push',
        --     headers := jsonb_build_object(
        --         'Content-Type', 'application/json',
        --         'Authorization', 'Bearer ' || current_setting('app.settings.service_role_key', true)
        --     ),
        --     body := jsonb_build_object(
        --         'type', 'match',
        --         'household_id', NEW.household_id,
        --         'exclude_user_id', NEW.user_id,
        --         'payload', jsonb_build_object('name', v_name)
        --     )
        -- );
    END IF;
    
    RETURN NEW;
END;
$$;

-- Create trigger for match detection
DROP TRIGGER IF EXISTS on_swipe_check_match ON public.swipes;
CREATE TRIGGER on_swipe_check_match
    AFTER INSERT ON public.swipes
    FOR EACH ROW
    EXECUTE FUNCTION check_and_notify_match();

-- ============================================
-- GRANT PERMISSIONS
-- ============================================

GRANT EXECUTE ON FUNCTION get_household_push_tokens TO authenticated;
GRANT SELECT ON notification_log TO authenticated;
