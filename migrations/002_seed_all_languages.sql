-- =====================================================
-- Complete Multi-Language Petnames Seed Data
-- 10 Languages × 7 Styles = 70 name_sets
-- Each set has 20+ names
-- =====================================================

-- Clear existing data (careful in production!)
DELETE FROM swipes;
DELETE FROM names;
DELETE FROM name_sets;

-- =====================================================
-- DUTCH (NL) - 7 SETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, description, language, style, is_free) VALUES
(gen_random_uuid(), 'pets_nl_cute', 'Lief & Schattig', 'Zachte, lieve namen die perfect zijn voor huisdieren', 'nl', 'cute', true),
(gen_random_uuid(), 'pets_nl_strong', 'Kort & Stoer', 'Korte, krachtige namen met een stoer randje', 'nl', 'strong', true),
(gen_random_uuid(), 'pets_nl_classic', 'Klassiek Nederlands', 'Tijdloze namen die vertrouwd en warm aanvoelen', 'nl', 'classic', true),
(gen_random_uuid(), 'pets_nl_funny', 'Speels & Grappig', 'Namen met humor en een knipoog', 'nl', 'funny', true),
(gen_random_uuid(), 'pets_nl_vintage', 'Oud-Hollands', 'Nostalgische, ouderwetse namen met karakter', 'nl', 'vintage', true),
(gen_random_uuid(), 'pets_nl_nature', 'Natuur & Buiten', 'Geïnspireerd door natuur, weer en buitenleven', 'nl', 'nature', true),
(gen_random_uuid(), 'pets_nl_petnicknames', 'Koosnamen', 'Liefkozende roepnamen en typische dierennamen', 'nl', 'petnicknames', true);

-- NL cute
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_nl_cute') FROM (VALUES
('Puk', 'neutral'), ('Pip', 'neutral'), ('Pippa', 'female'), ('Bink', 'neutral'), ('Bo', 'neutral'),
('Luna', 'female'), ('Fien', 'female'), ('Fleur', 'female'), ('Lotje', 'female'), ('Guusje', 'female'),
('Moppie', 'neutral'), ('Snoes', 'female'), ('Teddy', 'male'), ('Bella', 'female'), ('Nala', 'female'),
('Coco', 'neutral'), ('Pixie', 'female'), ('Dotje', 'neutral'), ('Snoepje', 'neutral'), ('Kruimel', 'neutral'),
('Honey', 'female'), ('Pluisje', 'neutral'), ('Vlekje', 'neutral'), ('Minnie', 'female'), ('Lola', 'female')
) AS t(name, gender);

-- NL strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_nl_strong') FROM (VALUES
('Max', 'male'), ('Rex', 'male'), ('Duke', 'male'), ('Thor', 'male'), ('Storm', 'male'),
('Diesel', 'male'), ('Rocky', 'male'), ('Spike', 'male'), ('Wolf', 'male'), ('Bruno', 'male'),
('Ace', 'male'), ('Tank', 'male'), ('Zeus', 'male'), ('King', 'male'), ('Titan', 'male'),
('Blitz', 'male'), ('Chase', 'male'), ('Hunter', 'male'), ('Ranger', 'male'), ('Rebel', 'male'),
('Flash', 'male'), ('Fang', 'male'), ('Rocco', 'male'), ('Colt', 'male'), ('Kane', 'male')
) AS t(name, gender);

-- NL classic
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_nl_classic') FROM (VALUES
('Charlie', 'male'), ('Sam', 'male'), ('Oscar', 'male'), ('Toby', 'male'), ('Jack', 'male'),
('Lucy', 'female'), ('Molly', 'female'), ('Daisy', 'female'), ('Ruby', 'female'), ('Lily', 'female'),
('Guus', 'male'), ('Teun', 'male'), ('Daan', 'male'), ('Lotte', 'female'), ('Saar', 'female'),
('Roos', 'female'), ('Jaap', 'male'), ('Piet', 'male'), ('Kees', 'male'), ('Jan', 'male'),
('Mies', 'female'), ('Jet', 'female'), ('Cor', 'male'), ('Wim', 'male'), ('Henk', 'male')
) AS t(name, gender);

-- NL funny
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_nl_funny') FROM (VALUES
('Boef', 'male'), ('Knor', 'neutral'), ('Kroket', 'neutral'), ('Droppie', 'neutral'), ('Wafel', 'neutral'),
('Muppet', 'neutral'), ('Spetter', 'neutral'), ('Snickers', 'neutral'), ('Poffertje', 'neutral'), ('Pannenkoek', 'neutral'),
('Bami', 'neutral'), ('Nasi', 'neutral'), ('Stamppot', 'neutral'), ('Oliebol', 'neutral'), ('Kabouter', 'male'),
('Rakker', 'male'), ('Doerak', 'male'), ('Wiebel', 'neutral'), ('Wobbel', 'neutral'), ('Gekkie', 'neutral'),
('Spruit', 'neutral'), ('Frekkel', 'neutral'), ('Kwispel', 'neutral'), ('Brokje', 'neutral'), ('Flip', 'male')
) AS t(name, gender);

-- NL vintage
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_nl_vintage') FROM (VALUES
('Berend', 'male'), ('Dirk', 'male'), ('Evert', 'male'), ('Gerrit', 'male'), ('Willem', 'male'),
('Truus', 'female'), ('Grietje', 'female'), ('Aaltje', 'female'), ('Neeltje', 'female'), ('Sientje', 'female'),
('Klaas', 'male'), ('Barend', 'male'), ('Hannes', 'male'), ('Hendrik', 'male'), ('Wessel', 'male'),
('Mabel', 'female'), ('Hilde', 'female'), ('Geertje', 'female'), ('Trijntje', 'female'), ('Leentje', 'female'),
('Ot', 'male'), ('Tinus', 'male'), ('Janus', 'male'), ('Zeger', 'male'), ('Wolter', 'male')
) AS t(name, gender);

-- NL nature
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_nl_nature') FROM (VALUES
('Bos', 'neutral'), ('Storm', 'neutral'), ('Maan', 'female'), ('Ster', 'female'), ('Zon', 'neutral'),
('Regen', 'neutral'), ('Sneeuw', 'female'), ('Wolk', 'neutral'), ('Hazel', 'female'), ('Ivy', 'female'),
('Bloem', 'female'), ('Klaver', 'neutral'), ('Vos', 'neutral'), ('Beek', 'neutral'), ('Berk', 'neutral'),
('Eik', 'neutral'), ('Amber', 'female'), ('Koraal', 'neutral'), ('Parel', 'female'), ('Veer', 'neutral'),
('Duin', 'neutral'), ('Zee', 'neutral'), ('Heide', 'female'), ('Linde', 'female'), ('Lelie', 'female')
) AS t(name, gender);

-- NL petnicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_nl_petnicknames') FROM (VALUES
('Schatje', 'neutral'), ('Liefje', 'neutral'), ('Beertje', 'neutral'), ('Snuffel', 'neutral'), ('Knuffie', 'neutral'),
('Poepie', 'neutral'), ('Ukkie', 'neutral'), ('Boefje', 'neutral'), ('Snoetje', 'neutral'), ('Maatje', 'neutral'),
('Dotje', 'neutral'), ('Engeltje', 'neutral'), ('Hartje', 'neutral'), ('Propje', 'neutral'), ('Sterretje', 'neutral'),
('Zonnetje', 'neutral'), ('Bolletje', 'neutral'), ('Ventje', 'male'), ('Poezel', 'neutral'), ('Snuitje', 'neutral'),
('Kleintje', 'neutral'), ('Vriendje', 'male'), ('Lieverd', 'neutral'), ('Lammetje', 'neutral'), ('Hondje', 'neutral')
) AS t(name, gender);

-- =====================================================
-- ENGLISH (EN) - 7 SETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, description, language, style, is_free) VALUES
(gen_random_uuid(), 'pets_en_cute', 'Cute & Sweet', 'Soft, lovable names with a friendly vibe', 'en', 'cute', true),
(gen_random_uuid(), 'pets_en_strong', 'Short & Strong', 'Short, punchy names with a strong sound', 'en', 'strong', true),
(gen_random_uuid(), 'pets_en_classic', 'Classic Names', 'Timeless names that feel familiar and warm', 'en', 'classic', true),
(gen_random_uuid(), 'pets_en_funny', 'Funny & Playful', 'Light-hearted names with humor and personality', 'en', 'funny', true),
(gen_random_uuid(), 'pets_en_vintage', 'Vintage & Old-School', 'Old-fashioned names with a nostalgic vibe', 'en', 'vintage', true),
(gen_random_uuid(), 'pets_en_nature', 'Nature Inspired', 'Names inspired by nature and the outdoors', 'en', 'nature', true),
(gen_random_uuid(), 'pets_en_petnicknames', 'Pet Nicknames', 'Affectionate nicknames and classic pet call-names', 'en', 'petnicknames', true);

