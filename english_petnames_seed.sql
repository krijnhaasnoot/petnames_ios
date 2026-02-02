-- =====================================================
-- English Petnames - Complete Seed Data
-- Run this in Supabase SQL Editor AFTER dutch_petnames_seed.sql
-- =====================================================

-- =====================================================
-- CREATE ENGLISH SUBSETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, is_free) VALUES
    (gen_random_uuid(), 'english-cute', 'Cute & Sweet', true),
    (gen_random_uuid(), 'english-strong', 'Short & Strong', true),
    (gen_random_uuid(), 'english-classic', 'Classic Names', true),
    (gen_random_uuid(), 'english-funny', 'Funny & Playful', true),
    (gen_random_uuid(), 'english-vintage', 'Vintage & Old-School', true),
    (gen_random_uuid(), 'english-nature', 'Nature Inspired', true),
    (gen_random_uuid(), 'english-petnicknames', 'Pet Nicknames', true);

-- =====================================================
-- 1. CUTE & SWEET (english-cute)
-- Soft, sweet names that sound friendly and lovable
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-cute')
FROM (VALUES
    ('Bella', 'female'),
    ('Buddy', 'male'),
    ('Coco', 'neutral'),
    ('Daisy', 'female'),
    ('Honey', 'female'),
    ('Luna', 'female'),
    ('Milo', 'male'),
    ('Molly', 'female'),
    ('Nala', 'female'),
    ('Poppy', 'female'),
    ('Rosie', 'female'),
    ('Teddy', 'male'),
    ('Willow', 'female'),
    ('Biscuit', 'neutral'),
    ('Peanut', 'neutral'),
    ('Pumpkin', 'neutral'),
    ('Snowy', 'neutral'),
    ('Sunny', 'neutral'),
    ('Muffin', 'neutral'),
    ('Cupcake', 'female'),
    ('Buttercup', 'female'),
    ('Bubbles', 'neutral'),
    ('Fluffy', 'neutral'),
    ('Toffee', 'neutral'),
    ('Marshmallow', 'neutral'),
    ('Cookie', 'neutral'),
    ('Ginger', 'female'),
    ('Bambi', 'female'),
    ('Cinnamon', 'neutral'),
    ('Dolly', 'female'),
    ('Fifi', 'female'),
    ('Lulu', 'female'),
    ('Peaches', 'female'),
    ('Pixie', 'female'),
    ('Precious', 'female'),
    ('Princess', 'female'),
    ('Snickers', 'neutral'),
    ('Snowball', 'neutral'),
    ('Sprinkles', 'neutral'),
    ('Sugar', 'female'),
    ('Sweetpea', 'female'),
    ('Tinkerbell', 'female'),
    ('Twinkle', 'neutral'),
    ('Velvet', 'female'),
    ('Whiskers', 'neutral')
) AS t(name, gender);

-- =====================================================
-- 2. SHORT & STRONG (english-strong)
-- Short, punchy names with a strong sound
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-strong')
FROM (VALUES
    ('Ace', 'male'),
    ('Axel', 'male'),
    ('Bear', 'male'),
    ('Blaze', 'male'),
    ('Bolt', 'male'),
    ('Cash', 'male'),
    ('Dex', 'male'),
    ('Diesel', 'male'),
    ('Duke', 'male'),
    ('Finn', 'male'),
    ('Jax', 'male'),
    ('Kai', 'neutral'),
    ('Max', 'male'),
    ('Neo', 'male'),
    ('Oz', 'male'),
    ('Rex', 'male'),
    ('Rocky', 'male'),
    ('Spike', 'male'),
    ('Tank', 'male'),
    ('Thor', 'male'),
    ('Wolf', 'male'),
    ('Zane', 'male'),
    ('Bruno', 'male'),
    ('Chase', 'male'),
    ('Colt', 'male'),
    ('Fang', 'male'),
    ('Flash', 'male'),
    ('Gunner', 'male'),
    ('Hunter', 'male'),
    ('King', 'male'),
    ('Knox', 'male'),
    ('Maverick', 'male'),
    ('Onyx', 'neutral'),
    ('Ranger', 'male'),
    ('Rebel', 'male'),
    ('Rocco', 'male'),
    ('Rogue', 'neutral'),
    ('Titan', 'male'),
    ('Trooper', 'male'),
    ('Zeus', 'male'),
    ('Bruiser', 'male'),
    ('Chief', 'male'),
    ('Bandit', 'male'),
    ('Shadow', 'neutral'),
    ('Blade', 'male')
) AS t(name, gender);

