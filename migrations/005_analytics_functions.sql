-- Analytics Functions for Petnames
-- Run this in Supabase SQL Editor

-- Function to get overall stats
CREATE OR REPLACE FUNCTION get_analytics_stats()
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'total_users', (SELECT COUNT(*) FROM profiles),
        'total_households', (SELECT COUNT(*) FROM households),
        'total_swipes', (SELECT COUNT(*) FROM swipes),
        'total_likes', (SELECT COUNT(*) FROM swipes WHERE decision = 'like'),
        'total_dismisses', (SELECT COUNT(*) FROM swipes WHERE decision = 'dismiss'),
        'total_matches', (SELECT COUNT(*) FROM household_matches),
        'active_today', (SELECT COUNT(DISTINCT user_id) FROM swipes WHERE created_at > NOW() - INTERVAL '24 hours'),
        'active_week', (SELECT COUNT(DISTINCT user_id) FROM swipes WHERE created_at > NOW() - INTERVAL '7 days')
    ) INTO result;
    
    RETURN result;
END;
$$;

-- Function to get top 25 most liked names
CREATE OR REPLACE FUNCTION get_top_liked_names(p_limit INT DEFAULT 25)
RETURNS TABLE (
    name TEXT,
    gender TEXT,
    likes_count BIGINT,
    set_title TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.name,
        n.gender,
        COUNT(*) as likes_count,
        ns.title as set_title
    FROM swipes s
    JOIN names n ON s.name_id = n.id
    JOIN name_sets ns ON n.set_id = ns.id
    WHERE s.decision = 'like'
    GROUP BY n.id, n.name, n.gender, ns.title
    ORDER BY likes_count DESC
    LIMIT p_limit;
END;
$$;

-- Function to get top matched names (names that appear in household_matches)
CREATE OR REPLACE FUNCTION get_top_matched_names(p_limit INT DEFAULT 25)
RETURNS TABLE (
    name TEXT,
    gender TEXT,
    match_count BIGINT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.name,
        n.gender,
        COUNT(DISTINCT hm.household_id) as match_count
    FROM household_matches hm
    JOIN names n ON hm.name_id = n.id
    GROUP BY n.id, n.name, n.gender
    ORDER BY match_count DESC
    LIMIT p_limit;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION get_analytics_stats() TO authenticated;
GRANT EXECUTE ON FUNCTION get_analytics_stats() TO anon;
GRANT EXECUTE ON FUNCTION get_top_liked_names(INT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_top_liked_names(INT) TO anon;
GRANT EXECUTE ON FUNCTION get_top_matched_names(INT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_top_matched_names(INT) TO anon;
