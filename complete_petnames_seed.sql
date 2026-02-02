-- =====================================================
-- Complete Petnames Seed Data (Dutch + English)
-- Run this in Supabase SQL Editor
-- This replaces all existing name data
-- =====================================================

-- First, clear existing data
DELETE FROM swipes;
DELETE FROM names;
DELETE FROM name_sets;

-- =====================================================
-- DUTCH SUBSETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, is_free) VALUES
    (gen_random_uuid(), 'dutch-cute', 'Lief & Schattig', true),
    (gen_random_uuid(), 'dutch-tough', 'Kort & Stoer', true),
    (gen_random_uuid(), 'dutch-classic', 'Klassiek Nederlands', true),
    (gen_random_uuid(), 'dutch-funny', 'Speels & Grappig', true),
    (gen_random_uuid(), 'dutch-nostalgic', 'Oud-Hollands', true),
    (gen_random_uuid(), 'dutch-nature', 'Natuur & Buiten', true),
    (gen_random_uuid(), 'dutch-petnicknames', 'Koosnamen', true);

-- =====================================================
-- ENGLISH SUBSETS
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
-- DUTCH NAMES
-- =====================================================

-- Lief & Schattig
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-cute') FROM (VALUES
    ('Puk', 'neutral'), ('Pip', 'neutral'), ('Pippa', 'female'), ('Poppy', 'female'), ('Bink', 'neutral'),
    ('Bo', 'neutral'), ('Bowie', 'neutral'), ('Bibi', 'female'), ('Bono', 'male'), ('Dot', 'female'),
    ('Doortje', 'female'), ('Fiep', 'female'), ('Fien', 'female'), ('Fleur', 'female'), ('Guusje', 'female'),
    ('Izzy', 'neutral'), ('Kiki', 'female'), ('Koko', 'neutral'), ('Lotje', 'female'), ('Luna', 'female'),
    ('Mimi', 'female'), ('Moppie', 'neutral'), ('Noortje', 'female'), ('Pluk', 'neutral'), ('Puck', 'neutral'),
    ('Snuf', 'neutral'), ('Snoes', 'female'), ('Teddy', 'male'), ('Tommie', 'male'), ('Woezel', 'neutral'),
    ('Ziggy', 'neutral'), ('Bella', 'female'), ('Lola', 'female'), ('Nala', 'female'), ('Suki', 'female'),
    ('Coco', 'female'), ('Pixie', 'female'), ('Dottie', 'female'), ('Minnie', 'female'), ('Trixie', 'female'),
    ('Floortje', 'female'), ('Snoepje', 'neutral'), ('Vlekje', 'neutral'), ('Pluisje', 'neutral'), ('Kruimel', 'neutral')
) AS t(name, gender);

-- Kort & Stoer
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-tough') FROM (VALUES
    ('Boaz', 'male'), ('Bram', 'male'), ('Dex', 'male'), ('Diesel', 'male'), ('Duke', 'male'),
    ('Finn', 'male'), ('Gijs', 'male'), ('Henk', 'male'), ('Jack', 'male'), ('Joep', 'male'),
    ('Kees', 'male'), ('Koda', 'neutral'), ('Leo', 'male'), ('Max', 'male'), ('Moos', 'male'),
    ('Otis', 'male'), ('Rex', 'male'), ('Rocky', 'male'), ('Sam', 'male'), ('Spike', 'male'),
    ('Storm', 'male'), ('Teun', 'male'), ('Thor', 'male'), ('Ties', 'male'), ('Timo', 'male'),
    ('Tygo', 'male'), ('Wolf', 'male'), ('Ace', 'male'), ('Blitz', 'male'), ('Bruno', 'male'),
    ('Cash', 'male'), ('Chase', 'male'), ('Colt', 'male'), ('Fang', 'male'), ('Flash', 'male'),
    ('Hunter', 'male'), ('Jax', 'male'), ('Kane', 'male'), ('King', 'male'), ('Ranger', 'male'),
    ('Rebel', 'male'), ('Rocco', 'male'), ('Tank', 'male'), ('Titan', 'male'), ('Zeus', 'male')
) AS t(name, gender);