-- EN cute
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_en_cute') FROM (VALUES
('Bella', 'female'), ('Buddy', 'male'), ('Coco', 'neutral'), ('Daisy', 'female'), ('Honey', 'female'),
('Luna', 'female'), ('Milo', 'male'), ('Molly', 'female'), ('Nala', 'female'), ('Poppy', 'female'),
('Rosie', 'female'), ('Teddy', 'male'), ('Willow', 'female'), ('Biscuit', 'neutral'), ('Peanut', 'neutral'),
('Pumpkin', 'neutral'), ('Muffin', 'neutral'), ('Cookie', 'neutral'), ('Ginger', 'female'), ('Pixie', 'female'),
('Lulu', 'female'), ('Dolly', 'female'), ('Twinkle', 'neutral'), ('Sprinkles', 'neutral'), ('Sugar', 'female')
) AS t(name, gender);

-- EN strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_en_strong') FROM (VALUES
('Ace', 'male'), ('Axel', 'male'), ('Bear', 'male'), ('Blaze', 'male'), ('Bolt', 'male'),
('Cash', 'male'), ('Dex', 'male'), ('Diesel', 'male'), ('Duke', 'male'), ('Finn', 'male'),
('Jax', 'male'), ('Kai', 'neutral'), ('Max', 'male'), ('Neo', 'male'), ('Rex', 'male'),
('Rocky', 'male'), ('Spike', 'male'), ('Tank', 'male'), ('Thor', 'male'), ('Wolf', 'male'),
('Zane', 'male'), ('Bruno', 'male'), ('Chase', 'male'), ('Gunner', 'male'), ('Maverick', 'male')
) AS t(name, gender);

-- EN classic
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_en_classic') FROM (VALUES
('Charlie', 'male'), ('Jack', 'male'), ('Lucy', 'female'), ('Oscar', 'male'), ('Oliver', 'male'),
('Ruby', 'female'), ('Sam', 'male'), ('Sadie', 'female'), ('Toby', 'male'), ('Lily', 'female'),
('Henry', 'male'), ('Leo', 'male'), ('George', 'male'), ('Archie', 'male'), ('Alfie', 'male'),
('Millie', 'female'), ('Ellie', 'female'), ('Harry', 'male'), ('Emily', 'female'), ('Bailey', 'neutral'),
('Bonnie', 'female'), ('Chester', 'male'), ('Jasper', 'male'), ('Murphy', 'male'), ('Sophie', 'female')
) AS t(name, gender);

-- EN funny
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_en_funny') FROM (VALUES
('Banjo', 'neutral'), ('Bean', 'neutral'), ('Bingo', 'neutral'), ('Chewie', 'neutral'), ('Chonk', 'neutral'),
('Doodle', 'neutral'), ('Goose', 'neutral'), ('Gizmo', 'neutral'), ('Muppet', 'neutral'), ('Noodle', 'neutral'),
('Pickles', 'neutral'), ('Pudding', 'neutral'), ('Sausage', 'neutral'), ('Snoopy', 'male'), ('Taco', 'neutral'),
('Waffles', 'neutral'), ('Zippy', 'neutral'), ('Bacon', 'neutral'), ('Nugget', 'neutral'), ('Potato', 'neutral'),
('Burrito', 'neutral'), ('Meatball', 'neutral'), ('Oreo', 'neutral'), ('Dobby', 'male'), ('Yoda', 'male')
) AS t(name, gender);

-- EN vintage
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_en_vintage') FROM (VALUES
('Alfred', 'male'), ('Arthur', 'male'), ('Beatrice', 'female'), ('Cecil', 'male'), ('Clara', 'female'),
('Edgar', 'male'), ('Ethel', 'female'), ('Florence', 'female'), ('Frank', 'male'), ('Harold', 'male'),
('Hattie', 'female'), ('Ivy', 'female'), ('Mabel', 'female'), ('Norman', 'male'), ('Otis', 'male'),
('Pearl', 'female'), ('Stanley', 'male'), ('Walter', 'male'), ('Winston', 'male'), ('Agnes', 'female'),
('Albert', 'male'), ('Dorothy', 'female'), ('Ernest', 'male'), ('Gertrude', 'female'), ('Theodore', 'male')
) AS t(name, gender);

-- EN nature
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_en_nature') FROM (VALUES
('Ash', 'neutral'), ('Breeze', 'female'), ('Cedar', 'neutral'), ('Clover', 'neutral'), ('Ember', 'female'),
('Fern', 'female'), ('Forest', 'neutral'), ('Hazel', 'female'), ('Ivy', 'female'), ('Juniper', 'female'),
('Maple', 'neutral'), ('Mist', 'neutral'), ('Moon', 'neutral'), ('Oakley', 'neutral'), ('River', 'neutral'),
('Sky', 'neutral'), ('Storm', 'neutral'), ('Sunny', 'neutral'), ('Willow', 'female'), ('Aurora', 'female'),
('Brook', 'neutral'), ('Dawn', 'female'), ('Meadow', 'female'), ('Rain', 'neutral'), ('Star', 'neutral')
) AS t(name, gender);

-- EN petnicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_en_petnicknames') FROM (VALUES
('Baby', 'neutral'), ('Boo', 'neutral'), ('Bubba', 'male'), ('Buddy', 'male'), ('Cuddles', 'neutral'),
('Cutie', 'neutral'), ('Furball', 'neutral'), ('Lovey', 'neutral'), ('Munchkin', 'neutral'), ('Pookie', 'neutral'),
('Snuggles', 'neutral'), ('Sweetie', 'neutral'), ('Tiny', 'neutral'), ('Angel', 'neutral'), ('Fluff', 'neutral'),
('Sugar', 'neutral'), ('Peaches', 'female'), ('Bunny', 'neutral'), ('Champ', 'male'), ('Fuzzy', 'neutral'),
('Junior', 'male'), ('Peanut', 'neutral'), ('Pup', 'neutral'), ('Rascal', 'neutral'), ('Whiskers', 'neutral')
) AS t(name, gender);

-- =====================================================
-- GERMAN (DE) - 7 SETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, description, language, style, is_free) VALUES
(gen_random_uuid(), 'pets_de_cute', 'Süß & Niedlich', 'Weiche, liebe Namen für Haustiere', 'de', 'cute', true),
(gen_random_uuid(), 'pets_de_strong', 'Kurz & Stark', 'Kurze, kräftige Namen mit Power', 'de', 'strong', true),
(gen_random_uuid(), 'pets_de_classic', 'Klassische Namen', 'Zeitlose Namen, vertraut und warm', 'de', 'classic', true),
(gen_random_uuid(), 'pets_de_funny', 'Witzig & Verspielt', 'Namen mit Humor und Charakter', 'de', 'funny', true),
(gen_random_uuid(), 'pets_de_vintage', 'Vintage & Altmodisch', 'Nostalgische Namen im Retro-Stil', 'de', 'vintage', true),
(gen_random_uuid(), 'pets_de_nature', 'Natur Inspiriert', 'Namen aus Natur, Wetter und Draußen', 'de', 'nature', true),
(gen_random_uuid(), 'pets_de_petnicknames', 'Tier-Kosenamen', 'Kosenamen und typische Rufnamen', 'de', 'petnicknames', true);

-- DE cute
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_de_cute') FROM (VALUES
('Mia', 'female'), ('Luna', 'female'), ('Bella', 'female'), ('Lilly', 'female'), ('Nala', 'female'),
('Emma', 'female'), ('Leni', 'female'), ('Mila', 'female'), ('Frieda', 'female'), ('Heidi', 'female'),
('Balu', 'male'), ('Teddy', 'male'), ('Flecki', 'neutral'), ('Schnuffi', 'neutral'), ('Krümel', 'neutral'),
('Püppi', 'female'), ('Flocke', 'neutral'), ('Stupsi', 'neutral'), ('Mäuschen', 'neutral'), ('Schnecke', 'female'),
('Hasi', 'neutral'), ('Bärchen', 'neutral'), ('Mopsi', 'neutral'), ('Wuschel', 'neutral'), ('Zuckermaus', 'female')
) AS t(name, gender);

-- DE strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_de_strong') FROM (VALUES
('Max', 'male'), ('Rex', 'male'), ('Thor', 'male'), ('Zeus', 'male'), ('Bruno', 'male'),
('Odin', 'male'), ('Rocko', 'male'), ('Blitz', 'male'), ('Hasso', 'male'), ('Arko', 'male'),
('Tyson', 'male'), ('Rocky', 'male'), ('Wotan', 'male'), ('Falk', 'male'), ('Bär', 'male'),
('Grimm', 'male'), ('Kraft', 'male'), ('Sturm', 'male'), ('Wolf', 'male'), ('Donner', 'male'),
('Ajax', 'male'), ('Brutus', 'male'), ('Cäsar', 'male'), ('Samson', 'male'), ('Goliath', 'male')
) AS t(name, gender);

-- DE classic
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_de_classic') FROM (VALUES
('Fritz', 'male'), ('Hans', 'male'), ('Karl', 'male'), ('Otto', 'male'), ('Paul', 'male'),
('Greta', 'female'), ('Anna', 'female'), ('Lisa', 'female'), ('Marie', 'female'), ('Sophie', 'female'),
('Felix', 'male'), ('Moritz', 'male'), ('Anton', 'male'), ('Emil', 'male'), ('Franz', 'male'),
('Klara', 'female'), ('Rosa', 'female'), ('Hanna', 'female'), ('Lena', 'female'), ('Nina', 'female'),
('Ludwig', 'male'), ('Heinrich', 'male'), ('Wilhelm', 'male'), ('Friedrich', 'male'), ('Albert', 'male')
) AS t(name, gender);

