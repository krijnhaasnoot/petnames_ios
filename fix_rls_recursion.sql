-- Fix infinite recursion in profiles RLS policy
-- Run this in Supabase SQL Editor

-- Drop the problematic policies
DROP POLICY IF EXISTS "Users can read own profile" ON profiles;
DROP POLICY IF EXISTS "Users can read household profiles" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

-- Recreate with non-recursive policies
-- Users can always read and manage their own profile
CREATE POLICY "Users can manage own profile" ON profiles
    FOR ALL USING (id = auth.uid())
    WITH CHECK (id = auth.uid());

-- For reading other profiles in same household, use a security definer function
CREATE OR REPLACE FUNCTION get_user_household_id()
RETURNS UUID
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
    SELECT household_id FROM profiles WHERE id = auth.uid();
$$;

-- Users can read profiles in their household (using the function to avoid recursion)
CREATE POLICY "Users can read household member profiles" ON profiles
    FOR SELECT USING (
        household_id IS NOT NULL 
        AND household_id = get_user_household_id()
    );

-- Also fix swipes policy that might have similar issue
DROP POLICY IF EXISTS "Users can read household swipes" ON swipes;

CREATE POLICY "Users can read household swipes" ON swipes
    FOR SELECT USING (
        household_id = get_user_household_id()
    );

-- Grant execute on the helper function
GRANT EXECUTE ON FUNCTION get_user_household_id TO authenticated;
