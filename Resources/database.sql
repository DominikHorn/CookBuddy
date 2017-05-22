DROP TABLE IF EXISTS Schedule;
DROP TABLE IF EXISTS Likes;
DROP TABLE IF EXISTS Contains;
DROP TABLE IF EXISTS Ingredients;
DROP TABLE IF EXISTS Units;
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
   Name         VARCHAR(30) NOT NULL,
   Plural       VARCHAR(30));
CREATE TABLE Units
  (UnitID       INTEGER PRIMARY KEY AUTOINCREMENT,
   Name         VARCHAR(30) NOT NULL,
   Plural       VARCHAR(30));
CREATE TABLE Likes -- TODO: rethink how this works
  (DishID       INTEGER REFERENCES Dishes,
   PersID       INTEGER REFERENCES Persons,
   Score        INTEGER NOT NULL, -- how much a person usually likes a certain dish
   PRIMARY KEY (DishID, PersID));
CREATE TABLE Contains
  (DishID       INTEGER REFERENCES Dishes,
   IngID        INTEGER REFERENCES Ingredients,
   Quantity     DECIMAL(4,3) NOT NULL,
   Unit         INTEGER REFERENCES Units, -- Items like Baguette have a clear Quantity just from their name
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
  ('Kartoffel Möhren Suppe', 'kartmoehrsup', 'Die Kartoffeln und Möhren schälen und in gleich große Scheiben hobeln oder schneiden. Die Zwiebel und den Knoblauch in Würfel schneiden. Die Zwiebel mit dem Knoblauch in der Butter anschwitzen. Danach Kartoffeln und Möhren beigeben und kurz mitschwitzen. Mit Gemüsebrühe, Sahne und Milch ablöschen. Das Ganze nochmal aufkochen lassen und dann 20 min. bei geringer Temperatur köcheln lassen. Jetzt das Ganze pürieren. Zum Schluss die Suppe mit Petersilie, Salz und Pfeffer abschmecken. Tipp: Man kann auch Speck mit anbraten. Um es noch fettärmer zu machen, komplett mit Milch statt Sahne zubereiten.'),
  ('Geschmortes Olivenhähnchen',    'geschmorolivebockbock', 'Das Hähnchen mit einem schweren Messer in 8 Stücke zerteilen, bei Hähnchenschenkeln Ober- und Unterschenkel trennen. Die Hälfte der Thymianblättchen abzupfen. 5 Salbeiblätter, Rosmarinnadeln von 1 Zweig und 2 Knoblauchzehen fein hacken. Zitronenschale abreiben. Die gehackten Kräuter und den Knoblauch mit dem Zitronenabrieb und 3 EL Olivenöl mischen, über die Hähnchenteile geben und 30 Min. einziehen lassen. In der Zwischenzeit Schalotten und den restlichen Knoblauch pellen. Kartoffeln waschen und schälen. Das Kräuteröl von den Hähnchenteilen entfernen und aufheben. In einem Bräter 1 EL Olivenöl erhitzen, die Hähnchenteile darin hell anbraten, salzen und pfeffern, dann aus dem Fett nehmen und beiseitestellen. Jetzt Kartoffeln, Schalotten und Knoblauchzehen 5 Min. in dem Öl braten, salzen und pfeffern. Hähnchen und Kräuteröl in den Bräter geben. Rotwein, Zitronensaft und Tomatenmark verrühren mit dem Geflügelfond (Brühe) in den Bräter gießen. Lorbeerblätter halbieren und mit den restlichen Kräutern und den Oliven dazugeben. Den Bräter mit einem Deckel verschließen und das Hähnchen auf der untersten Schiene bei 200 Grad 35 - 40 Min. schmoren. Wenn die Kartoffeln weich sind, die Hähnchenteile auf einen Grillrost legen und unter dem Grill in ca. 5 - 10 Min. bei 200 Grad kross grillen. Eventuell die Hähnchenteile mit Pfeffer und Salz nachwürzen. Aus der Sauce die Lorbeerblätter und Rosmarinstängel fischen. Die Sauce abschmecken. Mit Baguette oder Ciabatta und gemischtem Salat servieren.'),
  ('Kartoffel-Lauch-Auflauf',       'kartlauchschinken', 'Den Backofen auf 180 °C vorheizen. Lauch und Kartoffeln in grobe Stücke schneiden, in Brühe nicht ganz fertig kochen und in eine Auflaufform legen. Schinken in kleine Würfel schneiden und ebenfalls in die Form geben. Eier, Sahne, Schmelzkäse und Gewürze mit dem Schneebesen verquirlen und über Lauch-Kartoffeln-Schinken geben. Mit Emmentaler bestreuen und ca. 30 - 40 Min. gratinieren. Kann als Beilage zu Steaks gereicht werden oder auch als Hauptgericht. Tipp: Aus der Kochbrühe von Lauch und Kartoffeln kann man noch eine leckere Lauchcremesuppe zaubern. Dazu ein paar Stücke Lauch und Kartoffeln im Topf belassen und gar kochen, Sahne dazu, pürieren, abschmecken.'),
  ('Tortelloni-Steak-Pfanne', 'tortellonisteak', 'Das Öl in einer großen Pfanne erhitzen und die Steakstreifen 4 - 5 Minuten kräftig anbraten. Mit Salz und Pfeffer würzen. Das Fleisch herausnehmen und zur Seite stellen. Den Fond in die gleiche Pfanne geben und aufkochen. Die Tortelloni und Zuckerschoten zugeben und 2 - 3 Minuten köcheln lassen. Petersilie, Frischkäse und Fleisch dazugeben und nochmal mit Salz und Pfeffer abschmecken.'),
  ('Apfel-Pfannkuchen', 'apfelpfannkuchen', 'Eier trennen. Eiweiß steif schlagen. Eigelb mit 2 EL Zucker cremig schlagen und die Milch zufügen. Jetzt das Mehl sowie das Backpulver und einer Prise Salz dazu geben, mixen und zum Schluss den Eischnee unterheben. Äpfel schälen, vierteln, entkernen und in Scheiben oder Stücke schneiden. Zusammen mit Butter und 1 EL Zucker in einer Pfanne etwas karamellisieren lassen. Mit Calvados ablöschen und mit dem Teig auffüllen. Den Teig stocken lassen und im vorgeheizten Ofen bei 160°C ca. 10 Minuten goldgelb fertig backen. Probieren Sie auch die beiden anderen Rezepte aus unserem Video: "Pancake mit Blaubeeren" und "Crêpe"');

INSERT INTO Persons(Name)
VALUES
  ('Mama'),
  ('Papa'),
  ('Sohn');

INSERT INTO Ingredients(Name, Plural)
VALUES
  ('Tomate', 'Tomaten'),     -- 1
  ('Mozarella', NULL),      -- 2
  ('Olivenöl', NULL),       -- 3
  ('Essig', NULL),          -- 4
  ('Blattsalatkopf', 'Blattsalatköpfe'), -- 5
  ('Karotte', 'Karotten'),  -- 6
  ('Gurke', 'Gurken'),      -- 7
  ('Zwiebel', 'Zwiebeln'),  -- 8
  ('Hühnerbrust', 'Hühnerbrüste'),    -- 9
  ('Reis', NULL),           -- 10
  ('Brot', 'Brote'),        -- 11
  ('Räucherlachs', NULL),   -- 12
  ('Gemüsekack', NULL),     -- 13
  ('Ei', 'Eier'),           -- 14
  ('Mehl', NULL),           -- 15
  ('Aufschnitt', NULL),     -- 16
  ('Baguette', 'Baguettes'),-- 17
  ('Rindersteak', 'Rindersteaks'),    -- 18
  ('Lachs', NULL),          -- 19
  ('Nudeln', NULL),         -- 20
  ('Hackfleisch', NULL),    -- 21
  ('Chilli', NULL),         -- 22
  ('Sahne', NULL),          -- 23
  ('Joghurt', 'Joghurts'),  -- 24
  ('Kraut', 'Kräuter'),     -- 25
  ('Hühnchenschnitzel', NULL),-- 26
  ('Fetakäse', NULL),       -- 27
  ('Milch', NULL),          -- 28
  ('Pizza', 'Pizzen'),      -- 29
  ('Knoblauch', NULL),      -- 30
  ('Kauflanddöner', NULL),  -- 31
  ('Sojasauce', 'Sojasaucen'),-- 32
  ('Orangensaft', 'Orangensäfte'),-- 33
  ('Honig', NULL),          -- 34
  ('Sambal Oelek', NULL),   -- 35
  ('Sesam', NULL),          -- 36
  ('Gewürzmischung', 'Gewürzmischungen'),-- 37
  ('Zuckerschote', 'Zuckerschoten'),-- 38
  ('Frühlingszwiebel', 'Frühlingszwiebeln'),-- 39
  ('Paprikaschote', 'Paprikaschoten'),-- 40
  ('Bambussprosse', 'Bambussprossen'),-- 41
  ('Pellkartoffel', 'Pellkartoffeln'),-- 42
  ('Butter', NULL),         -- 43
  ('Schinken', NULL),       -- 44
  ('Schweineschnitzel', NULL),-- 45
  ('Crème fraîche', NULL),  -- 46
  ('Backpulver', NULL),     -- 47
  ('Gouda', NULL),          -- 48
  ('Schnittlauch', NULL),   -- 49
  ('Petersilie', NULL),     -- 50
  ('Paprikapulver', NULL),  -- 51
  ('Bandnudeln', NULL),     -- 52
  ('Blattspinat', NULL),    -- 53
  ('Gemüsebrühe', NULL),    -- 54
  ('Wasser', NULL),         -- 55
  ('Speisestärke', NULL),   -- 56
  ('Muskat', NULL),         -- 57
  ('Raffiniertes Öl', NULL),-- 58
  ('Kartoffel', 'Kartoffeln'),-- 60
  ('Hähnchenschenkel', NULL),-- 61
  ('Thymian', NULL),        -- 62
  ('Salbei', NULL),         -- 63
  ('Rosmarin', NULL),       -- 64
  ('Lorbeerblatt', 'Lorbeerblätter'),-- 65
  ('Zitronenschale', 'Zitronenschalen'),-- 66
  ('Tomatenmark', NULL),    -- 67
  ('Schalotte', 'Schalotten'),-- 68
  ('kleine Kartoffel', 'kleine Kartoffeln'),--69
  ('Rotwein', NULL),        -- 70
  ('Hühnerbrühe', NULL),    -- 71
  ('schwarze Olive', 'schwarze Oliven'),-- 72
  ('Zitronensaft', NULL),   -- 73
  ('Kochschinken', NULL),   -- 74
  ('Schmelzkäse', NULL),    -- 75
  ('geriebener Emmentaler', NULL),--76
  ('Curry Pulver', NULL),   -- 77
  ('Rinderfond', NULL),     -- 78
  ('Spinat-Ricotta Tortelloni', NULL),-- 79
  ('Kräuterfrischkäse', NULL),-- 80
  ('Apfel', 'Äpfel'),       -- 81
  ('Zucker', NULL),         -- 82
  ('Apfellikör', NULL);     -- 83

INSERT INTO Units(Name, Plural)
VALUES
  ('EL', NULL),             -- 1
  ('Tasse', 'Tassen'),      -- 2
  ('Scheibe', 'Scheiben'),  -- 3
  ('Filet', 'Filets'),      -- 4
  ('kg', NULL),             -- 5
  ('g', NULL),              -- 6
  ('L', NULL),              -- 7
  ('Dose', 'Dosen'),        -- 8
  ('Zehe', 'Zehen'),        -- 9
  ('Dose', 'Dosen'),        -- 10
  ('Schote', 'Schoten'),    -- 11
  ('Becher', NULL),         -- 12
  ('TL', NULL),             -- 13
  ('Prise', 'Prisen'),      -- 14
  ('rote', NULL),           -- 15
  ('Glas', 'Gläser'),       -- 16
  ('Packet', 'Packete'),    -- 17
  ('ml', NULL),             -- 18
  ('Blatt', 'Blätter'),     -- 19
  ('Zweig', 'Zweige'),      -- 20
  ('Stange', 'Stangen'),    -- 21
  ('Stiel', 'Stiele'),      -- 22
  ('cl', NULL),             -- 23
  ('Msp.', NULL),           -- 24
  ('Bund', NULL);           -- 25

INSERT INTO Contains(DishID, IngID, Quantity, Unit)
VALUES
  (1,    1,    2, NULL),
  (1,    2,    1, NULL),
  (1,    3,  1.5,    1),
  (1,    4,    1,    1),
  (1,   17,  0.5, NULL),
  (2,    1,    2, NULL),
  (2,    3,  1.5,    1),
  (2,    4,    1,    1),
  (2,    5,  0.5, NULL),
  (2,    6,  0.5, NULL),
  (2,    7,  0.5, NULL),
  (2,    8, 0.25, NULL),
  (2,    9,    1, NULL),
  (3,   26,    5, NULL),
  (3,   10,  1.5,    2),
  (4,   11,    3,    3),
  (4,   16,    1, NULL),
  (5,   10,    1,    2),
  (5,   19,    1,    4),
  (6,    1,    2, NULL),
  (6,    3,  1.5,    1),
  (6,    4,    1,    1),
  (6,    5,  0.5, NULL),
  (6,    6,  0.5, NULL),
  (6,    7,  0.5, NULL),
  (6,    8, 0.25, NULL),
  (6,   27, 0.25,    5),
  (7,   14,    2, NULL),
  (7,   15,  150,    6),
  (7,   28, 0.25,    7),
  (8,   29,    1, NULL),
  (9,    1, 0.75,    8),
  (9,    3,    1,    1),
  (9,    6,    1, NULL),
  (9,    8,    1, NULL),
  (9,   20,  300,    6),
  (9,   21,  0.5,    5),
  (9,   30,    1,    9),
  (10,   1, 0.75,   10),
  (10,   3,    1,    1),
  (10,   8,  0.5, NULL),
  (10,  20,  300,    6),
  (10,  22,    1,   11),
  (10,  30,    1,    9),
  (11,   9,  300,    6),
  (11,  10,  1.5,    2),
  (11,  23,  0.5,   12),
  (11,  30,    1,    9),
  (12,  31,    1, NULL),
  (13,   9,    1, NULL),
  (13,  13,  200,    6),
  (13,  18,  0.5, NULL),
  (14,   1,    2, NULL),
  (14,   3,  1.5,    1),
  (14,   4,    1,    1),
  (14,   5,  0.5, NULL),
  (14,   6,  0.5, NULL),
  (14,   7,  0.5, NULL),
  (14,   8, 0.25, NULL),
  (14,  18,  500,    6),
  (15,   9,  300,    6),
  (15,  32,    8,    1),
  (15,  33,    4,    1),
  (15,  34,    3,   13),
  (15,  22,    1, NULL),
  (15,  35,    1,   13),
  (15,  36,    1,    1),
  (15,  37,    1,   14),
  (15,  15,   50,    6),
  (15,  38,  100,    6),
  (15,  39,    2, NULL),
  (15,  40,  0.5,   15),
  (15,   8,    1, NULL),
  (15,   6,    1, NULL),
  (15,  41,    1,   16),
  (15,   3,    2,    1),
  (16,  42,  250,    6),
  (16,  43,   10,    6),
  (16,   8,  0.5, NULL),
  (16,  44,   10,    6),
  (16,  45,  150,    6),
  (16,  46,   60,    6),
  (16,  28,    1,    1),
  (16,  48,   30,    6),
  (16,  49,    1,    1),
  (16,  50,  0.5,    1),
  (16,  51,    1,   14),
  (17,  52,  300,    6),
  (17,  53,  250,    6),
  (17,   8,  0.5, NULL),
  (17,  30,    1,    9),
  (17,  54,  0.5,   13),
  (17,  55, 62.5,   18),
  (17,  12,  0.5,   17),
  (17,  46,  0.5,   12),
  (17,  56,  0.5,   13),
  (17,  58,    1,    1),
  (17,  57,    1,   14),
  (18,   8,    1, NULL),
  (18,  30,    1,    9),
  (18,  43,    1,    1),
  (18,  60,  500,    6),
  (18,   6,  400,    6),
  (18,  54,  500,   18),
  (18,  23,    1,   12),
  (18,  28,  300,   18),
  (18,  50,    1,   14),
  (19,  61,    2, NULL),
  (19,  62,  0.5,   25),
  (19,  63,    5,   19),
  (19,  30,  0.5,    9),
  (19,  64,  1.5,   20),
  (19,   3,    2,    1),
  (19,  65,  1.5, NULL),
  (19,  66,  0.5,    1),
  (19,  67,  0.5,    1),
  (19,  68,  125,    6),
  (19,  69,  250,    6),
  (19,  70,  100,   18),
  (19,  71,  100,   18),
  (19,  72,   75,    6),
  (19,  73,    1,    1),
  (20,  49,  1.5,   21),
  (20,  60,  500,    6),
  (20,  74,  100,    6),
  (20,  14,  1.5, NULL),
  (20,  75,  100,    6),
  (20,  23,  100,    6),
  (20,  76,   50,    6),
  (20,  77,    1,   14),
  (21,  18,  125,    6),
  (21,  38,   50,    6),
  (21,  78,  100,   18),
  (21,  79,  125,    6),
  (21,  80, 37.5,    6),
  (21,   3,  0.5,    1),
  (21,  50, 0.75,   22),
  (22,  81,    2, NULL),
  (22,  43,    1,    1),
  (22,  82,    3,    1),
  (22,  83,    2,   23),
  (22,  14,    2, NULL),
  (22,  28,  200,   18),
  (22,  15,  120,    6),
  (22,  47,    1,   24);

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