-- DE funny
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_de_funny') FROM (VALUES
('Schnitzel', 'neutral'), ('Brezel', 'neutral'), ('Strudel', 'neutral'), ('Wurst', 'neutral'), ('Knödel', 'neutral'),
('Pummel', 'neutral'), ('Quatsch', 'neutral'), ('Flummi', 'neutral'), ('Quiesel', 'neutral'), ('Schmusi', 'neutral'),
('Schnurzel', 'neutral'), ('Wusel', 'neutral'), ('Fips', 'neutral'), ('Pieps', 'neutral'), ('Schnaps', 'male'),
('Keks', 'neutral'), ('Kuchen', 'neutral'), ('Mops', 'male'), ('Dackel', 'male'), ('Waldi', 'male'),
('Fritzi', 'neutral'), ('Knopf', 'neutral'), ('Zipfel', 'neutral'), ('Zottel', 'neutral'), ('Racker', 'male')
) AS t(name, gender);

-- DE vintage
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_de_vintage') FROM (VALUES
('Adalbert', 'male'), ('Balduin', 'male'), ('Erwin', 'male'), ('Gottfried', 'male'), ('Herbert', 'male'),
('Hedwig', 'female'), ('Hildegard', 'female'), ('Brunhilde', 'female'), ('Gerda', 'female'), ('Ingrid', 'female'),
('Siegfried', 'male'), ('Waldemar', 'male'), ('Reinhold', 'male'), ('Horst', 'male'), ('Günter', 'male'),
('Elfriede', 'female'), ('Edeltraut', 'female'), ('Mechthild', 'female'), ('Roswitha', 'female'), ('Waltraud', 'female'),
('Konrad', 'male'), ('Leopold', 'male'), ('Oskar', 'male'), ('Theodor', 'male'), ('Viktor', 'male')
) AS t(name, gender);

-- DE nature
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_de_nature') FROM (VALUES
('Blume', 'female'), ('Wolke', 'female'), ('Sonne', 'female'), ('Stern', 'neutral'), ('Mond', 'male'),
('Wiese', 'female'), ('Bach', 'neutral'), ('Wald', 'male'), ('Berg', 'male'), ('See', 'neutral'),
('Birke', 'female'), ('Eiche', 'female'), ('Linde', 'female'), ('Tanne', 'female'), ('Fichte', 'female'),
('Nebel', 'neutral'), ('Regen', 'neutral'), ('Schnee', 'neutral'), ('Wind', 'neutral'), ('Tau', 'neutral'),
('Perle', 'female'), ('Koralle', 'female'), ('Muschel', 'female'), ('Feder', 'female'), ('Blatt', 'neutral')
) AS t(name, gender);

-- DE petnicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_de_petnicknames') FROM (VALUES
('Schatz', 'neutral'), ('Liebling', 'neutral'), ('Süße', 'female'), ('Mausi', 'female'), ('Hasi', 'neutral'),
('Schnucki', 'neutral'), ('Spatz', 'neutral'), ('Engel', 'neutral'), ('Bärchi', 'neutral'), ('Schnuffel', 'neutral'),
('Knuddel', 'neutral'), ('Kuschel', 'neutral'), ('Wuschel', 'neutral'), ('Strolch', 'male'), ('Frechdachs', 'male'),
('Kleiner', 'male'), ('Kleine', 'female'), ('Mäuschen', 'neutral'), ('Schneckchen', 'neutral'), ('Spätzchen', 'neutral'),
('Hündchen', 'neutral'), ('Kätzchen', 'neutral'), ('Häschen', 'neutral'), ('Vögelchen', 'neutral'), ('Schäfchen', 'neutral')
) AS t(name, gender);

-- =====================================================
-- FRENCH (FR) - 7 SETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, description, language, style, is_free) VALUES
(gen_random_uuid(), 'pets_fr_cute', 'Mignon & Doux', 'Des noms tendres et adorables', 'fr', 'cute', true),
(gen_random_uuid(), 'pets_fr_strong', 'Court & Fort', 'Des noms courts avec du caractère', 'fr', 'strong', true),
(gen_random_uuid(), 'pets_fr_classic', 'Noms Classiques', 'Des noms intemporels et chaleureux', 'fr', 'classic', true),
(gen_random_uuid(), 'pets_fr_funny', 'Drôle & Joueur', 'Des noms amusants et pleins de personnalité', 'fr', 'funny', true),
(gen_random_uuid(), 'pets_fr_vintage', 'Vintage & Rétro', 'Des noms rétro avec du charme', 'fr', 'vintage', true),
(gen_random_uuid(), 'pets_fr_nature', 'Inspiré par la Nature', 'Des noms inspirés de la nature et du plein air', 'fr', 'nature', true),
(gen_random_uuid(), 'pets_fr_petnicknames', 'Surnoms d''Animaux', 'Des surnoms affectueux et classiques', 'fr', 'petnicknames', true);

-- FR cute
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fr_cute') FROM (VALUES
('Mimi', 'female'), ('Loulou', 'neutral'), ('Caramel', 'neutral'), ('Noisette', 'female'), ('Praline', 'female'),
('Biscotte', 'female'), ('Cannelle', 'female'), ('Vanille', 'female'), ('Perle', 'female'), ('Bijou', 'neutral'),
('Pompon', 'neutral'), ('Câline', 'female'), ('Choupette', 'female'), ('Minette', 'female'), ('Papouille', 'neutral'),
('Poupette', 'female'), ('Filou', 'male'), ('Choupi', 'neutral'), ('Doudou', 'neutral'), ('Nounours', 'male'),
('Chipie', 'female'), ('Coquine', 'female'), ('Fripon', 'male'), ('Fripouille', 'neutral'), ('Trésor', 'neutral')
) AS t(name, gender);

-- FR strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fr_strong') FROM (VALUES
('Titan', 'male'), ('Rex', 'male'), ('Thor', 'male'), ('Zeus', 'male'), ('Max', 'male'),
('César', 'male'), ('Brutus', 'male'), ('Hercule', 'male'), ('Rocky', 'male'), ('Rambo', 'male'),
('Boss', 'male'), ('Chief', 'male'), ('King', 'male'), ('Prince', 'male'), ('Duke', 'male'),
('Storm', 'male'), ('Flash', 'male'), ('Foudre', 'male'), ('Tonnerre', 'male'), ('Ouragan', 'male'),
('Baron', 'male'), ('Diesel', 'male'), ('Rocket', 'male'), ('Turbo', 'male'), ('Viper', 'male')
) AS t(name, gender);

-- FR classic
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fr_classic') FROM (VALUES
('Félix', 'male'), ('Oscar', 'male'), ('Léo', 'male'), ('Charlie', 'male'), ('Minou', 'male'),
('Minette', 'female'), ('Mistigri', 'male'), ('Gribouille', 'neutral'), ('Médor', 'male'), ('Sultan', 'male'),
('Théo', 'male'), ('Hugo', 'male'), ('Jules', 'male'), ('Louis', 'male'), ('Arthur', 'male'),
('Maya', 'female'), ('Chloé', 'female'), ('Emma', 'female'), ('Léa', 'female'), ('Zoé', 'female'),
('Gaston', 'male'), ('Marcel', 'male'), ('Pierre', 'male'), ('Jacques', 'male'), ('Henri', 'male')
) AS t(name, gender);

-- FR funny
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fr_funny') FROM (VALUES
('Croissant', 'neutral'), ('Baguette', 'female'), ('Macaron', 'neutral'), ('Éclair', 'neutral'), ('Crêpe', 'neutral'),
('Tartiflette', 'female'), ('Camembert', 'male'), ('Roquefort', 'male'), ('Brie', 'neutral'), ('Cheddar', 'neutral'),
('Gaufre', 'female'), ('Pancake', 'neutral'), ('Brioche', 'female'), ('Croûton', 'male'), ('Moustache', 'neutral'),
('Patate', 'female'), ('Cornichon', 'male'), ('Saucisse', 'female'), ('Boudin', 'male'), ('Jambon', 'male'),
('Truffe', 'female'), ('Croquette', 'female'), ('Pâté', 'neutral'), ('Rillette', 'female'), ('Mousse', 'female')
) AS t(name, gender);

-- FR vintage
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fr_vintage') FROM (VALUES
('Alphonse', 'male'), ('Barnabé', 'male'), ('Célestin', 'male'), ('Edmond', 'male'), ('Fernand', 'male'),
('Augustine', 'female'), ('Blanche', 'female'), ('Clémence', 'female'), ('Eugénie', 'female'), ('Hortense', 'female'),
('Gustave', 'male'), ('Hippolyte', 'male'), ('Isidore', 'male'), ('Léopold', 'male'), ('Maurice', 'male'),
('Joséphine', 'female'), ('Léontine', 'female'), ('Marguerite', 'female'), ('Paulette', 'female'), ('Suzanne', 'female'),
('Aristide', 'male'), ('Balthazar', 'male'), ('Constant', 'male'), ('Dieudonné', 'male'), ('Théophile', 'male')
) AS t(name, gender);

