DROP TABLE IF EXISTS Schedule;
DROP TABLE IF EXISTS Likes;
DROP TABLE IF EXISTS Contains;
DROP TABLE IF EXISTS Ingredients;
DROP TABLE IF EXISTS Persons;
DROP TABLE IF EXISTS Dishes;

CREATE TABLE Dishes
  (DishID       INTEGER PRIMARY KEY AUTOINCREMENT,
   Name         VARCHAR(100) NOT NULL,
   ImageFile    VARCHAR(30) NOT NULL,
   Description  VARCHAR(1000) NOT NULL);
CREATE TABLE Persons
  (PersID       INTEGER PRIMARY KEY AUTOINCREMENT,
   Name         VARCHAR(30) NOT NULL);
CREATE TABLE Ingredients
  (IngID        INTEGER PRIMARY KEY AUTOINCREMENT,
   Name         VARCHAR(30) NOT NULL);
CREATE TABLE Likes -- TODO: rethink how this works
  (DishID       INTEGER REFERENCES Dishes,
   PersID       INTEGER REFERENCES Persons,
   Score        INTEGER NOT NULL, -- how much a person usually likes a certain dish
   PRIMARY KEY (DishID, PersID));
CREATE TABLE Contains
  (DishID       INTEGER REFERENCES Dishes,
   IngID        INTEGER REFERENCES Ingredients,
   Quantity     DECIMAL(4,3) NOT NULL,
   Unit         VARCHAR(30), -- Items like Baguette have a clear Quantity just from their name
   PRIMARY KEY (IngID, DishID));
CREATE TABLE Schedule
  (ScheduledFor    DATETIME NOT NULL,
   ScheduleNumber  INTEGER NOT NULL,
   NumberOfPeople  INTEGER NOT NULL,
   DishID          INTEGER REFERENCES Dishes,
   PRIMARY KEY (ScheduleNumber, ScheduledFor));

