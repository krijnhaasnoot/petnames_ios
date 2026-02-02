-- =====================================================
-- Dutch Petnames - Complete Seed Data
-- Run this in Supabase SQL Editor
-- =====================================================

-- First, clear existing data
DELETE FROM swipes;
DELETE FROM names;
DELETE FROM name_sets;

-- =====================================================
-- CREATE DUTCH SUBSETS
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
-- 1. LIEF & SCHATTIG (dutch-cute)
-- Zachte, lieve namen voor jonge of kleine huisdieren
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-cute')
FROM (VALUES
    ('Puk', 'neutral'),
    ('Pip', 'neutral'),
    ('Pippa', 'female'),
    ('Poppy', 'female'),
    ('Bink', 'neutral'),
    ('Bo', 'neutral'),
    ('Bowie', 'neutral'),
    ('Bibi', 'female'),
    ('Bono', 'male'),
    ('Dot', 'female'),
    ('Doortje', 'female'),
    ('Fiep', 'female'),
    ('Fien', 'female'),
    ('Fleur', 'female'),
    ('Guusje', 'female'),
    ('Izzy', 'neutral'),
    ('Kiki', 'female'),
    ('Koko', 'neutral'),
    ('Lotje', 'female'),
    ('Luna', 'female'),
    ('Mimi', 'female'),
    ('Moppie', 'neutral'),
    ('Noortje', 'female'),
    ('Pluk', 'neutral'),
    ('Puck', 'neutral'),
    ('Snuf', 'neutral'),
    ('Snoes', 'female'),
    ('Teddy', 'male'),
    ('Tommie', 'male'),
    ('Woezel', 'neutral'),
    ('Ziggy', 'neutral'),
    ('Bella', 'female'),
    ('Lola', 'female'),
    ('Nala', 'female'),
    ('Suki', 'female'),
    ('Coco', 'female'),
    ('Pixie', 'female'),
    ('Dottie', 'female'),
    ('Minnie', 'female'),
    ('Trixie', 'female'),
    ('Floortje', 'female'),
    ('Snoepje', 'neutral'),
    ('Dotje', 'female'),
    ('Vlekje', 'neutral'),
    ('Pluisje', 'neutral'),
    ('Kruimel', 'neutral')
) AS t(name, gender);

-- =====================================================
-- 2. KORT & STOER (dutch-tough)
-- Korte, krachtige namen met een stoer randje
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-tough')
FROM (VALUES
    ('Boaz', 'male'),
    ('Bram', 'male'),
    ('Dex', 'male'),
    ('Diesel', 'male'),
    ('Duke', 'male'),
    ('Finn', 'male'),
    ('Gijs', 'male'),
    ('Henk', 'male'),
    ('Jack', 'male'),
    ('Joep', 'male'),
    ('Kees', 'male'),
    ('Koda', 'neutral'),
    ('Leo', 'male'),
    ('Max', 'male'),
    ('Moos', 'male'),
    ('Otis', 'male'),
    ('Rex', 'male'),
    ('Rocky', 'male'),
    ('Sam', 'male'),
    ('Spike', 'male'),
    ('Storm', 'male'),
    ('Teun', 'male'),
    ('Thor', 'male'),
    ('Ties', 'male'),
    ('Timo', 'male'),
    ('Tygo', 'male'),
    ('Wolf', 'male'),
    ('Ace', 'male'),
    ('Blitz', 'male'),
    ('Bruno', 'male'),
    ('Cash', 'male'),
    ('Chase', 'male'),
    ('Colt', 'male'),
    ('Fang', 'male'),
    ('Flash', 'male'),
    ('Hunter', 'male'),
    ('Jax', 'male'),
    ('Kane', 'male'),
    ('King', 'male'),
    ('Ranger', 'male'),
    ('Rebel', 'male'),
    ('Rocco', 'male'),
    ('Tank', 'male'),
    ('Titan', 'male'),
    ('Zeus', 'male')
) AS t(name, gender);