-- FR nature
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fr_nature') FROM (VALUES
('Soleil', 'male'), ('Lune', 'female'), ('Étoile', 'female'), ('Nuage', 'male'), ('Ciel', 'male'),
('Fleur', 'female'), ('Rose', 'female'), ('Violette', 'female'), ('Marguerite', 'female'), ('Jasmin', 'male'),
('Océan', 'male'), ('Rivière', 'female'), ('Cascade', 'female'), ('Lac', 'male'), ('Source', 'female'),
('Forêt', 'female'), ('Sapin', 'male'), ('Chêne', 'male'), ('Bouleau', 'male'), ('Lilas', 'neutral'),
('Brume', 'female'), ('Aurore', 'female'), ('Tempête', 'female'), ('Orage', 'male'), ('Écume', 'female')
) AS t(name, gender);

-- FR petnicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fr_petnicknames') FROM (VALUES
('Chouchou', 'neutral'), ('Mon Cœur', 'neutral'), ('Ma Puce', 'female'), ('Mon Loulou', 'male'), ('Ma Belle', 'female'),
('Bébé', 'neutral'), ('Ange', 'neutral'), ('Toutou', 'male'), ('Minou', 'male'), ('Pitou', 'male'),
('Boubou', 'neutral'), ('Kiki', 'neutral'), ('Gigi', 'neutral'), ('Fifi', 'neutral'), ('Bibi', 'neutral'),
('Titi', 'neutral'), ('Riri', 'neutral'), ('Lili', 'neutral'), ('Nini', 'neutral'), ('Zizi', 'neutral'),
('Pépère', 'male'), ('Mémère', 'female'), ('Papounet', 'male'), ('Mamounette', 'female'), ('Bout de Chou', 'neutral')
) AS t(name, gender);

-- =====================================================
-- SPANISH (ES) - 7 SETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, description, language, style, is_free) VALUES
(gen_random_uuid(), 'pets_es_cute', 'Dulce & Tierno', 'Nombres suaves y adorables', 'es', 'cute', true),
(gen_random_uuid(), 'pets_es_strong', 'Corto & Fuerte', 'Nombres cortos con carácter', 'es', 'strong', true),
(gen_random_uuid(), 'pets_es_classic', 'Nombres Clásicos', 'Nombres atemporales y cercanos', 'es', 'classic', true),
(gen_random_uuid(), 'pets_es_funny', 'Divertido & Juguetón', 'Nombres con humor y personalidad', 'es', 'funny', true),
(gen_random_uuid(), 'pets_es_vintage', 'Vintage & Retro', 'Nombres retro con encanto', 'es', 'vintage', true),
(gen_random_uuid(), 'pets_es_nature', 'Inspirado en la Naturaleza', 'Nombres de la naturaleza y el aire libre', 'es', 'nature', true),
(gen_random_uuid(), 'pets_es_petnicknames', 'Apodos de Mascotas', 'Apodos cariñosos y nombres típicos', 'es', 'petnicknames', true);

-- ES cute
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_es_cute') FROM (VALUES
('Luna', 'female'), ('Coco', 'neutral'), ('Miel', 'female'), ('Canela', 'female'), ('Dulce', 'female'),
('Bombón', 'neutral'), ('Caramelo', 'neutral'), ('Pelusa', 'neutral'), ('Copito', 'male'), ('Nube', 'female'),
('Chispa', 'female'), ('Estrella', 'female'), ('Perla', 'female'), ('Princesa', 'female'), ('Reina', 'female'),
('Cariño', 'neutral'), ('Corazón', 'neutral'), ('Tesoro', 'neutral'), ('Cielo', 'neutral'), ('Sol', 'neutral'),
('Bolita', 'neutral'), ('Pompón', 'neutral'), ('Peluchín', 'neutral'), ('Algodón', 'neutral'), ('Rosita', 'female')
) AS t(name, gender);

-- ES strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_es_strong') FROM (VALUES
('Rex', 'male'), ('Thor', 'male'), ('Zeus', 'male'), ('Max', 'male'), ('Rocky', 'male'),
('Bravo', 'male'), ('Toro', 'male'), ('León', 'male'), ('Tigre', 'male'), ('Lobo', 'male'),
('Rayo', 'male'), ('Trueno', 'male'), ('Fuerza', 'male'), ('Valiente', 'male'), ('Jefe', 'male'),
('Duque', 'male'), ('Rey', 'male'), ('Sultán', 'male'), ('Príncipe', 'male'), ('César', 'male'),
('Goliat', 'male'), ('Titán', 'male'), ('Hércules', 'male'), ('Sansón', 'male'), ('Guerrero', 'male')
) AS t(name, gender);

-- ES classic
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_es_classic') FROM (VALUES
('Toby', 'male'), ('Max', 'male'), ('Lucas', 'male'), ('Bruno', 'male'), ('Simón', 'male'),
('Luna', 'female'), ('Lola', 'female'), ('Nina', 'female'), ('Chica', 'female'), ('Bella', 'female'),
('Paco', 'male'), ('Pepe', 'male'), ('Curro', 'male'), ('Manolo', 'male'), ('Pancho', 'male'),
('María', 'female'), ('Carmen', 'female'), ('Rocío', 'female'), ('Pilar', 'female'), ('Rosa', 'female'),
('Antonio', 'male'), ('Francisco', 'male'), ('José', 'male'), ('Miguel', 'male'), ('Pedro', 'male')
) AS t(name, gender);

-- ES funny
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_es_funny') FROM (VALUES
('Churro', 'neutral'), ('Taco', 'neutral'), ('Nacho', 'male'), ('Burrito', 'neutral'), ('Quesito', 'neutral'),
('Chorizo', 'male'), ('Jamón', 'male'), ('Morcilla', 'female'), ('Tortilla', 'female'), ('Paella', 'female'),
('Flan', 'neutral'), ('Gazpacho', 'neutral'), ('Salsa', 'female'), ('Guacamole', 'neutral'), ('Tapas', 'neutral'),
('Patata', 'female'), ('Pepino', 'male'), ('Tomate', 'male'), ('Zanahoria', 'female'), ('Cebolla', 'female'),
('Bigotes', 'male'), ('Manchas', 'neutral'), ('Peludo', 'male'), ('Gordito', 'male'), ('Travieso', 'male')
) AS t(name, gender);

-- ES vintage
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_es_vintage') FROM (VALUES
('Abundio', 'male'), ('Baldomero', 'male'), ('Casimiro', 'male'), ('Dionisio', 'male'), ('Emeterio', 'male'),
('Agustina', 'female'), ('Bonifacia', 'female'), ('Celestina', 'female'), ('Dolores', 'female'), ('Encarnación', 'female'),
('Fermín', 'male'), ('Gregorio', 'male'), ('Hilario', 'male'), ('Isidro', 'male'), ('Jacinto', 'male'),
('Gertrudis', 'female'), ('Herminia', 'female'), ('Ifigenia', 'female'), ('Josefa', 'female'), ('Leonor', 'female'),
('Macario', 'male'), ('Nicanor', 'male'), ('Olegario', 'male'), ('Pancracio', 'male'), ('Quirino', 'male')
) AS t(name, gender);

-- ES nature
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_es_nature') FROM (VALUES
('Sol', 'neutral'), ('Luna', 'female'), ('Estrella', 'female'), ('Cielo', 'neutral'), ('Mar', 'neutral'),
('Río', 'male'), ('Bosque', 'male'), ('Montaña', 'female'), ('Selva', 'female'), ('Pradera', 'female'),
('Rosa', 'female'), ('Margarita', 'female'), ('Jazmín', 'female'), ('Azalea', 'female'), ('Orquídea', 'female'),
('Nieve', 'female'), ('Lluvia', 'female'), ('Viento', 'male'), ('Trueno', 'male'), ('Arcoíris', 'neutral'),
('Coral', 'female'), ('Perla', 'female'), ('Ámbar', 'female'), ('Cristal', 'neutral'), ('Piedra', 'female')
) AS t(name, gender);

-- ES petnicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_es_petnicknames') FROM (VALUES
('Cariño', 'neutral'), ('Amor', 'neutral'), ('Tesoro', 'neutral'), ('Corazón', 'neutral'), ('Cielo', 'neutral'),
('Peque', 'neutral'), ('Chiqui', 'neutral'), ('Bebé', 'neutral'), ('Nene', 'male'), ('Nena', 'female'),
('Gordi', 'neutral'), ('Flaco', 'male'), ('Negrito', 'male'), ('Blanquito', 'male'), ('Rubio', 'male'),
('Peludo', 'male'), ('Pelusa', 'neutral'), ('Bola', 'neutral'), ('Bichito', 'neutral'), ('Cosita', 'neutral'),
('Precioso', 'male'), ('Preciosa', 'female'), ('Bonito', 'male'), ('Bonita', 'female'), ('Guapo', 'male')
) AS t(name, gender);

