-- =====================================================
-- Petnames by Kinder - Supabase Database Setup
-- Run this in Supabase SQL Editor (Dashboard > SQL Editor)
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLES
-- =====================================================

-- Households table
CREATE TABLE IF NOT EXISTS households (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    invite_code TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Profiles table (extends auth.users)
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT,
    household_id UUID REFERENCES households(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Name sets table
CREATE TABLE IF NOT EXISTS name_sets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slug TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    is_free BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Names table
CREATE TABLE IF NOT EXISTS names (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    gender TEXT NOT NULL CHECK (gender IN ('male', 'female', 'neutral')),
    set_id UUID REFERENCES name_sets(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Swipes table
CREATE TABLE IF NOT EXISTS swipes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    household_id UUID NOT NULL REFERENCES households(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name_id UUID NOT NULL REFERENCES names(id) ON DELETE CASCADE,
    decision TEXT NOT NULL CHECK (decision IN ('like', 'dismiss')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(household_id, user_id, name_id)
);

-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_swipes_household ON swipes(household_id);
CREATE INDEX IF NOT EXISTS idx_swipes_user ON swipes(user_id);
CREATE INDEX IF NOT EXISTS idx_swipes_name ON swipes(name_id);
CREATE INDEX IF NOT EXISTS idx_names_set ON names(set_id);
CREATE INDEX IF NOT EXISTS idx_names_gender ON names(gender);
CREATE INDEX IF NOT EXISTS idx_profiles_household ON profiles(household_id);

-- =====================================================
-- VIEW: household_matches (names liked by 2+ members)
-- =====================================================

CREATE OR REPLACE VIEW household_matches AS
SELECT 
    s.household_id,
    s.name_id,
    COUNT(DISTINCT s.user_id) as likes_count
FROM swipes s
WHERE s.decision = 'like'
GROUP BY s.household_id, s.name_id
HAVING COUNT(DISTINCT s.user_id) >= 2;

-- =====================================================
-- RPC: create_household
-- =====================================================

CREATE OR REPLACE FUNCTION create_household(display_name TEXT DEFAULT NULL)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    new_household_id UUID;
    new_invite_code TEXT;
    current_user_id UUID;
BEGIN
    -- Get current user
    current_user_id := auth.uid();
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- Generate unique invite code (6 characters)
    new_invite_code := UPPER(SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 6));
    
    -- Ensure uniqueness
    WHILE EXISTS (SELECT 1 FROM households WHERE invite_code = new_invite_code) LOOP
        new_invite_code := UPPER(SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 6));
    END LOOP;

    -- Create household
    INSERT INTO households (invite_code)
    VALUES (new_invite_code)
    RETURNING id INTO new_household_id;

    -- Create or update profile
    INSERT INTO profiles (id, display_name, household_id)
    VALUES (current_user_id, display_name, new_household_id)
    ON CONFLICT (id) DO UPDATE SET 
        display_name = COALESCE(EXCLUDED.display_name, profiles.display_name),
        household_id = new_household_id;

    RETURN json_build_object(
        'household_id', new_household_id,
        'invite_code', new_invite_code
    );
END;
$$;

-- =====================================================
-- RPC: join_household
-- =====================================================

CREATE OR REPLACE FUNCTION join_household(invite_code TEXT)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    found_household_id UUID;
    current_user_id UUID;
BEGIN
    -- Get current user
    current_user_id := auth.uid();
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- Find household by invite code
    SELECT id INTO found_household_id
    FROM households
    WHERE households.invite_code = UPPER(join_household.invite_code);

    IF found_household_id IS NULL THEN
        RAISE EXCEPTION 'Invite code not found';
    END IF;

    -- Create or update profile
    INSERT INTO profiles (id, household_id)
    VALUES (current_user_id, found_household_id)
    ON CONFLICT (id) DO UPDATE SET 
        household_id = found_household_id;

    RETURN json_build_object(
        'household_id', found_household_id
    );
END;
$$;

-- =====================================================
-- RPC: get_next_name
-- =====================================================

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

    IF result IS NULL THEN
        RETURN '[]'::JSON;
    END IF;

    RETURN json_build_object(
        'name_id', result.name_id,
        'name', result.name,
        'gender', result.gender,
        'set_title', result.set_title,
        'set_id', result.set_id
    );
END;
$$;

-- =====================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS
ALTER TABLE households ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE name_sets ENABLE ROW LEVEL SECURITY;
ALTER TABLE names ENABLE ROW LEVEL SECURITY;
ALTER TABLE swipes ENABLE ROW LEVEL SECURITY;

-- Households: users can read households they belong to
CREATE POLICY "Users can read own household" ON households
    FOR SELECT USING (
        id IN (SELECT household_id FROM profiles WHERE id = auth.uid())
    );

-- Profiles: users can read/update own profile
CREATE POLICY "Users can read own profile" ON profiles
    FOR SELECT USING (id = auth.uid());

CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (id = auth.uid());

CREATE POLICY "Users can insert own profile" ON profiles
    FOR INSERT WITH CHECK (id = auth.uid());

-- Profiles: users can read profiles in same household
CREATE POLICY "Users can read household profiles" ON profiles
    FOR SELECT USING (
        household_id IN (SELECT household_id FROM profiles WHERE id = auth.uid())
    );

-- Name sets: everyone can read
CREATE POLICY "Anyone can read name_sets" ON name_sets
    FOR SELECT USING (true);

-- Names: everyone can read
CREATE POLICY "Anyone can read names" ON names
    FOR SELECT USING (true);

-- Swipes: users can manage their own swipes
CREATE POLICY "Users can read own swipes" ON swipes
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert own swipes" ON swipes
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own swipes" ON swipes
    FOR DELETE USING (user_id = auth.uid());

-- Swipes: users can read household swipes (for matches)
CREATE POLICY "Users can read household swipes" ON swipes
    FOR SELECT USING (
        household_id IN (SELECT household_id FROM profiles WHERE id = auth.uid())
    );

-- =====================================================
-- SAMPLE DATA: Name Sets
-- =====================================================

INSERT INTO name_sets (slug, title, is_free) VALUES
    ('classic', 'Classic Names', true),
    ('modern', 'Modern Names', true),
    ('nature', 'Nature Inspired', true),
    ('literary', 'Literary Names', true),
    ('international', 'International', true),
    ('vintage', 'Vintage Names', true),
    ('mythological', 'Mythological', true),
    ('royal', 'Royal Names', true),
    ('celestial', 'Celestial Names', true),
    ('artistic', 'Artistic Names', true)
ON CONFLICT (slug) DO NOTHING;

-- =====================================================
-- SAMPLE DATA: Names (10 per set, mix of genders)
-- =====================================================

-- Classic Names
INSERT INTO names (name, gender, set_id) 
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'classic')
FROM (VALUES
    ('James', 'male'), ('William', 'male'), ('Elizabeth', 'female'), ('Catherine', 'female'),
    ('Thomas', 'male'), ('Margaret', 'female'), ('Edward', 'male'), ('Anne', 'female'),
    ('Alexander', 'male'), ('Victoria', 'female'), ('Charles', 'male'), ('Eleanor', 'female'),
    ('Henry', 'male'), ('Charlotte', 'female'), ('George', 'male'), ('Grace', 'female'),
    ('Samuel', 'male'), ('Emily', 'female'), ('Benjamin', 'male'), ('Sophia', 'female')
) AS t(name, gender)
ON CONFLICT DO NOTHING;

-- Modern Names
INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'modern')
FROM (VALUES
    ('Liam', 'male'), ('Olivia', 'female'), ('Noah', 'male'), ('Emma', 'female'),
    ('Aiden', 'male'), ('Ava', 'female'), ('Lucas', 'male'), ('Mia', 'female'),
    ('Mason', 'male'), ('Luna', 'female'), ('Ethan', 'male'), ('Harper', 'female'),
    ('Logan', 'male'), ('Aria', 'female'), ('Jackson', 'male'), ('Ella', 'female'),
    ('Riley', 'neutral'), ('Quinn', 'neutral'), ('Avery', 'neutral'), ('Jordan', 'neutral')
) AS t(name, gender)
ON CONFLICT DO NOTHING;

-- Nature Inspired
INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'nature')
FROM (VALUES
    ('River', 'neutral'), ('Willow', 'female'), ('Forest', 'male'), ('Ivy', 'female'),
    ('Ocean', 'neutral'), ('Sage', 'neutral'), ('Stone', 'male'), ('Rose', 'female'),
    ('Sky', 'neutral'), ('Hazel', 'female'), ('Cliff', 'male'), ('Lily', 'female'),
    ('Jasper', 'male'), ('Violet', 'female'), ('Reed', 'male'), ('Fern', 'female'),
    ('Brooks', 'male'), ('Dahlia', 'female'), ('Ash', 'neutral'), ('Aurora', 'female')
) AS t(name, gender)
ON CONFLICT DO NOTHING;