-- =====================================================
-- 3. KLASSIEK NEDERLANDS (dutch-classic)
-- Tijdloze Nederlandse namen, vertrouwd en warm
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-classic')
FROM (VALUES
    ('Annie', 'female'),
    ('Betsy', 'female'),
    ('Brammetje', 'male'),
    ('Cato', 'female'),
    ('Daantje', 'male'),
    ('Eef', 'neutral'),
    ('Evi', 'female'),
    ('Guus', 'male'),
    ('Harrie', 'male'),
    ('Ineke', 'female'),
    ('Jip', 'neutral'),
    ('Joost', 'male'),
    ('Karel', 'male'),
    ('Lies', 'female'),
    ('Lotte', 'female'),
    ('Mies', 'female'),
    ('Nelis', 'male'),
    ('Pleun', 'female'),
    ('Rik', 'male'),
    ('Roos', 'female'),
    ('Saar', 'female'),
    ('Siep', 'male'),
    ('Tijn', 'male'),
    ('Wim', 'male'),
    ('Wout', 'male'),
    ('Bep', 'female'),
    ('Cor', 'male'),
    ('Daan', 'male'),
    ('Fem', 'female'),
    ('Jaap', 'male'),
    ('Jan', 'male'),
    ('Jet', 'female'),
    ('Koos', 'male'),
    ('Maan', 'female'),
    ('Piet', 'male'),
    ('Sjef', 'male'),
    ('Stef', 'male'),
    ('Toos', 'female'),
    ('Ans', 'female'),
    ('Bas', 'male'),
    ('Cas', 'male'),
    ('Leen', 'male'),
    ('Miep', 'female'),
    ('Nel', 'female'),
    ('Riet', 'female')
) AS t(name, gender);

-- =====================================================
-- 4. SPEELS & GRAPPIG (dutch-funny)
-- Namen met humor en een knipoog
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-funny')
FROM (VALUES
    ('Appie', 'neutral'),
    ('Bam', 'neutral'),
    ('Binkie', 'neutral'),
    ('Boef', 'male'),
    ('Bolle', 'neutral'),
    ('Chico', 'male'),
    ('Droppie', 'neutral'),
    ('Flip', 'male'),
    ('Flodder', 'neutral'),
    ('Gekkie', 'neutral'),
    ('Knor', 'neutral'),
    ('Kroket', 'neutral'),
    ('Loebas', 'male'),
    ('Muppet', 'neutral'),
    ('Nijntje', 'neutral'),
    ('Pannenkoek', 'neutral'),
    ('Poffertje', 'neutral'),
    ('Snickers', 'neutral'),
    ('Spetter', 'neutral'),
    ('Stuiter', 'neutral'),
    ('Toffee', 'neutral'),
    ('Wafel', 'neutral'),
    ('Brokje', 'neutral'),
    ('Doerak', 'male'),
    ('Flierefluiter', 'male'),
    ('Frekkel', 'neutral'),
    ('Gumbo', 'neutral'),
    ('Jansen', 'neutral'),
    ('Kabouter', 'male'),
    ('Knabbel', 'neutral'),
    ('Kwispel', 'neutral'),
    ('Oliebol', 'neutral'),
    ('Pinda', 'neutral'),
    ('Rakker', 'male'),
    ('Ratje', 'neutral'),
    ('Slungel', 'male'),
    ('Spruit', 'neutral'),
    ('Stamppot', 'neutral'),
    ('Stroopwafel', 'neutral'),
    ('Wiebel', 'neutral'),
    ('Wobbel', 'neutral'),
    ('Bami', 'neutral'),
    ('Nasi', 'neutral'),
    ('Sateh', 'neutral')
) AS t(name, gender);

-- =====================================================
-- 5. OUD-HOLLANDS (dutch-nostalgic)
-- Ouderwetse, nostalgische Nederlandse namen
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-nostalgic')
FROM (VALUES
    ('Aaltje', 'female'),
    ('Berend', 'male'),
    ('Dirk', 'male'),
    ('Evert', 'male'),
    ('Gerrit', 'male'),
    ('Hilde', 'female'),
    ('Janus', 'male'),
    ('Kee', 'female'),
    ('Lammert', 'male'),
    ('Leentje', 'female'),
    ('Mees', 'male'),
    ('Niek', 'male'),
    ('Pietje', 'male'),
    ('Renske', 'female'),
    ('Sientje', 'female'),
    ('Tinus', 'male'),
    ('Truus', 'female'),
    ('Willem', 'male'),
    ('Wies', 'female'),
    ('Zeger', 'male'),
    ('Aagje', 'female'),
    ('Barend', 'male'),
    ('Dirkje', 'female'),
    ('Geertje', 'female'),
    ('Grietje', 'female'),
    ('Hannes', 'male'),
    ('Hendrik', 'male'),
    ('Jantje', 'male'),
    ('Klasina', 'female'),
    ('Klaas', 'male'),
    ('Maartje', 'female'),
    ('Marrigje', 'female'),
    ('Neeltje', 'female'),
    ('Ot', 'male'),
    ('Sien', 'female'),
    ('Teuntje', 'female'),
    ('Trijntje', 'female'),
    ('Wessel', 'male'),
    ('Wiebe', 'male'),
    ('Wolter', 'male')
) AS t(name, gender);