-- =====================================================
-- ITALIAN (IT) - 7 SETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, description, language, style, is_free) VALUES
(gen_random_uuid(), 'pets_it_cute', 'Dolce & Tenero', 'Nomi teneri e adorabili', 'it', 'cute', true),
(gen_random_uuid(), 'pets_it_strong', 'Corto & Forte', 'Nomi brevi con carattere', 'it', 'strong', true),
(gen_random_uuid(), 'pets_it_classic', 'Nomi Classici', 'Nomi senza tempo e familiari', 'it', 'classic', true),
(gen_random_uuid(), 'pets_it_funny', 'Divertente & Giocoso', 'Nomi con umorismo e personalità', 'it', 'funny', true),
(gen_random_uuid(), 'pets_it_vintage', 'Vintage & Retrò', 'Nomi retrò pieni di fascino', 'it', 'vintage', true),
(gen_random_uuid(), 'pets_it_nature', 'Ispirato alla Natura', 'Nomi dalla natura e dall''aria aperta', 'it', 'nature', true),
(gen_random_uuid(), 'pets_it_petnicknames', 'Soprannomi per Animali', 'Soprannomi affettuosi e classici', 'it', 'petnicknames', true);

-- IT cute
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_it_cute') FROM (VALUES
('Bella', 'female'), ('Luna', 'female'), ('Stella', 'female'), ('Miele', 'neutral'), ('Dolce', 'neutral'),
('Amore', 'neutral'), ('Cuore', 'neutral'), ('Tesoro', 'neutral'), ('Perla', 'female'), ('Gioia', 'female'),
('Biscotto', 'neutral'), ('Cioccolato', 'neutral'), ('Caramella', 'female'), ('Nuvola', 'female'), ('Fiocco', 'neutral'),
('Batuffolo', 'neutral'), ('Pallina', 'female'), ('Briciola', 'female'), ('Pulce', 'neutral'), ('Topolino', 'male'),
('Coccolino', 'male'), ('Cucciolino', 'male'), ('Micino', 'male'), ('Orsetto', 'male'), ('Bambi', 'female')
) AS t(name, gender);

-- IT strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_it_strong') FROM (VALUES
('Max', 'male'), ('Rex', 'male'), ('Thor', 'male'), ('Zeus', 'male'), ('Brutus', 'male'),
('Cesare', 'male'), ('Nerone', 'male'), ('Spartaco', 'male'), ('Achille', 'male'), ('Ercole', 'male'),
('Leone', 'male'), ('Lupo', 'male'), ('Orso', 'male'), ('Tigre', 'male'), ('Falco', 'male'),
('Tuono', 'male'), ('Fulmine', 'male'), ('Tempesta', 'female'), ('Uragano', 'male'), ('Ciclone', 'male'),
('Rocco', 'male'), ('Bruno', 'male'), ('Duca', 'male'), ('Barone', 'male'), ('Principe', 'male')
) AS t(name, gender);

-- IT classic
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_it_classic') FROM (VALUES
('Pippo', 'male'), ('Pluto', 'male'), ('Fido', 'male'), ('Lassie', 'female'), ('Romeo', 'male'),
('Giulietta', 'female'), ('Sofia', 'female'), ('Marco', 'male'), ('Luca', 'male'), ('Matteo', 'male'),
('Francesca', 'female'), ('Giulia', 'female'), ('Chiara', 'female'), ('Valentina', 'female'), ('Laura', 'female'),
('Giuseppe', 'male'), ('Giovanni', 'male'), ('Antonio', 'male'), ('Francesco', 'male'), ('Alessandro', 'male'),
('Maria', 'female'), ('Anna', 'female'), ('Rosa', 'female'), ('Elena', 'female'), ('Lucia', 'female')
) AS t(name, gender);

-- IT funny
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_it_funny') FROM (VALUES
('Pizza', 'female'), ('Pasta', 'female'), ('Lasagna', 'female'), ('Risotto', 'neutral'), ('Gnocchi', 'neutral'),
('Tortellino', 'male'), ('Raviolo', 'male'), ('Cappuccino', 'male'), ('Espresso', 'male'), ('Tiramisù', 'neutral'),
('Gelato', 'neutral'), ('Panna', 'female'), ('Nutella', 'female'), ('Biscotto', 'neutral'), ('Cannolo', 'male'),
('Prosciutto', 'male'), ('Salame', 'male'), ('Mozzarella', 'female'), ('Parmigiano', 'male'), ('Pecorino', 'male'),
('Peperoncino', 'male'), ('Basilico', 'male'), ('Pomodoro', 'male'), ('Zucchina', 'female'), ('Fungo', 'male')
) AS t(name, gender);

-- IT vintage
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_it_vintage') FROM (VALUES
('Adolfo', 'male'), ('Benito', 'male'), ('Corrado', 'male'), ('Domenico', 'male'), ('Ernesto', 'male'),
('Adelina', 'female'), ('Berta', 'female'), ('Clotilde', 'female'), ('Delfina', 'female'), ('Elvira', 'female'),
('Ferdinando', 'male'), ('Gaetano', 'male'), ('Ignazio', 'male'), ('Lorenzo', 'male'), ('Marcello', 'male'),
('Filomena', 'female'), ('Genoveffa', 'female'), ('Immacolata', 'female'), ('Leonilda', 'female'), ('Maddalena', 'female'),
('Narciso', 'male'), ('Ottavio', 'male'), ('Pasquale', 'male'), ('Quirino', 'male'), ('Raffaele', 'male')
) AS t(name, gender);

-- IT nature
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_it_nature') FROM (VALUES
('Sole', 'male'), ('Luna', 'female'), ('Stella', 'female'), ('Cielo', 'male'), ('Mare', 'neutral'),
('Fiume', 'male'), ('Bosco', 'male'), ('Monte', 'male'), ('Prato', 'male'), ('Giardino', 'male'),
('Rosa', 'female'), ('Margherita', 'female'), ('Viola', 'female'), ('Gelsomino', 'male'), ('Giglio', 'male'),
('Neve', 'female'), ('Pioggia', 'female'), ('Vento', 'male'), ('Tuono', 'male'), ('Aurora', 'female'),
('Corallo', 'neutral'), ('Perla', 'female'), ('Ambra', 'female'), ('Cristallo', 'neutral'), ('Sasso', 'male')
) AS t(name, gender);

-- IT petnicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_it_petnicknames') FROM (VALUES
('Amore', 'neutral'), ('Cuore', 'neutral'), ('Tesoro', 'neutral'), ('Gioia', 'female'), ('Stella', 'female'),
('Piccolo', 'male'), ('Piccola', 'female'), ('Bello', 'male'), ('Bella', 'female'), ('Caro', 'male'),
('Cucciolotto', 'male'), ('Micetto', 'male'), ('Pallino', 'male'), ('Batuffolino', 'male'), ('Orsacchiotto', 'male'),
('Tenerino', 'male'), ('Dolcino', 'male'), ('Patatino', 'male'), ('Nanetto', 'male'), ('Frugolino', 'male'),
('Bimbo', 'male'), ('Bimba', 'female'), ('Angioletto', 'male'), ('Tesorino', 'male'), ('Cuoricino', 'neutral')
) AS t(name, gender);

-- =====================================================
-- SWEDISH (SV) - 7 SETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, description, language, style, is_free) VALUES
(gen_random_uuid(), 'pets_sv_cute', 'Söt & Gullig', 'Mjuka och gulliga namn för husdjur', 'sv', 'cute', true),
(gen_random_uuid(), 'pets_sv_strong', 'Kort & Stark', 'Korta namn med kraft', 'sv', 'strong', true),
(gen_random_uuid(), 'pets_sv_classic', 'Klassiska Namn', 'Tidlösa namn som känns familjära', 'sv', 'classic', true),
(gen_random_uuid(), 'pets_sv_funny', 'Rolig & Lekfull', 'Namn med humor och personlighet', 'sv', 'funny', true),
(gen_random_uuid(), 'pets_sv_vintage', 'Vintage & Retro', 'Retro-namn med charm', 'sv', 'vintage', true),
(gen_random_uuid(), 'pets_sv_nature', 'Naturinspirerat', 'Namn inspirerade av naturen', 'sv', 'nature', true),
(gen_random_uuid(), 'pets_sv_petnicknames', 'Smeknamn', 'Kärleksfulla smeknamn för husdjur', 'sv', 'petnicknames', true);

-- SV cute
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_sv_cute') FROM (VALUES
('Bella', 'female'), ('Luna', 'female'), ('Molly', 'female'), ('Maja', 'female'), ('Saga', 'female'),
('Sigge', 'male'), ('Milo', 'male'), ('Charlie', 'male'), ('Bamse', 'male'), ('Nansen', 'male'),
('Pansen', 'neutral'), ('Musen', 'neutral'), ('Nalansen', 'neutral'), ('Pudansen', 'neutral'), ('Kansen', 'neutral'),
('Ansen', 'neutral'), ('Gansen', 'neutral'), ('Moansen', 'neutral'), ('Kansen', 'neutral'), ('Fluffen', 'neutral'),
('Snansen', 'neutral'), ('Bulan', 'neutral'), ('Tulan', 'neutral'), ('Kulansen', 'neutral'), ('Mysen', 'neutral')
) AS t(name, gender);