-- Klassiek Nederlands
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-classic') FROM (VALUES
    ('Annie', 'female'), ('Betsy', 'female'), ('Brammetje', 'male'), ('Cato', 'female'), ('Daantje', 'male'),
    ('Eef', 'neutral'), ('Evi', 'female'), ('Guus', 'male'), ('Harrie', 'male'), ('Ineke', 'female'),
    ('Jip', 'neutral'), ('Joost', 'male'), ('Karel', 'male'), ('Lies', 'female'), ('Lotte', 'female'),
    ('Mies', 'female'), ('Nelis', 'male'), ('Pleun', 'female'), ('Rik', 'male'), ('Roos', 'female'),
    ('Saar', 'female'), ('Siep', 'male'), ('Tijn', 'male'), ('Wim', 'male'), ('Wout', 'male'),
    ('Bep', 'female'), ('Cor', 'male'), ('Daan', 'male'), ('Fem', 'female'), ('Jaap', 'male'),
    ('Jan', 'male'), ('Jet', 'female'), ('Koos', 'male'), ('Maan', 'female'), ('Piet', 'male'),
    ('Sjef', 'male'), ('Stef', 'male'), ('Toos', 'female'), ('Ans', 'female'), ('Bas', 'male'),
    ('Cas', 'male'), ('Leen', 'male'), ('Miep', 'female'), ('Nel', 'female'), ('Riet', 'female')
) AS t(name, gender);

-- Speels & Grappig
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-funny') FROM (VALUES
    ('Appie', 'neutral'), ('Bam', 'neutral'), ('Binkie', 'neutral'), ('Boef', 'male'), ('Bolle', 'neutral'),
    ('Chico', 'male'), ('Droppie', 'neutral'), ('Flip', 'male'), ('Flodder', 'neutral'), ('Gekkie', 'neutral'),
    ('Knor', 'neutral'), ('Kroket', 'neutral'), ('Loebas', 'male'), ('Muppet', 'neutral'), ('Nijntje', 'neutral'),
    ('Pannenkoek', 'neutral'), ('Poffertje', 'neutral'), ('Snickers', 'neutral'), ('Spetter', 'neutral'), ('Stuiter', 'neutral'),
    ('Toffee', 'neutral'), ('Wafel', 'neutral'), ('Brokje', 'neutral'), ('Doerak', 'male'), ('Flierefluiter', 'male'),
    ('Frekkel', 'neutral'), ('Gumbo', 'neutral'), ('Jansen', 'neutral'), ('Kabouter', 'male'), ('Knabbel', 'neutral'),
    ('Kwispel', 'neutral'), ('Oliebol', 'neutral'), ('Pinda', 'neutral'), ('Rakker', 'male'), ('Ratje', 'neutral'),
    ('Slungel', 'male'), ('Spruit', 'neutral'), ('Stamppot', 'neutral'), ('Stroopwafel', 'neutral'), ('Wiebel', 'neutral'),
    ('Wobbel', 'neutral'), ('Bami', 'neutral'), ('Nasi', 'neutral'), ('Sateh', 'neutral')
) AS t(name, gender);

-- Oud-Hollands
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-nostalgic') FROM (VALUES
    ('Aaltje', 'female'), ('Berend', 'male'), ('Dirk', 'male'), ('Evert', 'male'), ('Gerrit', 'male'),
    ('Hilde', 'female'), ('Janus', 'male'), ('Kee', 'female'), ('Lammert', 'male'), ('Leentje', 'female'),
    ('Mees', 'male'), ('Niek', 'male'), ('Pietje', 'male'), ('Renske', 'female'), ('Sientje', 'female'),
    ('Tinus', 'male'), ('Truus', 'female'), ('Willem', 'male'), ('Wies', 'female'), ('Zeger', 'male'),
    ('Aagje', 'female'), ('Barend', 'male'), ('Dirkje', 'female'), ('Geertje', 'female'), ('Grietje', 'female'),
    ('Hannes', 'male'), ('Hendrik', 'male'), ('Jantje', 'male'), ('Klasina', 'female'), ('Klaas', 'male'),
    ('Maartje', 'female'), ('Marrigje', 'female'), ('Neeltje', 'female'), ('Ot', 'male'), ('Sien', 'female'),
    ('Teuntje', 'female'), ('Trijntje', 'female'), ('Wessel', 'male'), ('Wiebe', 'male'), ('Wolter', 'male')
) AS t(name, gender);