-- =====================================================
-- 3. CLASSIC NAMES (english-classic)
-- Timeless English names that feel familiar and warm
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-classic')
FROM (VALUES
    ('Charlie', 'male'),
    ('Jack', 'male'),
    ('Lucy', 'female'),
    ('Oscar', 'male'),
    ('Oliver', 'male'),
    ('Ruby', 'female'),
    ('Sam', 'male'),
    ('Sadie', 'female'),
    ('Toby', 'male'),
    ('Lily', 'female'),
    ('Henry', 'male'),
    ('Leo', 'male'),
    ('George', 'male'),
    ('Archie', 'male'),
    ('Alfie', 'male'),
    ('Millie', 'female'),
    ('Theo', 'male'),
    ('Ellie', 'female'),
    ('Harry', 'male'),
    ('Emily', 'female'),
    ('Freddie', 'male'),
    ('Hazel', 'female'),
    ('Bailey', 'neutral'),
    ('Bella', 'female'),
    ('Benny', 'male'),
    ('Bonnie', 'female'),
    ('Chester', 'male'),
    ('Chloe', 'female'),
    ('Gracie', 'female'),
    ('Jake', 'male'),
    ('Jasper', 'male'),
    ('Katie', 'female'),
    ('Maggie', 'female'),
    ('Murphy', 'male'),
    ('Penny', 'female'),
    ('Riley', 'neutral'),
    ('Rosie', 'female'),
    ('Sophie', 'female'),
    ('Tucker', 'male'),
    ('Winston', 'male'),
    ('Zoe', 'female'),
    ('Abby', 'female'),
    ('Cooper', 'male'),
    ('Daisy', 'female'),
    ('Finn', 'male')
) AS t(name, gender);

-- =====================================================
-- 4. FUNNY & PLAYFUL (english-funny)
-- Light-hearted names with humor and personality
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-funny')
FROM (VALUES
    ('Banjo', 'neutral'),
    ('Bean', 'neutral'),
    ('Bingo', 'neutral'),
    ('Boomer', 'male'),
    ('Chewie', 'neutral'),
    ('Chonk', 'neutral'),
    ('Doodle', 'neutral'),
    ('Goose', 'neutral'),
    ('Gizmo', 'neutral'),
    ('Hamlet', 'male'),
    ('Muppet', 'neutral'),
    ('Noodle', 'neutral'),
    ('Pickles', 'neutral'),
    ('Pudding', 'neutral'),
    ('Sausage', 'neutral'),
    ('Snoopy', 'male'),
    ('Spud', 'neutral'),
    ('Taco', 'neutral'),
    ('Wiggles', 'neutral'),
    ('Waffles', 'neutral'),
    ('Zippy', 'neutral'),
    ('Bacon', 'neutral'),
    ('Bork', 'neutral'),
    ('Burrito', 'neutral'),
    ('Chaos', 'neutral'),
    ('Churro', 'neutral'),
    ('Dumpling', 'neutral'),
    ('Frito', 'neutral'),
    ('Hodor', 'male'),
    ('Kazoo', 'neutral'),
    ('Meatball', 'neutral'),
    ('Nacho', 'neutral'),
    ('Nugget', 'neutral'),
    ('Oreo', 'neutral'),
    ('Pogo', 'neutral'),
    ('Pretzel', 'neutral'),
    ('Ramen', 'neutral'),
    ('Scooter', 'neutral'),
    ('Tofu', 'neutral'),
    ('Twinkie', 'neutral'),
    ('Wobble', 'neutral'),
    ('Yoda', 'male'),
    ('Potato', 'neutral'),
    ('Dobby', 'male'),
    ('Gremlin', 'neutral')
) AS t(name, gender);

-- =====================================================
-- 5. VINTAGE & OLD-SCHOOL (english-vintage)
-- Old-fashioned English names with a nostalgic vibe
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-vintage')
FROM (VALUES
    ('Alfred', 'male'),
    ('Arthur', 'male'),
    ('Beatrice', 'female'),
    ('Betsy', 'female'),
    ('Cecil', 'male'),
    ('Clara', 'female'),
    ('Edgar', 'male'),
    ('Ethel', 'female'),
    ('Florence', 'female'),
    ('Frank', 'male'),
    ('Harold', 'male'),
    ('Hattie', 'female'),
    ('Ivy', 'female'),
    ('Mabel', 'female'),
    ('Minnie', 'female'),
    ('Norman', 'male'),
    ('Otis', 'male'),
    ('Pearl', 'female'),
    ('Stanley', 'male'),
    ('Walter', 'male'),
    ('Winston', 'male'),
    ('Agnes', 'female'),
    ('Albert', 'male'),
    ('Barnaby', 'male'),
    ('Bertha', 'female'),
    ('Clyde', 'male'),
    ('Cornelius', 'male'),
    ('Dorothy', 'female'),
    ('Edmund', 'male'),
    ('Eleanor', 'female'),
    ('Ernest', 'male'),
    ('Gertrude', 'female'),
    ('Gilbert', 'male'),
    ('Gladys', 'female'),
    ('Herbert', 'male'),
    ('Josephine', 'female'),
    ('Leonard', 'male'),
    ('Mildred', 'female'),
    ('Reginald', 'male'),
    ('Theodore', 'male'),
    ('Violet', 'female'),
    ('Winifred', 'female'),
    ('Archibald', 'male'),
    ('Edith', 'female'),
    ('Mortimer', 'male')
) AS t(name, gender);