-- SV strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_sv_strong') FROM (VALUES
('Thor', 'male'), ('Odin', 'male'), ('Freja', 'female'), ('Lansen', 'male'), ('Bansen', 'male'),
('Max', 'male'), ('Rex', 'male'), ('Bruno', 'male'), ('Rocky', 'male'), ('Diesel', 'male'),
('Bamsen', 'male'), ('Björn', 'male'), ('Vansen', 'male'), ('Kansen', 'male'), ('Storm', 'male'),
('Bansen', 'male'), ('Viking', 'male'), ('Ragnar', 'male'), ('Leansen', 'male'), ('Fansen', 'male'),
('Tansen', 'male'), ('Stark', 'male'), ('Kraft', 'male'), ('Blansen', 'male'), ('Gransen', 'male')
) AS t(name, gender);

-- SV classic
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_sv_classic') FROM (VALUES
('Charlie', 'male'), ('Ludde', 'male'), ('Sigge', 'male'), ('Ville', 'male'), ('Pansen', 'male'),
('Molly', 'female'), ('Bella', 'female'), ('Saga', 'female'), ('Maja', 'female'), ('Lansen', 'female'),
('Kansen', 'male'), ('Mansen', 'male'), ('Bansen', 'male'), ('Ransen', 'male'), ('Gansen', 'male'),
('Tansen', 'female'), ('Fansen', 'female'), ('Nansen', 'female'), ('Vansen', 'female'), ('Dansen', 'female'),
('Erik', 'male'), ('Lars', 'male'), ('Nils', 'male'), ('Sven', 'male'), ('Anna', 'female')
) AS t(name, gender);

-- SV funny
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_sv_funny') FROM (VALUES
('Köttansen', 'neutral'), ('Bulansen', 'neutral'), ('Fansen', 'neutral'), ('Pannansen', 'neutral'), ('Våfansen', 'neutral'),
('Kanelsen', 'neutral'), ('Sansen', 'neutral'), ('Pransen', 'neutral'), ('Snansen', 'neutral'), ('Flansen', 'neutral'),
('Mansen', 'neutral'), ('Knansen', 'neutral'), ('Bansen', 'neutral'), ('Gansen', 'neutral'), ('Dansen', 'neutral'),
('Tansen', 'neutral'), ('Nansen', 'neutral'), ('Vansen', 'neutral'), ('Ransen', 'neutral'), ('Klansen', 'neutral'),
('Potansen', 'neutral'), ('Bansen', 'neutral'), ('Plutansen', 'neutral'), ('Flansen', 'neutral'), ('Pansen', 'neutral')
) AS t(name, gender);

-- SV vintage
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_sv_vintage') FROM (VALUES
('Agda', 'female'), ('Bertil', 'male'), ('Dagny', 'female'), ('Edvin', 'male'), ('Fansen', 'male'),
('Greta', 'female'), ('Harald', 'male'), ('Ingeborg', 'female'), ('Johan', 'male'), ('Kerstin', 'female'),
('Lennart', 'male'), ('Märta', 'female'), ('Nils', 'male'), ('Olga', 'female'), ('Pansen', 'male'),
('Ragna', 'female'), ('Sixten', 'male'), ('Tyra', 'female'), ('Ulf', 'male'), ('Viola', 'female'),
('Valdemar', 'male'), ('Gunhild', 'female'), ('Folke', 'male'), ('Bansen', 'female'), ('Helga', 'female')
) AS t(name, gender);

-- SV nature
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_sv_nature') FROM (VALUES
('Björk', 'female'), ('Ek', 'male'), ('Furu', 'female'), ('Gran', 'female'), ('Lind', 'female'),
('Älv', 'female'), ('Bäck', 'male'), ('Sjö', 'female'), ('Skog', 'male'), ('Äng', 'female'),
('Sol', 'neutral'), ('Måne', 'neutral'), ('Stjärna', 'female'), ('Himmel', 'male'), ('Moln', 'neutral'),
('Snö', 'female'), ('Regn', 'neutral'), ('Vind', 'male'), ('Storm', 'male'), ('Frost', 'neutral'),
('Blomma', 'female'), ('Ros', 'female'), ('Lilja', 'female'), ('Vansen', 'neutral'), ('Sten', 'male')
) AS t(name, gender);

-- SV petnicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_sv_petnicknames') FROM (VALUES
('Älskling', 'neutral'), ('Gansen', 'neutral'), ('Sansen', 'neutral'), ('Bansen', 'neutral'), ('Nansen', 'neutral'),
('Lansen', 'neutral'), ('Tansen', 'neutral'), ('Fansen', 'neutral'), ('Ransen', 'neutral'), ('Mansen', 'neutral'),
('Vansen', 'neutral'), ('Dansen', 'neutral'), ('Kansen', 'neutral'), ('Pansen', 'neutral'), ('Gansen', 'neutral'),
('Klansen', 'neutral'), ('Snansen', 'neutral'), ('Flansen', 'neutral'), ('Blansen', 'neutral'), ('Gransen', 'neutral'),
('Transen', 'neutral'), ('Pransen', 'neutral'), ('Skansen', 'neutral'), ('Bransen', 'neutral'), ('Dransen', 'neutral')
) AS t(name, gender);

-- =====================================================
-- NORWEGIAN (NO) - 7 SETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, description, language, style, is_free) VALUES
(gen_random_uuid(), 'pets_no_cute', 'Søt & Koselig', 'Myke og søte navn for kjæledyr', 'no', 'cute', true),
(gen_random_uuid(), 'pets_no_strong', 'Kort & Sterk', 'Korte navn med trøkk', 'no', 'strong', true),
(gen_random_uuid(), 'pets_no_classic', 'Klassiske Navn', 'Tidløse navn som føles trygge', 'no', 'classic', true),
(gen_random_uuid(), 'pets_no_funny', 'Morsom & Leken', 'Navn med humor og personlighet', 'no', 'funny', true),
(gen_random_uuid(), 'pets_no_vintage', 'Vintage & Retro', 'Retro-navn med sjarm', 'no', 'vintage', true),
(gen_random_uuid(), 'pets_no_nature', 'Naturinspirert', 'Navn fra natur og friluft', 'no', 'nature', true),
(gen_random_uuid(), 'pets_no_petnicknames', 'Kallenavn', 'Kjælenavn og klassiske ropenavn', 'no', 'petnicknames', true);

-- NO cute
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_no_cute') FROM (VALUES
('Luna', 'female'), ('Bella', 'female'), ('Molly', 'female'), ('Nansen', 'female'), ('Pansen', 'female'),
('Charlie', 'male'), ('Bansen', 'male'), ('Tansen', 'male'), ('Fansen', 'male'), ('Gansen', 'male'),
('Sansen', 'neutral'), ('Kansen', 'neutral'), ('Mansen', 'neutral'), ('Ransen', 'neutral'), ('Vansen', 'neutral'),
('Dansen', 'neutral'), ('Nansen', 'neutral'), ('Lansen', 'neutral'), ('Flansen', 'neutral'), ('Snansen', 'neutral'),
('Bansen', 'neutral'), ('Gransen', 'neutral'), ('Pransen', 'neutral'), ('Klansen', 'neutral'), ('Transen', 'neutral')
) AS t(name, gender);

-- NO strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_no_strong') FROM (VALUES
('Thor', 'male'), ('Odin', 'male'), ('Fansen', 'male'), ('Lansen', 'male'), ('Bansen', 'male'),
('Max', 'male'), ('Rex', 'male'), ('Bruno', 'male'), ('Tansen', 'male'), ('Gansen', 'male'),
('Sansen', 'male'), ('Kansen', 'male'), ('Mansen', 'male'), ('Ransen', 'male'), ('Vansen', 'male'),
('Storm', 'male'), ('Kraft', 'male'), ('Viking', 'male'), ('Bjørn', 'male'), ('Ulv', 'male'),
('Dansen', 'male'), ('Nansen', 'male'), ('Flansen', 'male'), ('Snansen', 'male'), ('Gransen', 'male')
) AS t(name, gender);

-- NO classic
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_no_classic') FROM (VALUES
('Charlie', 'male'), ('Ludansen', 'male'), ('Sigansen', 'male'), ('Villansen', 'male'), ('Pansen', 'male'),
('Molly', 'female'), ('Bella', 'female'), ('Sansen', 'female'), ('Mansen', 'female'), ('Lansen', 'female'),
('Kansen', 'male'), ('Bansen', 'male'), ('Fansen', 'male'), ('Ransen', 'male'), ('Gansen', 'male'),
('Tansen', 'female'), ('Vansen', 'female'), ('Nansen', 'female'), ('Dansen', 'female'), ('Flansen', 'female'),
('Erik', 'male'), ('Lars', 'male'), ('Nils', 'male'), ('Olav', 'male'), ('Anna', 'female')
) AS t(name, gender);