-- Natuur & Buiten
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-nature') FROM (VALUES
    ('Berk', 'neutral'), ('Breeze', 'female'), ('Dauw', 'female'), ('Duin', 'neutral'), ('Hazel', 'female'),
    ('Ivy', 'female'), ('Kiezel', 'neutral'), ('Mos', 'neutral'), ('Nova', 'female'), ('Regen', 'neutral'),
    ('Rivier', 'neutral'), ('Stormy', 'neutral'), ('Vink', 'neutral'), ('Wilg', 'female'), ('Zon', 'neutral'),
    ('Amber', 'female'), ('Bloem', 'female'), ('Bos', 'neutral'), ('Braam', 'neutral'), ('Distel', 'neutral'),
    ('Egel', 'neutral'), ('Heide', 'female'), ('Kastanje', 'neutral'), ('Klaver', 'neutral'), ('Koraal', 'neutral'),
    ('Lelie', 'female'), ('Maan', 'female'), ('Parel', 'female'), ('Schelp', 'neutral'), ('Sneeuw', 'female'),
    ('Ster', 'female'), ('Veer', 'neutral'), ('Vos', 'neutral'), ('Wolk', 'neutral'), ('Zee', 'neutral'),
    ('Zand', 'neutral'), ('Eik', 'neutral'), ('Beek', 'neutral'), ('Linde', 'female'), ('Vlinder', 'female')
) AS t(name, gender);

-- Koosnamen
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-petnicknames') FROM (VALUES
    ('Beertje', 'neutral'), ('Bolleboos', 'neutral'), ('Lieverd', 'neutral'), ('Maatje', 'neutral'), ('Schatje', 'neutral'),
    ('Snuffel', 'neutral'), ('Snoetje', 'neutral'), ('Vriendje', 'male'), ('Boefje', 'neutral'), ('Knuffie', 'neutral'),
    ('Liefje', 'neutral'), ('Poepie', 'neutral'), ('Scheetje', 'neutral'), ('Snuitje', 'neutral'), ('Ukkie', 'neutral'),
    ('Ventje', 'male'), ('Vrouwtje', 'female'), ('Bolleke', 'neutral'), ('Dikkertje', 'neutral'), ('Dotje', 'neutral'),
    ('Engeltje', 'neutral'), ('Hartje', 'neutral'), ('Hondje', 'neutral'), ('Kaboutertje', 'neutral'), ('Kleintje', 'neutral'),
    ('Knorretje', 'neutral'), ('Lammetje', 'neutral'), ('Moppetje', 'neutral'), ('Poezel', 'neutral'), ('Propje', 'neutral'),
    ('Sterretje', 'neutral'), ('Zonnetje', 'neutral')
) AS t(name, gender);

-- =====================================================
-- ENGLISH NAMES
-- =====================================================

-- Cute & Sweet
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-cute') FROM (VALUES
    ('Bella', 'female'), ('Buddy', 'male'), ('Coco', 'neutral'), ('Daisy', 'female'), ('Honey', 'female'),
    ('Luna', 'female'), ('Milo', 'male'), ('Molly', 'female'), ('Nala', 'female'), ('Poppy', 'female'),
    ('Rosie', 'female'), ('Teddy', 'male'), ('Willow', 'female'), ('Biscuit', 'neutral'), ('Peanut', 'neutral'),
    ('Pumpkin', 'neutral'), ('Snowy', 'neutral'), ('Sunny', 'neutral'), ('Muffin', 'neutral'), ('Cupcake', 'female'),
    ('Buttercup', 'female'), ('Bubbles', 'neutral'), ('Fluffy', 'neutral'), ('Toffee', 'neutral'), ('Marshmallow', 'neutral'),
    ('Cookie', 'neutral'), ('Ginger', 'female'), ('Bambi', 'female'), ('Cinnamon', 'neutral'), ('Dolly', 'female'),
    ('Fifi', 'female'), ('Lulu', 'female'), ('Peaches', 'female'), ('Pixie', 'female'), ('Precious', 'female'),
    ('Princess', 'female'), ('Snickers', 'neutral'), ('Snowball', 'neutral'), ('Sprinkles', 'neutral'), ('Sugar', 'female'),
    ('Sweetpea', 'female'), ('Tinkerbell', 'female'), ('Twinkle', 'neutral'), ('Velvet', 'female'), ('Whiskers', 'neutral')
) AS t(name, gender);