-- Literary Names
INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'literary')
FROM (VALUES
    ('Atticus', 'male'), ('Scout', 'neutral'), ('Darcy', 'male'), ('Jane', 'female'),
    ('Holden', 'male'), ('Juliet', 'female'), ('Romeo', 'male'), ('Ophelia', 'female'),
    ('Heathcliff', 'male'), ('Scarlett', 'female'), ('Rhett', 'male'), ('Hermione', 'female'),
    ('Dorian', 'male'), ('Cosette', 'female'), ('Pip', 'male'), ('Estella', 'female'),
    ('Gatsby', 'male'), ('Daisy', 'female'), ('Finch', 'neutral'), ('Bronte', 'female')
) AS t(name, gender)
ON CONFLICT DO NOTHING;

-- International Names
INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'international')
FROM (VALUES
    ('Kai', 'neutral'), ('Yuki', 'neutral'), ('Matteo', 'male'), ('Sofia', 'female'),
    ('Luca', 'male'), ('Aria', 'female'), ('Nico', 'male'), ('Mila', 'female'),
    ('Leo', 'male'), ('Elena', 'female'), ('Felix', 'male'), ('Lucia', 'female'),
    ('Hugo', 'male'), ('Isla', 'female'), ('Oscar', 'male'), ('Freya', 'female'),
    ('Soren', 'male'), ('Ingrid', 'female'), ('Akira', 'neutral'), ('Sakura', 'female')
) AS t(name, gender)
ON CONFLICT DO NOTHING;

