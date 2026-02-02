-- Fix get_next_name to return consistent array format
-- Run this in Supabase SQL Editor

CREATE OR REPLACE FUNCTION get_next_name(
    p_household_id UUID,
    p_enabled_set_ids UUID[],
    p_gender TEXT DEFAULT 'any',
    p_starts_with TEXT DEFAULT 'any',
    p_max_length INT DEFAULT 0
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result RECORD;
    current_user_id UUID;
BEGIN
    -- Get current user
    current_user_id := auth.uid();
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- Find next name that hasn't been swiped by this user
    SELECT 
        n.id as name_id,
        n.name,
        n.gender,
        ns.title as set_title,
        ns.id as set_id
    INTO result
    FROM names n
    JOIN name_sets ns ON n.set_id = ns.id
    WHERE 
        -- Filter by enabled sets
        (array_length(p_enabled_set_ids, 1) IS NULL OR n.set_id = ANY(p_enabled_set_ids))
        -- Filter by gender
        AND (p_gender = 'any' OR n.gender = p_gender)
        -- Filter by starts with
        AND (p_starts_with = 'any' OR LOWER(n.name) LIKE LOWER(p_starts_with) || '%')
        -- Filter by max length
        AND (p_max_length = 0 OR LENGTH(n.name) <= p_max_length)
        -- Exclude already swiped names by this user in this household
        AND NOT EXISTS (
            SELECT 1 FROM swipes s 
            WHERE s.household_id = p_household_id 
            AND s.user_id = current_user_id 
            AND s.name_id = n.id
        )
    ORDER BY RANDOM()
    LIMIT 1;

    -- Always return array format for consistency
    IF result IS NULL THEN
        RETURN '[]'::JSON;
    END IF;

    RETURN json_build_array(
        json_build_object(
            'name_id', result.name_id,
            'name', result.name,
            'gender', result.gender,
            'set_title', result.set_title,
            'set_id', result.set_id
        )
    );
END;
$$;