-- Short & Strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-strong') FROM (VALUES
    ('Ace', 'male'), ('Axel', 'male'), ('Bear', 'male'), ('Blaze', 'male'), ('Bolt', 'male'),
    ('Cash', 'male'), ('Dex', 'male'), ('Diesel', 'male'), ('Duke', 'male'), ('Finn', 'male'),
    ('Jax', 'male'), ('Kai', 'neutral'), ('Max', 'male'), ('Neo', 'male'), ('Oz', 'male'),
    ('Rex', 'male'), ('Rocky', 'male'), ('Spike', 'male'), ('Tank', 'male'), ('Thor', 'male'),
    ('Wolf', 'male'), ('Zane', 'male'), ('Bruno', 'male'), ('Chase', 'male'), ('Colt', 'male'),
    ('Fang', 'male'), ('Flash', 'male'), ('Gunner', 'male'), ('Hunter', 'male'), ('King', 'male'),
    ('Knox', 'male'), ('Maverick', 'male'), ('Onyx', 'neutral'), ('Ranger', 'male'), ('Rebel', 'male'),
    ('Rocco', 'male'), ('Rogue', 'neutral'), ('Titan', 'male'), ('Trooper', 'male'), ('Zeus', 'male'),
    ('Bruiser', 'male'), ('Chief', 'male'), ('Bandit', 'male'), ('Shadow', 'neutral'), ('Blade', 'male')
) AS t(name, gender);

-- Classic Names
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-classic') FROM (VALUES
    ('Charlie', 'male'), ('Jack', 'male'), ('Lucy', 'female'), ('Oscar', 'male'), ('Oliver', 'male'),
    ('Ruby', 'female'), ('Sam', 'male'), ('Sadie', 'female'), ('Toby', 'male'), ('Lily', 'female'),
    ('Henry', 'male'), ('Leo', 'male'), ('George', 'male'), ('Archie', 'male'), ('Alfie', 'male'),
    ('Millie', 'female'), ('Theo', 'male'), ('Ellie', 'female'), ('Harry', 'male'), ('Emily', 'female'),
    ('Freddie', 'male'), ('Hazel', 'female'), ('Bailey', 'neutral'), ('Benny', 'male'), ('Bonnie', 'female'),
    ('Chester', 'male'), ('Chloe', 'female'), ('Gracie', 'female'), ('Jake', 'male'), ('Jasper', 'male'),
    ('Katie', 'female'), ('Maggie', 'female'), ('Murphy', 'male'), ('Penny', 'female'), ('Riley', 'neutral'),
    ('Sophie', 'female'), ('Tucker', 'male'), ('Winston', 'male'), ('Zoe', 'female'), ('Abby', 'female'),
    ('Cooper', 'male')
) AS t(name, gender);

-- Funny & Playful
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-funny') FROM (VALUES
    ('Banjo', 'neutral'), ('Bean', 'neutral'), ('Bingo', 'neutral'), ('Boomer', 'male'), ('Chewie', 'neutral'),
    ('Chonk', 'neutral'), ('Doodle', 'neutral'), ('Goose', 'neutral'), ('Gizmo', 'neutral'), ('Hamlet', 'male'),
    ('Muppet', 'neutral'), ('Noodle', 'neutral'), ('Pickles', 'neutral'), ('Pudding', 'neutral'), ('Sausage', 'neutral'),
    ('Snoopy', 'male'), ('Spud', 'neutral'), ('Taco', 'neutral'), ('Wiggles', 'neutral'), ('Waffles', 'neutral'),
    ('Zippy', 'neutral'), ('Bacon', 'neutral'), ('Bork', 'neutral'), ('Burrito', 'neutral'), ('Chaos', 'neutral'),
    ('Churro', 'neutral'), ('Dumpling', 'neutral'), ('Frito', 'neutral'), ('Hodor', 'male'), ('Kazoo', 'neutral'),
    ('Meatball', 'neutral'), ('Nacho', 'neutral'), ('Nugget', 'neutral'), ('Oreo', 'neutral'), ('Pogo', 'neutral'),
    ('Pretzel', 'neutral'), ('Ramen', 'neutral'), ('Scooter', 'neutral'), ('Tofu', 'neutral'), ('Twinkie', 'neutral'),
    ('Wobble', 'neutral'), ('Yoda', 'male'), ('Potato', 'neutral'), ('Dobby', 'male'), ('Gremlin', 'neutral')
) AS t(name, gender);