-- Vintage Names
INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'vintage')
FROM (VALUES
    ('Theodore', 'male'), ('Beatrice', 'female'), ('Arthur', 'male'), ('Florence', 'female'),
    ('Edmund', 'male'), ('Adelaide', 'female'), ('Cecil', 'male'), ('Edith', 'female'),
    ('Harold', 'male'), ('Mabel', 'female'), ('Walter', 'male'), ('Pearl', 'female'),
    ('Albert', 'male'), ('Mildred', 'female'), ('Ernest', 'male'), ('Dorothy', 'female'),
    ('Clarence', 'male'), ('Harriet', 'female'), ('Gilbert', 'male'), ('Josephine', 'female')
) AS t(name, gender)
ON CONFLICT DO NOTHING;

-- Mythological Names
INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'mythological')
FROM (VALUES
    ('Atlas', 'male'), ('Athena', 'female'), ('Apollo', 'male'), ('Diana', 'female'),
    ('Orion', 'male'), ('Luna', 'female'), ('Thor', 'male'), ('Freya', 'female'),
    ('Zeus', 'male'), ('Hera', 'female'), ('Ares', 'male'), ('Iris', 'female'),
    ('Hermes', 'male'), ('Selene', 'female'), ('Perseus', 'male'), ('Calliope', 'female'),
    ('Phoenix', 'neutral'), ('Echo', 'female'), ('Griffin', 'male'), ('Daphne', 'female')
) AS t(name, gender)
ON CONFLICT DO NOTHING;

-- Royal Names
INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'royal')
FROM (VALUES
    ('Frederick', 'male'), ('Beatrix', 'female'), ('Leopold', 'male'), ('Eugenie', 'female'),
    ('Maximilian', 'male'), ('Anastasia', 'female'), ('Constantine', 'male'), ('Alexandra', 'female'),
    ('Sebastian', 'male'), ('Arabella', 'female'), ('Archibald', 'male'), ('Cordelia', 'female'),
    ('Reginald', 'male'), ('Genevieve', 'female'), ('Ferdinand', 'male'), ('Valentina', 'female'),
    ('Benedict', 'male'), ('Clementine', 'female'), ('Augustus', 'male'), ('Seraphina', 'female')
) AS t(name, gender)
ON CONFLICT DO NOTHING;

-- Celestial Names
INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'celestial')
FROM (VALUES
    ('Orion', 'male'), ('Stella', 'female'), ('Leo', 'male'), ('Nova', 'female'),
    ('Sirius', 'male'), ('Celeste', 'female'), ('Castor', 'male'), ('Lyra', 'female'),
    ('Altair', 'male'), ('Vega', 'female'), ('Draco', 'male'), ('Astra', 'female'),
    ('Rigel', 'male'), ('Andromeda', 'female'), ('Cosmos', 'male'), ('Galaxy', 'neutral'),
    ('Zenith', 'neutral'), ('Eclipse', 'neutral'), ('Comet', 'neutral'), ('Soleil', 'female')
) AS t(name, gender)
ON CONFLICT DO NOTHING;

-- Artistic Names
INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'artistic')
FROM (VALUES
    ('Leonardo', 'male'), ('Frida', 'female'), ('Vincent', 'male'), ('Georgia', 'female'),
    ('Michelangelo', 'male'), ('Monet', 'neutral'), ('Raphael', 'male'), ('Cleo', 'female'),
    ('Rembrandt', 'male'), ('Artemisia', 'female'), ('Salvador', 'male'), ('Kahlo', 'female'),
    ('Claude', 'male'), ('Yoko', 'female'), ('Pablo', 'male'), ('Marina', 'female'),
    ('Basquiat', 'male'), ('Vivienne', 'female'), ('Banksy', 'neutral'), ('Tamara', 'female')
) AS t(name, gender)
ON CONFLICT DO NOTHING;

-- =====================================================
-- GRANT PERMISSIONS
-- =====================================================

-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO anon, authenticated;

-- Grant access to tables
GRANT SELECT ON households TO anon, authenticated;
GRANT SELECT ON profiles TO anon, authenticated;
GRANT INSERT, UPDATE ON profiles TO authenticated;
GRANT SELECT ON name_sets TO anon, authenticated;
GRANT SELECT ON names TO anon, authenticated;
GRANT SELECT, INSERT, DELETE ON swipes TO authenticated;
GRANT SELECT ON household_matches TO anon, authenticated;

-- Grant execute on functions
GRANT EXECUTE ON FUNCTION create_household TO authenticated;
GRANT EXECUTE ON FUNCTION join_household TO authenticated;
GRANT EXECUTE ON FUNCTION get_next_name TO authenticated;