INSERT INTO Dishes(Name, ImageFile, Description)
VALUES
  ('Tomate Mozarella',              'tomatemozzarella', 'Caprese (Italienisch für zu Capri gehörend) ist ein italienischer Vorspeisensalat aus Tomaten, Mozzarella, Basilikum und Olivenöl. Wegen seiner Farben Rot, Weiß und Grün, die der Flagge Italiens entsprechen, gilt er als Nationalgericht.'),
  ('Salat mit Hünchen',             'huhnsalat',        'Huhn mit diesem eklig gesunden, grünen zeug. Dieses Gericht eignet sich hervorragend, um übriggebliebene Geflügelreste, wie Huhn, zu verwerten.'),
  ('Schnitzel mit Reis',            'reisschnitzel',    'Schnitzel + Reis. Bayrisch + Asiatisch. Wie man es auch dreht und wendet Es ist lecker.'),
  ('Brotzeit',                      'brotzeit',         'Der Klassiker unter den Abendessen. Hat man mal keine Zeit oder keine Lust gescheid zu kochen, ist dieses Gericht die perfekte Abhilfe. Man nehme einen Leib Brot und etwas aufschnitt, drüber, fertig.'),
  ('Lachsfilet',                    'lachsfilet',       'Filetiertes Meeresgetier zusammen mit Reis und Gemüse ergänzt sich zu einer gesunden Mahlzeit für die ganze Familie.'),
  ('Salat mit Fetakäse',            'gemuesekack',      'Bäh bäh. Gemüseexplosion. Nur gesunde Menschen essen sowas. Nachteile: Gesund, erwachsen und langweilig. Vorteile: Keine.'),
  ('Pfannenkuchen',                 'pfannkuchen',      'Schmeckt süß und geht vergleichsweise schnell. Dazu gehört dann noch Marmelade, Nutella, Honig oder wonach es einem Gelüstet.'),
  ('Pizza',                         'pizza',            'Bringe das feeling Italiano auf deinen Teller mit der vollen Dröhnung allem Guten jenseits des Jupiter.'),
  ('Bolognese',                     'bolognese',        'Studentenessen. Mutti kanns gut vorbereiten, armer Student gut essen. Win - Win Situation'),
  ('Nudeln Arrabiata',              'arrabiata',        'Siehe Bolognese. Nur, dass das hier scharf ist. Sehr scharf.'),
  ('Sahnehünchen',                  'sahnehuhn',        'Huhn ist eine universelle Zutat und verleiht mit diesem Gericht sogar der abgeranzten Sahne aus dem Kühlschrank einen neuen Sinn. Beim nächsten mal solltest du dennoch weniger einkaufen ...'),
  ('Döner',                         'doener',           'Wundervoll gegrilltest Hühnchenfleisch geparrt mit knackigem Salat und Joghurtdressing kulminiert zu einem Erguss alles Göttlichen bei der oralen Einführung.'),
  ('Grillen',                       'grillen',          'Wenn Frau mal nicht kochen will kann sie Mann einfach beauftragen zu Grillen. Kein Aufwand für sie und er kann endlich mal den Kasten Bier leeren. Ein reiner Win - Win.'),
  ('Salat mit Steak',               'salatsteak',       'So jetzt machen wir mal alle die Augen zu und denken ganz scharf darüber nach, was in diesem Gericht an Zutaten Vorkommen könnten.'),
  ('Hähnchen in Honig-Sesam Sauce', 'haehnchen-in-honig-sesam-sauce', 'Sojasauce, Orangensaft, Honig, Chilisauce, Sambal Oelek, Sesam und das Chinagewürz vermischen. Hähnchenfilets in mundgerechte Stücke schneiden und mit Mehl bestäuben, vermengen und wieder mit etwas Mehl bestäuben. Soja-Honig-Marinade in einer Schüssel über das Hähnchenfilet geben und ca. 30 Minuten marinieren lassen. In der Zeit die Zuckerschoten dritteln, Frühlingszwiebeln schneiden und die Paprika, Zwiebel und Möhre
    würfeln. Eine große Pfanne oder einen Wok mit etwas Öl heiß werden lassen und darin das marinierte Fleisch mit der Marinade gut anbraten. Dann das Gemüse dazugeben und ca. 5 Minuten mitbraten. Dazu passen Reis, Mie- oder Glasnudeln.'),
  ('Bratkartoffelauflauf mit Schnitzel', 'bratkartoffelauflauf-schnitzel', 'Backofen auf 200°C Umluft vorheizen.
Butter in einer Pfanne erhitzen und die Kartoffelscheiben darin goldgelb braten. Zwiebel- sowie Schinkenwürfel zugeben und leicht anbraten. Alles mit Salz, Pfeffer und Paprikapulver würzen. Die Kartoffeln in eine Auflaufform füllen.
Nun wieder Butter in der Pfanne erhitzen und die Schnitzel bei mittlerer Hitze von beiden Seite in gut 3 Min. gar braten. Mit Salz und Pfeffer bestreuen und auf die Bratkartoffeln legen.
Jetzt Crème fraîche mit Milch in eine Schlüssel geben und alles glatt rühren. Gouda zugeben und untermischen. Diese Masse ebenfalls mit Salz, Pfeffer und Paprikapulver würzen und dann Petersilie und Schnittlauch unterrühren. Die Creme auf die Schnitzel geben und verstreichen.
In den heißen Backofen schieben und auf der mittleren Schiene 10-15 Min. überbacken.'),
  ('Bandnudeln mit frischem Spinat und Lachs', 'bandnudeln-lachs', 'Die Nudeln nach Gebrauchsanweisung kochen - Achtung, frische Nudeln brauchen nur 2-3 Minuten (also aufs Timing achten)! Den Spinat von Stängeln (bis zum Blattanfang) befreien und gründlich waschen. Sand bekommt man am besten raus, indem man den Spinat in Wasser legt und nicht nur abbraust. Die Zwiebel in Ringe schneiden, in eine Pfanne mit hohem Rand und Deckel mit dem Öl geben und bei kleiner bis mittlerer Hitze glasig dünsten
  (nicht braten). Gemüsebrühe mit Wasser mischen und dazu gießen (alternativ geht auch Weißwein statt Brühe). Den Knoblauch schälen, in möglichst kleine Stückchen schneiden und in die Pfanne geben. Nun den Spinat dazugeben. Evtl. geht das nur nach und nach, er fällt aber schnell in sich zusammen, so dass nachgelegt werden kann, falls die Pfanne nicht groß genug ist. Den Räucherlachs in Stücke schneiden und dazugeben, sobald der Spinat komplett in sich zusammengefallen ist. Alternativ zum'' Räucherlachs geht auch frischer Lachs, der auf die gleiche Weise einfach gewürfelt und noch roh dazugegeben werden kann. Etwas Flüssigkeit abnehmen und in einer Tasse mit der Stärke mischen, bis sie sich löst. Dieses Gemisch wieder in die Pfanne geben, ebenso den Becher Cremefine oder Schmand. Mit Pfeffer, Salz und (am besten frisch geriebener) Muskatnuss würzen Die Nudeln abgießen, untermischen und servieren.'),
  ('Kartoffel Möhren Suppe', 'kartmoehrsup', 'Die Kartoffeln und Möhren schälen und in gleich große Scheiben hobeln oder schneiden. Die Zwiebel und den Knoblauch in Würfel schneiden. Die Zwiebel mit dem Knoblauch in der Butter anschwitzen. Danach Kartoffeln und Möhren beigeben und kurz mitschwitzen. Mit Gemüsebrühe, Sahne und Milch ablöschen. Das Ganze nochmal aufkochen lassen und dann 20 min. bei geringer Temperatur köcheln lassen. Jetzt das Ganze pürieren. Zum Schluss die Suppe mit Petersilie, Salz und Pfeffer abschmecken. Tipp: Man kann auch Speck mit anbraten. Um es noch fettärmer zu machen, komplett mit Milch statt Sahne zubereiten.');

INSERT INTO Persons(Name)
VALUES
  ('Mama'),
  ('Papa'),
  ('Sohn');

INSERT INTO Ingredients(Name)
VALUES
  ('Tomate'),         -- 1
  ('Mozarella'),      -- 2
  ('Öl'),             -- 3
  ('Essig'),          -- 4
  ('Blattsalatkopf'), -- 5
  ('Karotte'),        -- 6
  ('Gurke'),          -- 7
  ('Zwiebel'),        -- 8
  ('Hühnerbrust'),    -- 9
  ('Reis'),           -- 10
  ('Brot'),           -- 11
  ('Räucherlachs'),   -- 12
  ('Gemüsekack'),     -- 13
  ('Eier'),           -- 14
  ('Mehl'),           -- 15
  ('Aufschnitt'),     -- 16
  ('Baguette'),       -- 17
  ('Rindersteak'),    -- 18
  ('Lachs'),          -- 19
  ('Nudeln'),         -- 20
  ('Hackfleisch'),    -- 21
  ('Chilli'),         -- 22
  ('Sahne'),          -- 23
  ('Joghurt'),        -- 24
  ('Kräuter'),        -- 25
  ('Hühnchenschnitzel'),-- 26
  ('Fetakäse'),       -- 27
  ('Milch'),          -- 28
  ('Tiefkühlpizza'),  -- 29
  ('Knoblauch'),      -- 30
  ('Kauflanddöner'),  -- 31
  ('Sojasauce'),      -- 32
  ('Orangensaft'),    -- 33
  ('Honig'),          -- 34
  ('Sambal Oelek'),   -- 35
  ('Sesam'),          -- 36
  ('Gewürzmischung'), -- 37
  ('Zuckerschoten'),  -- 38
  ('Frühlingszwiebeln'),-- 39
  ('Paprikaschote'),  -- 40
  ('Bambussprosse'),  -- 41
  ('Pellkartoffel'),  -- 42
  ('Butter'),         -- 43
  ('Schinken'),       -- 44
  ('Schweineschnitzel'),-- 45
  ('Crème fraîche'),  -- 46
  ('Milch'),          -- 47
  ('Gouda'),          -- 48
  ('Schnittlauch'),   -- 49
  ('Petersilie'),     -- 50
  ('Paprikapulver'),  -- 51
  ('Bandnudeln'),     -- 52
  ('Blattspinat'),    -- 53
  ('Gemüsebrühe'),    -- 54
  ('Wasser'),         -- 55
  ('Speisestärke'),   -- 56
  ('Muskat'),         -- 57
  ('Raffiniertes Öl'),-- 58
  ('Kartoffel');      -- 60

INSERT INTO Contains(DishID, IngID, Quantity, Unit)
VALUES
  (1,    1,    2, NULL),
  (1,    2,    1, NULL),
  (1,    3,  1.5, 'EL'),
  (1,    4,    1, 'EL'),
  (1,   17,  0.5, NULL),
  (2,    1,    2, NULL),
  (2,    3,  1.5, 'EL'),
  (2,    4,    1, 'EL'),
  (2,    5,  0.5, NULL),
  (2,    6,  0.5, NULL),
  (2,    7,  0.5, NULL),
  (2,    8, 0.25, NULL),
  (2,    9,    1, NULL),
  (3,   26,    5, NULL),
  (3,   10,  1.5, 'Tassen'),
  (4,   11,    3, 'Scheiben'),
  (4,   16,    1, NULL),
  (5,   10,    1, 'Tassen'),
  (5,   19,    1, 'Filet'),
  (6,    1,    2, NULL),
  (6,    3,  1.5, 'EL'),
  (6,    4,    1, 'EL'),
  (6,    5,  0.5, NULL),
  (6,    6,  0.5, NULL),
  (6,    7,  0.5, NULL),
  (6,    8, 0.25, NULL),
  (6,   27, 0.25, 'Kg'),
  (7,   14,    2, NULL),
  (7,   15,  150, 'g'),
  (7,   28, 0.25, 'L'),
  (8,   29,    1, NULL),
  (9,    1, 0.75, 'Dosen'),
  (9,    3,    1, 'EL'),
  (9,    6,    1, NULL),
  (9,    8,    1, NULL),
  (9,   20,  300, 'g'),
  (9,   21,  0.5, 'Kg'),
  (9,   30,    1, 'Zehe'),
  (10,   1, 0.75, 'Dose'),
  (10,   3,    1, 'EL'),
  (10,   8,  0.5, NULL),
  (10,  20,  300, 'g'),
  (10,  22,    1, 'Schote'),
  (10,  30,    1, 'Zehe'),
  (11,   9,  300, 'g'),
  (11,  10,  1.5, 'Tassen'),
  (11,  23,  0.5, 'Becher'),
  (11,  30,    1, 'Zehe'),
  (12,  31,    1, NULL),
  (13,   9,    1, NULL),
  (13,  13,  200, 'g'),
  (13,  18,  0.5, NULL),
  (14,   1,    2, NULL),
  (14,   3,  1.5, 'EL'),
  (14,   4,    1, 'EL'),
  (14,   5,  0.5, NULL),
  (14,   6,  0.5, NULL),
  (14,   7,  0.5, NULL),
  (14,   8, 0.25, NULL),
  (14,  18,  500, 'g'),
  (15,   9,  300, 'g'),
  (15,  32,    8, 'EL'),
  (15,  33,    4, 'EL'),
  (15,  34,    3, 'TL'),
  (15,  22,    1, NULL),
  (15,  35,    1, 'TL'),
  (15,  36,    1, 'EL'),
  (15,  37,    1, 'Prise'),
  (15,  15,   50, 'g'),
  (15,  38,  100, 'g'),
  (15,  39,    2, NULL),
  (15,  40,  0.5, 'rote'),
  (15,   8,    1, NULL),
  (15,   6,    1, NULL),
  (15,  41,    1, 'Glas'),
  (15,   3,    2, 'EL'),
  (16,  42,  250, 'g'),
  (16,  43,   10, 'g'),
  (16,   8,  0.5, NULL),
  (16,  44,   10, 'g'),
  (16,  45,  150, 'g'),
  (16,  46,   60, 'g'),
  (16,  47,    1, 'EL'),
  (16,  48,   30, 'g'),
  (16,  49,    1, 'EL'),
  (16,  50,  0.5, 'EL'),
  (16,  51,    1, 'Prise'),
  (17,  52,  300, 'g'),
  (17,  53,  250, 'g'),
  (17,   8,  0.5, NULL),
  (17,  30,    1, 'Zehe'),
  (17,  54,  0.5, 'TL'),
  (17,  55, 62.5, 'ml'),
  (17,  12,  0.5, 'Packet'),
  (17,  46,  0.5, 'Becher'),
  (17,  56,  0.5, 'TL'),
  (17,  58,    1, 'EL'),
  (17,  57,    1, 'Prise'),
  (18,   8,    1, NULL),
  (18,  30,    1, 'Zehe'),
  (18,  43,    1, 'EL'),
  (18,  60,  500, 'g'),
  (18,   6,  400, 'g'),
  (18,  54,  500, 'ml'),
  (18,  23,    1, 'Becher'),
  (18,  47,  300, 'ml'),
  (18,  50,    1, 'Prise');

-- TODO: update Likes table!
--INSERT INTO Likes(DishID, PersID, Score)
--VALUES
--  (1, 1, 100),
--  (1, 2, 100),
--  (1, 3, 100),
--  (2, 1, 50),
--  (2, 2, 40),
--  (2, 3, 80),
--  (3, 1, 30),
--  (3, 2, 30),
--  (3, 3, 90),
--  (4, 1, 70),
--  (4, 2, 70),
--  (4, 3, 40),
--  (5, 1, 80),
--  (5, 2, 80),
--  (5, 3, 10);

--INSERT INTO Schedule(ScheduleNumber, ScheduledFor, NumberOfPeople, DishID)
--VALUES
--  (0, '2017-04-20 18:00:00.000', 3, 1),
--  (1, '2017-04-20 17:00:00.000', 4, 2),
--  (2, '2017-04-20 17:30:00.000', 2, 3),
--  (3, '2017-04-20 18:00:00.001', 1, 4),
--  (0, '2017-05-01 18:00:00.000', 3, 1),
--  (0, '2017-05-02 18:00:00.000', 3, 2),
--  (0, '2017-05-03 18:00:00.000', 3, 3),
--  (1, '2017-05-03 12:00:00.000', 2, 11),
--  (0, '2017-05-04 18:00:00.000', 1, 4),
--  (0, '2017-05-05 18:00:00.000', 3, 5),
--  (0, '2017-05-06 18:00:00.000', 3, 6),
--  (0, '2017-05-07 18:00:00.000', 3, 7),
--  (0, '2017-05-08 18:00:00.000', 3, 8),
--  (0, '2017-05-09 18:00:00.000', 3, 9);