-- Vintage & Old-School
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-vintage') FROM (VALUES
    ('Alfred', 'male'), ('Arthur', 'male'), ('Beatrice', 'female'), ('Betsy', 'female'), ('Cecil', 'male'),
    ('Clara', 'female'), ('Edgar', 'male'), ('Ethel', 'female'), ('Florence', 'female'), ('Frank', 'male'),
    ('Harold', 'male'), ('Hattie', 'female'), ('Ivy', 'female'), ('Mabel', 'female'), ('Minnie', 'female'),
    ('Norman', 'male'), ('Otis', 'male'), ('Pearl', 'female'), ('Stanley', 'male'), ('Walter', 'male'),
    ('Agnes', 'female'), ('Albert', 'male'), ('Barnaby', 'male'), ('Bertha', 'female'), ('Clyde', 'male'),
    ('Cornelius', 'male'), ('Dorothy', 'female'), ('Edmund', 'male'), ('Eleanor', 'female'), ('Ernest', 'male'),
    ('Gertrude', 'female'), ('Gilbert', 'male'), ('Gladys', 'female'), ('Herbert', 'male'), ('Josephine', 'female'),
    ('Leonard', 'male'), ('Mildred', 'female'), ('Reginald', 'male'), ('Theodore', 'male'), ('Violet', 'female'),
    ('Winifred', 'female'), ('Archibald', 'male'), ('Edith', 'female'), ('Mortimer', 'male')
) AS t(name, gender);

-- Nature Inspired
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-nature') FROM (VALUES
    ('Ash', 'neutral'), ('Breeze', 'female'), ('Cedar', 'neutral'), ('Clover', 'neutral'), ('Daisy', 'female'),
    ('Ember', 'female'), ('Fern', 'female'), ('Forest', 'neutral'), ('Hazel', 'female'), ('Ivy', 'female'),
    ('Juniper', 'female'), ('Maple', 'neutral'), ('Mist', 'neutral'), ('Moon', 'neutral'), ('Oakley', 'neutral'),
    ('River', 'neutral'), ('Sky', 'neutral'), ('Storm', 'neutral'), ('Sunny', 'neutral'), ('Willow', 'female'),
    ('Aurora', 'female'), ('Birch', 'neutral'), ('Blossom', 'female'), ('Brook', 'neutral'), ('Canyon', 'neutral'),
    ('Cloud', 'neutral'), ('Coral', 'female'), ('Dawn', 'female'), ('Dusk', 'neutral'), ('Everest', 'neutral'),
    ('Flame', 'neutral'), ('Flint', 'male'), ('Jasmine', 'female'), ('Lake', 'neutral'), ('Meadow', 'female'),
    ('Misty', 'female'), ('Pebble', 'neutral'), ('Rain', 'neutral'), ('Sage', 'neutral'), ('Sierra', 'female'),
    ('Star', 'neutral'), ('Stone', 'neutral'), ('Thunder', 'male'), ('Winter', 'neutral'), ('Zinnia', 'female')
) AS t(name, gender);

-- Pet Nicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'english-petnicknames') FROM (VALUES
    ('Baby', 'neutral'), ('Boo', 'neutral'), ('Bubba', 'male'), ('Buddy', 'male'), ('Cuddles', 'neutral'),
    ('Cutie', 'neutral'), ('Furball', 'neutral'), ('Honeybun', 'neutral'), ('Lovey', 'neutral'), ('Munchkin', 'neutral'),
    ('Pookie', 'neutral'), ('Snuggles', 'neutral'), ('Sweetie', 'neutral'), ('Tiny', 'neutral'), ('Angel', 'neutral'),
    ('Fluff', 'neutral'), ('Sugar', 'neutral'), ('Peaches', 'female'), ('Babycakes', 'neutral'), ('Babe', 'neutral'),
    ('Booger', 'neutral'), ('Bubby', 'neutral'), ('Bunny', 'neutral'), ('Buttercup', 'female'), ('Champ', 'male'),
    ('Chunk', 'neutral'), ('Cuddlebug', 'neutral'), ('Ducky', 'neutral'), ('Fuzzy', 'neutral'), ('Handsome', 'male'),
    ('Junior', 'male'), ('Ladybug', 'female'), ('Lovebug', 'neutral'), ('Peanut', 'neutral'), ('Precious', 'female'),
    ('Pudge', 'neutral'), ('Pup', 'neutral'), ('Rascal', 'neutral'), ('Scamp', 'neutral'), ('Smooch', 'neutral'),
    ('Squirt', 'neutral'), ('Stinker', 'neutral'), ('Sweetums', 'neutral'), ('Whiskers', 'neutral')
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

-- =====================================================
-- SUMMARY
-- =====================================================
-- Dutch: 7 subsets, ~295 names
-- English: 7 subsets, ~310 names
-- Total: 14 subsets, ~605 names
-- =====================================================