-- =====================================================
-- 6. NATURE INSPIRED (english-nature)
-- Names inspired by nature, weather, and the outdoors
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-nature')
FROM (VALUES
    ('Ash', 'neutral'),
    ('Breeze', 'female'),
    ('Cedar', 'neutral'),
    ('Clover', 'neutral'),
    ('Daisy', 'female'),
    ('Ember', 'female'),
    ('Fern', 'female'),
    ('Forest', 'neutral'),
    ('Hazel', 'female'),
    ('Ivy', 'female'),
    ('Juniper', 'female'),
    ('Maple', 'neutral'),
    ('Mist', 'neutral'),
    ('Moon', 'neutral'),
    ('Oakley', 'neutral'),
    ('River', 'neutral'),
    ('Sky', 'neutral'),
    ('Storm', 'neutral'),
    ('Sunny', 'neutral'),
    ('Willow', 'female'),
    ('Aurora', 'female'),
    ('Birch', 'neutral'),
    ('Blossom', 'female'),
    ('Brook', 'neutral'),
    ('Canyon', 'neutral'),
    ('Cloud', 'neutral'),
    ('Coral', 'female'),
    ('Dawn', 'female'),
    ('Dusk', 'neutral'),
    ('Everest', 'neutral'),
    ('Flame', 'neutral'),
    ('Flint', 'male'),
    ('Jasmine', 'female'),
    ('Lake', 'neutral'),
    ('Meadow', 'female'),
    ('Misty', 'female'),
    ('Pebble', 'neutral'),
    ('Rain', 'neutral'),
    ('Sage', 'neutral'),
    ('Sierra', 'female'),
    ('Star', 'neutral'),
    ('Stone', 'neutral'),
    ('Thunder', 'male'),
    ('Winter', 'neutral'),
    ('Zinnia', 'female')
) AS t(name, gender);

-- =====================================================
-- 7. PET NICKNAMES (english-petnicknames)
-- Common English nicknames and affectionate pet names
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-petnicknames')
FROM (VALUES
    ('Baby', 'neutral'),
    ('Boo', 'neutral'),
    ('Bubba', 'male'),
    ('Buddy', 'male'),
    ('Cuddles', 'neutral'),
    ('Cutie', 'neutral'),
    ('Furball', 'neutral'),
    ('Honeybun', 'neutral'),
    ('Lovey', 'neutral'),
    ('Munchkin', 'neutral'),
    ('Pookie', 'neutral'),
    ('Snuggles', 'neutral'),
    ('Sweetie', 'neutral'),
    ('Tiny', 'neutral'),
    ('Angel', 'neutral'),
    ('Fluff', 'neutral'),
    ('Sugar', 'neutral'),
    ('Peaches', 'female'),
    ('Babycakes', 'neutral'),
    ('Babe', 'neutral'),
    ('Booger', 'neutral'),
    ('Bubby', 'neutral'),
    ('Bunny', 'neutral'),
    ('Buttercup', 'female'),
    ('Champ', 'male'),
    ('Chunk', 'neutral'),
    ('Cuddlebug', 'neutral'),
    ('Ducky', 'neutral'),
    ('Fuzzy', 'neutral'),
    ('Handsome', 'male'),
    ('Junior', 'male'),
    ('Ladybug', 'female'),
    ('Little One', 'neutral'),
    ('Lovebug', 'neutral'),
    ('Peanut', 'neutral'),
    ('Precious', 'female'),
    ('Pudge', 'neutral'),
    ('Pup', 'neutral'),
    ('Rascal', 'neutral'),
    ('Scamp', 'neutral'),
    ('Smooch', 'neutral'),
    ('Squirt', 'neutral'),
    ('Stinker', 'neutral'),
    ('Sweetums', 'neutral'),
    ('Whiskers', 'neutral')
) AS t(name, gender);

-- =====================================================
-- VERIFY COUNTS
-- =====================================================

SELECT 
    ns.title,
    ns.slug,
    COUNT(n.id) as name_count
FROM name_sets ns
LEFT JOIN names n ON n.set_id = ns.id
GROUP BY ns.id, ns.title, ns.slug
ORDER BY ns.slug;