-- =====================================================
-- 6. NATUUR & BUITEN (dutch-nature)
-- Geïnspireerd door natuur, weer en buitenleven
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-nature')
FROM (VALUES
    ('Berk', 'neutral'),
    ('Breeze', 'female'),
    ('Dauw', 'female'),
    ('Duin', 'neutral'),
    ('Hazel', 'female'),
    ('Ivy', 'female'),
    ('Kiezel', 'neutral'),
    ('Mos', 'neutral'),
    ('Nova', 'female'),
    ('Regen', 'neutral'),
    ('Rivier', 'neutral'),
    ('Stormy', 'neutral'),
    ('Vink', 'neutral'),
    ('Wilg', 'female'),
    ('Zon', 'neutral'),
    ('Amber', 'female'),
    ('Bloem', 'female'),
    ('Bos', 'neutral'),
    ('Braam', 'neutral'),
    ('Distel', 'neutral'),
    ('Egel', 'neutral'),
    ('Heide', 'female'),
    ('Kastanje', 'neutral'),
    ('Klaver', 'neutral'),
    ('Koraal', 'neutral'),
    ('Lelie', 'female'),
    ('Maan', 'female'),
    ('Parel', 'female'),
    ('Schelp', 'neutral'),
    ('Sneeuw', 'female'),
    ('Ster', 'female'),
    ('Veer', 'neutral'),
    ('Vos', 'neutral'),
    ('Wolk', 'neutral'),
    ('Zee', 'neutral'),
    ('Zand', 'neutral'),
    ('Eik', 'neutral'),
    ('Beek', 'neutral'),
    ('Linde', 'female'),
    ('Vlinder', 'female')
) AS t(name, gender);

-- =====================================================
-- 7. KOOSNAMEN (dutch-petnicknames)
-- Typische Nederlandse koos- en dierennamen
-- =====================================================

INSERT INTO names (name, gender, set_id)
SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'dutch-petnicknames')
FROM (VALUES
    ('Beertje', 'neutral'),
    ('Bolleboos', 'neutral'),
    ('Lieverd', 'neutral'),
    ('Maatje', 'neutral'),
    ('Schatje', 'neutral'),
    ('Snuffel', 'neutral'),
    ('Snoetje', 'neutral'),
    ('Vriendje', 'male'),
    ('Boefje', 'neutral'),
    ('Knuffie', 'neutral'),
    ('Liefje', 'neutral'),
    ('Poepie', 'neutral'),
    ('Schatteansen', 'neutral'),
    ('Scheetje', 'neutral'),
    ('Snuitje', 'neutral'),
    ('Stansen', 'neutral'),
    ('Ukkie', 'neutral'),
    ('Ventje', 'male'),
    ('Vrouwtje', 'female'),
    ('Bolleke', 'neutral'),
    ('Dikkertje', 'neutral'),
    ('Dotje', 'neutral'),
    ('Engeltje', 'neutral'),
    ('Hartje', 'neutral'),
    ('Hondje', 'neutral'),
    ('Kaboutertje', 'neutral'),
    ('Kleintje', 'neutral'),
    ('Knorretje', 'neutral'),
    ('Lammetje', 'neutral'),
    ('Moppetje', 'neutral'),
    ('Poezel', 'neutral'),
    ('Propje', 'neutral'),
    ('Snuitje', 'neutral'),
    ('Sterretje', 'neutral'),
    ('Zonnetje', 'neutral')
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
ORDER BY ns.title;