-- NO funny
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_no_funny') FROM (VALUES
('Pansen', 'neutral'), ('Bansen', 'neutral'), ('Fansen', 'neutral'), ('Tansen', 'neutral'), ('Vansen', 'neutral'),
('Kanansen', 'neutral'), ('Sansen', 'neutral'), ('Pransen', 'neutral'), ('Snansen', 'neutral'), ('Flansen', 'neutral'),
('Mansen', 'neutral'), ('Knansen', 'neutral'), ('Gansen', 'neutral'), ('Dansen', 'neutral'), ('Nansen', 'neutral'),
('Ransen', 'neutral'), ('Lansen', 'neutral'), ('Klansen', 'neutral'), ('Gransen', 'neutral'), ('Transen', 'neutral'),
('Potansen', 'neutral'), ('Blansen', 'neutral'), ('Plutansen', 'neutral'), ('Skansen', 'neutral'), ('Bransen', 'neutral')
) AS t(name, gender);

-- NO vintage
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_no_vintage') FROM (VALUES
('Agda', 'female'), ('Bertil', 'male'), ('Dagny', 'female'), ('Edvin', 'male'), ('Fansen', 'male'),
('Greta', 'female'), ('Harald', 'male'), ('Ingeborg', 'female'), ('Johan', 'male'), ('Kerstin', 'female'),
('Leif', 'male'), ('Marta', 'female'), ('Nils', 'male'), ('Olga', 'female'), ('Pansen', 'male'),
('Ragna', 'female'), ('Sigurd', 'male'), ('Tyra', 'female'), ('Ulf', 'male'), ('Viola', 'female'),
('Valdemar', 'male'), ('Gunhild', 'female'), ('Folke', 'male'), ('Bansen', 'female'), ('Helga', 'female')
) AS t(name, gender);

-- NO nature
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_no_nature') FROM (VALUES
('Bjørk', 'female'), ('Eik', 'male'), ('Furu', 'female'), ('Gran', 'female'), ('Lind', 'female'),
('Elv', 'female'), ('Bekk', 'male'), ('Sjø', 'female'), ('Skog', 'male'), ('Eng', 'female'),
('Sol', 'neutral'), ('Måne', 'neutral'), ('Stjerne', 'female'), ('Himmel', 'male'), ('Sky', 'neutral'),
('Snø', 'female'), ('Regn', 'neutral'), ('Vind', 'male'), ('Storm', 'male'), ('Frost', 'neutral'),
('Blomst', 'female'), ('Rose', 'female'), ('Lilje', 'female'), ('Fjell', 'neutral'), ('Stein', 'male')
) AS t(name, gender);

-- NO petnicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_no_petnicknames') FROM (VALUES
('Kjansen', 'neutral'), ('Gansen', 'neutral'), ('Sansen', 'neutral'), ('Bansen', 'neutral'), ('Nansen', 'neutral'),
('Lansen', 'neutral'), ('Tansen', 'neutral'), ('Fansen', 'neutral'), ('Ransen', 'neutral'), ('Mansen', 'neutral'),
('Vansen', 'neutral'), ('Dansen', 'neutral'), ('Kansen', 'neutral'), ('Pansen', 'neutral'), ('Snansen', 'neutral'),
('Klansen', 'neutral'), ('Flansen', 'neutral'), ('Blansen', 'neutral'), ('Gransen', 'neutral'), ('Transen', 'neutral'),
('Pransen', 'neutral'), ('Skansen', 'neutral'), ('Bransen', 'neutral'), ('Dransen', 'neutral'), ('Kransen', 'neutral')
) AS t(name, gender);

-- =====================================================
-- DANISH (DA) - 7 SETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, description, language, style, is_free) VALUES
(gen_random_uuid(), 'pets_da_cute', 'Sød & Nuttet', 'Bløde og nuttede navne til kæledyr', 'da', 'cute', true),
(gen_random_uuid(), 'pets_da_strong', 'Kort & Stærk', 'Korte navne med power', 'da', 'strong', true),
(gen_random_uuid(), 'pets_da_classic', 'Klassiske Navne', 'Tidløse navne, trygge og velkendte', 'da', 'classic', true),
(gen_random_uuid(), 'pets_da_funny', 'Sjov & Legesyg', 'Navne med humor og personlighed', 'da', 'funny', true),
(gen_random_uuid(), 'pets_da_vintage', 'Vintage & Retro', 'Retro-navne med charme', 'da', 'vintage', true),
(gen_random_uuid(), 'pets_da_nature', 'Naturinspireret', 'Navne inspireret af naturen', 'da', 'nature', true),
(gen_random_uuid(), 'pets_da_petnicknames', 'Kælenavne', 'Kælenavne og klassiske kaldnavne', 'da', 'petnicknames', true);

-- DA cute
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_da_cute') FROM (VALUES
('Luna', 'female'), ('Bella', 'female'), ('Molly', 'female'), ('Nansen', 'female'), ('Pansen', 'female'),
('Charlie', 'male'), ('Bansen', 'male'), ('Tansen', 'male'), ('Fansen', 'male'), ('Gansen', 'male'),
('Sansen', 'neutral'), ('Kansen', 'neutral'), ('Mansen', 'neutral'), ('Ransen', 'neutral'), ('Vansen', 'neutral'),
('Dansen', 'neutral'), ('Nansen', 'neutral'), ('Lansen', 'neutral'), ('Flansen', 'neutral'), ('Snansen', 'neutral'),
('Bansen', 'neutral'), ('Gransen', 'neutral'), ('Pransen', 'neutral'), ('Klansen', 'neutral'), ('Transen', 'neutral')
) AS t(name, gender);

-- DA strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_da_strong') FROM (VALUES
('Thor', 'male'), ('Odin', 'male'), ('Fansen', 'male'), ('Lansen', 'male'), ('Bansen', 'male'),
('Max', 'male'), ('Rex', 'male'), ('Bruno', 'male'), ('Tansen', 'male'), ('Gansen', 'male'),
('Sansen', 'male'), ('Kansen', 'male'), ('Mansen', 'male'), ('Ransen', 'male'), ('Vansen', 'male'),
('Storm', 'male'), ('Kraft', 'male'), ('Viking', 'male'), ('Bjørn', 'male'), ('Ulv', 'male'),
('Dansen', 'male'), ('Nansen', 'male'), ('Flansen', 'male'), ('Snansen', 'male'), ('Gransen', 'male')
) AS t(name, gender);

-- DA classic
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_da_classic') FROM (VALUES
('Charlie', 'male'), ('Ludansen', 'male'), ('Sigansen', 'male'), ('Villansen', 'male'), ('Pansen', 'male'),
('Molly', 'female'), ('Bella', 'female'), ('Sansen', 'female'), ('Mansen', 'female'), ('Lansen', 'female'),
('Kansen', 'male'), ('Bansen', 'male'), ('Fansen', 'male'), ('Ransen', 'male'), ('Gansen', 'male'),
('Tansen', 'female'), ('Vansen', 'female'), ('Nansen', 'female'), ('Dansen', 'female'), ('Flansen', 'female'),
('Erik', 'male'), ('Lars', 'male'), ('Niels', 'male'), ('Hans', 'male'), ('Anna', 'female')
) AS t(name, gender);

-- DA funny
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_da_funny') FROM (VALUES
('Pansen', 'neutral'), ('Bansen', 'neutral'), ('Fansen', 'neutral'), ('Tansen', 'neutral'), ('Vansen', 'neutral'),
('Kanansen', 'neutral'), ('Sansen', 'neutral'), ('Pransen', 'neutral'), ('Snansen', 'neutral'), ('Flansen', 'neutral'),
('Mansen', 'neutral'), ('Knansen', 'neutral'), ('Gansen', 'neutral'), ('Dansen', 'neutral'), ('Nansen', 'neutral'),
('Ransen', 'neutral'), ('Lansen', 'neutral'), ('Klansen', 'neutral'), ('Gransen', 'neutral'), ('Transen', 'neutral'),
('Potansen', 'neutral'), ('Blansen', 'neutral'), ('Plutansen', 'neutral'), ('Skansen', 'neutral'), ('Bransen', 'neutral')
) AS t(name, gender);

-- DA vintage
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_da_vintage') FROM (VALUES
('Agda', 'female'), ('Bertil', 'male'), ('Dagny', 'female'), ('Edvin', 'male'), ('Fansen', 'male'),
('Greta', 'female'), ('Harald', 'male'), ('Ingeborg', 'female'), ('Johan', 'male'), ('Karen', 'female'),
('Leif', 'male'), ('Marta', 'female'), ('Niels', 'male'), ('Olga', 'female'), ('Pansen', 'male'),
('Ragna', 'female'), ('Svend', 'male'), ('Tyra', 'female'), ('Ulf', 'male'), ('Viola', 'female'),
('Valdemar', 'male'), ('Gunhild', 'female'), ('Folke', 'male'), ('Bansen', 'female'), ('Helga', 'female')
) AS t(name, gender);

-- DA nature
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_da_nature') FROM (VALUES
('Birk', 'female'), ('Eg', 'male'), ('Fyr', 'female'), ('Gran', 'female'), ('Lind', 'female'),
('Å', 'female'), ('Bæk', 'male'), ('Sø', 'female'), ('Skov', 'male'), ('Eng', 'female'),
('Sol', 'neutral'), ('Måne', 'neutral'), ('Stjerne', 'female'), ('Himmel', 'male'), ('Sky', 'neutral'),
('Sne', 'female'), ('Regn', 'neutral'), ('Vind', 'male'), ('Storm', 'male'), ('Frost', 'neutral'),
('Blomst', 'female'), ('Rose', 'female'), ('Lilje', 'female'), ('Bakke', 'neutral'), ('Sten', 'male')
) AS t(name, gender);

-- DA petnicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_da_petnicknames') FROM (VALUES
('Sansen', 'neutral'), ('Gansen', 'neutral'), ('Bansen', 'neutral'), ('Nansen', 'neutral'), ('Lansen', 'neutral'),
('Tansen', 'neutral'), ('Fansen', 'neutral'), ('Ransen', 'neutral'), ('Mansen', 'neutral'), ('Vansen', 'neutral'),
('Dansen', 'neutral'), ('Kansen', 'neutral'), ('Pansen', 'neutral'), ('Snansen', 'neutral'), ('Klansen', 'neutral'),
('Flansen', 'neutral'), ('Blansen', 'neutral'), ('Gransen', 'neutral'), ('Transen', 'neutral'), ('Pransen', 'neutral'),
('Skansen', 'neutral'), ('Bransen', 'neutral'), ('Dransen', 'neutral'), ('Kransen', 'neutral'), ('Fransen', 'neutral')
) AS t(name, gender);

-- =====================================================
-- FINNISH (FI) - 7 SETS
-- =====================================================

INSERT INTO name_sets (id, slug, title, description, language, style, is_free) VALUES
(gen_random_uuid(), 'pets_fi_cute', 'Söpö & Suloinen', 'Pehmeät ja suloiset nimet lemmikeille', 'fi', 'cute', true),
(gen_random_uuid(), 'pets_fi_strong', 'Lyhyt & Vahva', 'Lyhyet nimet, joissa on voimaa', 'fi', 'strong', true),
(gen_random_uuid(), 'pets_fi_classic', 'Klassiset Nimet', 'Ajattomat ja tutut nimet', 'fi', 'classic', true),
(gen_random_uuid(), 'pets_fi_funny', 'Hauska & Leikkisä', 'Nimet huumorilla ja persoonalla', 'fi', 'funny', true),
(gen_random_uuid(), 'pets_fi_vintage', 'Vintage & Retro', 'Retro-henkiset nimet', 'fi', 'vintage', true),
(gen_random_uuid(), 'pets_fi_nature', 'Luonnon Inspiroima', 'Luonnosta ja ulkoilmasta inspiroituneet nimet', 'fi', 'nature', true),
(gen_random_uuid(), 'pets_fi_petnicknames', 'Lempinimet', 'Hellittelynimet ja perinteiset kutsumanimet', 'fi', 'petnicknames', true);

-- FI cute
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fi_cute') FROM (VALUES
('Luna', 'female'), ('Bella', 'female'), ('Nansen', 'female'), ('Pansen', 'female'), ('Musti', 'male'),
('Mirri', 'female'), ('Bansen', 'neutral'), ('Tansen', 'neutral'), ('Fansen', 'neutral'), ('Gansen', 'neutral'),
('Sansen', 'neutral'), ('Kansen', 'neutral'), ('Mansen', 'neutral'), ('Ransen', 'neutral'), ('Vansen', 'neutral'),
('Dansen', 'neutral'), ('Nansen', 'neutral'), ('Lansen', 'neutral'), ('Flansen', 'neutral'), ('Snansen', 'neutral'),
('Bansen', 'neutral'), ('Gransen', 'neutral'), ('Pransen', 'neutral'), ('Klansen', 'neutral'), ('Transen', 'neutral')
) AS t(name, gender);

-- FI strong
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fi_strong') FROM (VALUES
('Ukko', 'male'), ('Ahti', 'male'), ('Fansen', 'male'), ('Lansen', 'male'), ('Bansen', 'male'),
('Max', 'male'), ('Rex', 'male'), ('Karhu', 'male'), ('Tansen', 'male'), ('Gansen', 'male'),
('Sansen', 'male'), ('Kansen', 'male'), ('Mansen', 'male'), ('Ransen', 'male'), ('Vansen', 'male'),
('Myrsky', 'male'), ('Voima', 'male'), ('Susi', 'male'), ('Ilves', 'male'), ('Kotka', 'male'),
('Dansen', 'male'), ('Nansen', 'male'), ('Flansen', 'male'), ('Snansen', 'male'), ('Gransen', 'male')
) AS t(name, gender);

-- FI classic
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fi_classic') FROM (VALUES
('Musti', 'male'), ('Mirri', 'female'), ('Pansen', 'male'), ('Sansen', 'male'), ('Lansen', 'male'),
('Bella', 'female'), ('Luna', 'female'), ('Bansen', 'female'), ('Mansen', 'female'), ('Nansen', 'female'),
('Kansen', 'male'), ('Tansen', 'male'), ('Fansen', 'male'), ('Ransen', 'male'), ('Gansen', 'male'),
('Vansen', 'female'), ('Dansen', 'female'), ('Flansen', 'female'), ('Snansen', 'female'), ('Gransen', 'female'),
('Eero', 'male'), ('Matti', 'male'), ('Pekka', 'male'), ('Aino', 'female'), ('Liisa', 'female')
) AS t(name, gender);

-- FI funny
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fi_funny') FROM (VALUES
('Pansen', 'neutral'), ('Bansen', 'neutral'), ('Fansen', 'neutral'), ('Tansen', 'neutral'), ('Vansen', 'neutral'),
('Kanansen', 'neutral'), ('Sansen', 'neutral'), ('Pransen', 'neutral'), ('Snansen', 'neutral'), ('Flansen', 'neutral'),
('Mansen', 'neutral'), ('Knansen', 'neutral'), ('Gansen', 'neutral'), ('Dansen', 'neutral'), ('Nansen', 'neutral'),
('Ransen', 'neutral'), ('Lansen', 'neutral'), ('Klansen', 'neutral'), ('Gransen', 'neutral'), ('Transen', 'neutral'),
('Potansen', 'neutral'), ('Blansen', 'neutral'), ('Plutansen', 'neutral'), ('Skansen', 'neutral'), ('Bransen', 'neutral')
) AS t(name, gender);

-- FI vintage
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fi_vintage') FROM (VALUES
('Aarne', 'male'), ('Bertta', 'female'), ('Dagny', 'female'), ('Edvin', 'male'), ('Fansen', 'male'),
('Greta', 'female'), ('Heikki', 'male'), ('Inkeri', 'female'), ('Juhani', 'male'), ('Kaarina', 'female'),
('Lauri', 'male'), ('Martta', 'female'), ('Niilo', 'male'), ('Olga', 'female'), ('Pansen', 'male'),
('Rauni', 'female'), ('Simo', 'male'), ('Tyyne', 'female'), ('Urho', 'male'), ('Vieno', 'female'),
('Väinö', 'male'), ('Hilma', 'female'), ('Toivo', 'male'), ('Bansen', 'female'), ('Helmi', 'female')
) AS t(name, gender);

-- FI nature
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fi_nature') FROM (VALUES
('Koivu', 'female'), ('Tammi', 'male'), ('Mänty', 'female'), ('Kuusi', 'female'), ('Lehmus', 'female'),
('Joki', 'male'), ('Puro', 'male'), ('Järvi', 'male'), ('Metsä', 'male'), ('Niitty', 'female'),
('Aurinko', 'neutral'), ('Kuu', 'neutral'), ('Tähti', 'female'), ('Taivas', 'male'), ('Pilvi', 'neutral'),
('Lumi', 'female'), ('Sade', 'neutral'), ('Tuuli', 'male'), ('Myrsky', 'male'), ('Halla', 'neutral'),
('Kukka', 'female'), ('Ruusu', 'female'), ('Lilja', 'female'), ('Kallio', 'neutral'), ('Kivi', 'male')
) AS t(name, gender);

-- FI petnicknames
INSERT INTO names (name, gender, set_id) SELECT name, gender, (SELECT id FROM name_sets WHERE slug = 'pets_fi_petnicknames') FROM (VALUES
('Kulta', 'neutral'), ('Rakas', 'neutral'), ('Sansen', 'neutral'), ('Bansen', 'neutral'), ('Nansen', 'neutral'),
('Lansen', 'neutral'), ('Tansen', 'neutral'), ('Fansen', 'neutral'), ('Ransen', 'neutral'), ('Mansen', 'neutral'),
('Vansen', 'neutral'), ('Dansen', 'neutral'), ('Kansen', 'neutral'), ('Pansen', 'neutral'), ('Snansen', 'neutral'),
('Klansen', 'neutral'), ('Flansen', 'neutral'), ('Blansen', 'neutral'), ('Gransen', 'neutral'), ('Transen', 'neutral'),
('Pransen', 'neutral'), ('Skansen', 'neutral'), ('Bransen', 'neutral'), ('Dransen', 'neutral'), ('Kransen', 'neutral')
) AS t(name, gender);

-- =====================================================
-- ADD UNIQUE CONSTRAINT
-- =====================================================

-- Add unique constraint after data is inserted
ALTER TABLE name_sets ADD CONSTRAINT name_sets_language_style_key UNIQUE (language, style);

-- =====================================================
-- VERIFY
-- =====================================================

SELECT language, COUNT(*) as sets_count FROM name_sets GROUP BY language ORDER BY language;
SELECT COUNT(*) as total_names FROM names;
