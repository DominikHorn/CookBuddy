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
CREATE TABLE Likes
  (DishID       INTEGER REFERENCES Dishes,
   PersID       INTEGER REFERENCES Persons,
   HardScore    INTEGER NOT NULL, -- how much a person likes a
   SoftScore    INTEGER, -- how much a person currently likes a certain dish
   PRIMARY KEY (DishID, PersID));
CREATE TABLE Contains
  (DishID       INTEGER REFERENCES Dishes,
   IngID        INTEGER REFERENCES Ingredients,
   Quantity     DECIMAL(4,3) NOT NULL,
   Unit         VARCHAR(30),
   PRIMARY KEY (IngID, DishID));
CREATE TABLE Schedule
  (ScheduledFor    DATETIME NOT NULL,
   ScheduleNumber  INTEGER NOT NULL,
   NumberOfPeople  INTEGER NOT NULL,
   DishID          INTEGER REFERENCES Dishes,
   PRIMARY KEY (ScheduleNumber, ScheduledFor));

--INSERT INTO Schedule(ScheduleNumber, ScheduledFor, DishID)
--VALUES
--  (0, '2017-05-01 18:00:00.000', 1),
--  (0, '2017-05-02 18:00:00.000', 2),
--  (0, '2017-05-03 18:00:00.000', 3),
--  (1, '2017-05-03 12:00:00.000', 11),
--  (0, '2017-05-04 18:00:00.000', 4),
--  (0, '2017-05-05 18:00:00.000', 5),
--  (0, '2017-05-06 18:00:00.000', 6),
--  (0, '2017-05-07 18:00:00.000', 7),
--  (0, '2017-05-08 18:00:00.000', 8),
--  (0, '2017-05-09 18:00:00.000', 9);

INSERT INTO Dishes(Name, ImageFile, Description)
VALUES
  ('Tomate Mozarella',    'tomatemozzarella', 'Caprese (Italienisch für zu Capri gehörend) ist ein italienischer Vorspeisensalat aus Tomaten, Mozzarella, Basilikum und Olivenöl. Wegen seiner Farben Rot, Weiß und Grün, die der Flagge Italiens entsprechen, gilt er als Nationalgericht.

Zur Herstellung werden rohe Tomatenscheiben mit Mozzarellascheiben und jeweils einem Basilikumblatt belegt, gesalzen und mit Olivenöl beträufelt. Für eine traditionelle Insalata Caprese werden bevorzugt besonders aromatische Tomatensorten wie San Marzano oder Cuore di bue und Büffelmozzarella oder auch Kuhmilch-Mozzarella verwendet, das Olivenöl sollte kaltgepresst sein.[1] Die außerhalb Italiens häufige Verwendung von Aceto balsamico (Balsamessig) ist nicht authentisch und dient im Regelfall dazu, den ersatzweise verwendeten Mozzarella aus Kuhmilch sowie weniger aromatische Tomatensorten geschmacklich zu unterstützen.'),

  ('Salat mit Hünchen',   'huhnsalat',        'Huhn mit diesem eklig gesunden, grünen zeug.
Dieses Gericht eignet sich hervorragend, um übriggebliebene Geflügelreste, wie Huhn, zu verwerten.'),

  ('Schnitzel mit Reis',  'reisschnitzel',    'Schnitzel + Reis. Bayrisch + Asiatisch. Wie man es auch dreht und wendet Es ist lecker.'),
  ('Brotzeit',            'brotzeit',         'Der Klassiker unter den Abendessen. Hat man mal keine Zeit oder keine Lust gescheid zu kochen, ist dieses Gericht die perfekte Abhilfe. Man nehme einen Leib Brot und etwas aufschnitt, drüber, fertig.'),
  ('Lachsfilet',          'lachsfilet',       'Filetiertes Meeresgetier zusammen mit Reis und Gemüse ergänzt sich zu einer gesunden Mahlzeit für die ganze Familie.'),
  ('Salat mit Fetakäse',  'gemuesekack',      'Bäh bäh. Gemüseexplosion. Nur gesunde Menschen essen sowas. Nachteile: Gesund, erwachsen und langweilig. Vorteile: Keine.'),
  ('Pfannenkuchen',       'pfannkuchen',      'Schmeckt süß und geht vergleichsweise schnell. Dazu gehört dann noch Marmelade, Nutella, Honig oder wonach es einem Gelüstet.'),
  ('Pizza',               'pizza',            'Bringe das feeling Italiano auf deinen Teller mit der vollen Dröhnung allem Guten jenseits des Jupiter.'),
  ('Bolognese',           'bolognese',        'Studentenessen. Mutti kanns gut vorbereiten, armer Student gut essen. Win - Win Situation'),
  ('Nudeln Arrabiata',    'arrabiata',        'Siehe Bolognese. Nur, dass das hier scharf ist. Sehr scharf.'),
  ('Sahnehünchen',        'sahnehuhn',        'Huhn ist eine universelle Zutat und verleiht mit diesem Gericht sogar der abgeranzten Sahne aus dem Kühlschrank einen neuen Sinn. Beim nächsten mal solltest du dennoch weniger einkaufen ...'),
  ('Döner',               'doener',           'Wundervoll gegrilltest Hühnchenfleisch geparrt mit knackigem Salat und Joghurtdressing kulminiert zu einem Erguss alles Göttlichen bei der oralen Einführung.'),
  ('Grillen',             'grillen',          'Wenn Frau mal nicht kochen will kann sie Mann einfach beauftragen zu Grillen. Kein Aufwand für sie und er kann endlich mal den Kasten Bier leeren. Ein reiner Win - Win.

Obacht allerdings bei den Zutaten! Gemüse hat mit auf dem Grill nichts verloren und jeder Versuch dieses darauf zu drapieren wird rigoros abgestraft mit Gestöhne und Gemeckere von Ihm'),
  ('Salat mit Steak',     'salatsteak',       'So jetzt machen wir mal alle die Augen zu und denken ganz scharf darüber nach, was in diesem Gericht an Zutaten Vorkommen könnten.');

INSERT INTO Persons(Name)
VALUES
  ('Mama'),
  ('Papa'),
  ('Sohn');

INSERT INTO Ingredients(Name)
VALUES
  ('Tomate'),
  ('Mozarella'),
  ('Öl'),
  ('Essig'),
  ('Blattsalat'),
  ('Karotte'),
  ('Gurke'),
  ('Zwiebel'),
  ('Huhn'),
  ('Reis'),
  ('Brot'),
  ('Lachs'),
  ('Gemüsekack'),
  ('Eier'),
  ('Mehl'),
  ('Aufschnitt'), -- TODO genauer
  ('Baguette'),
  ('Rumsteak'),
  ('Lachs'),
  ('Nudeln'),
  ('Hackfleisch'),
  ('Chilli'),
  ('Sahne'),
  ('Joghurt'),
  ('Kräuter');

INSERT INTO Likes(DishID, PersID, Hardscore)
VALUES
  (1, 1, 100),
  (1, 2, 100),
  (1, 3, 100),
  (2, 1, 50),
  (2, 2, 40),
  (2, 3, 80),
  (3, 1, 30),
  (3, 2, 30),
  (3, 3, 90),
  (4, 1, 70),
  (4, 2, 70),
  (4, 3, 40),
  (5, 1, 80),
  (5, 2, 80),
  (5, 3, 10),
  (6, 1, 80),
  (6, 2, 60),
  (6, 3, 10),
  (7, 1, 50),
  (7, 2, 50),
  (7, 3, 70),
  (8, 1, 50),
  (8, 2, 50),
  (8, 3, 100),
  (9, 1, 50),
  (9, 2, 50),
  (9, 3, 50),
  (10, 1, 50),
  (10, 2, 50),
  (10, 3, 60),
  (11, 1, 50),
  (11, 2, 50),
  (11, 3, 60),
  (12, 1, 50),
  (12, 2, 50),
  (12, 3, 100),
  (13, 1, 80),
  (13, 2, 90),
  (13, 3, 50),
  (14, 1, 60),
  (14, 2, 100),
  (14, 3, 50);

INSERT INTO Contains(DishID, IngID, Quantity, Unit)
VALUES
  (1, 1, 2, 'Große Tomaten'),
  (1, 2, 1, 'Packung'),
  (1, 3, 1.5, 'EL'),
  (1, 4, 1, 'EL'),
  (1, 17, 0.5, NULL),
  (2, 1, 1, NULL), -- TODO add remaining data from here
  (2, 3, 1, NULL),
  (2, 4, 1, NULL),
  (2, 5, 1, NULL),
  (2, 6, 1, NULL),
  (2, 7, 1, NULL),
  (2, 8, 1, NULL),
  (2, 9, 1, NULL),
  (3, 9, 1, NULL),
  (3, 10, 1, NULL),
  (4, 11, 1, NULL),
  (4, 16, 1, NULL),
  (5, 10, 1, NULL),
  (5, 19, 1, NULL),
  (6, 1, 1, NULL),
  (6, 3, 1, NULL),
  (6, 4, 1, NULL),
  (6, 5, 1, NULL),
  (6, 6, 1, NULL),
  (6, 7, 1, NULL),
  (6, 8, 1, NULL),
  (7, 14, 1, NULL),
  (7, 15, 1, NULL),
  (8, 1, 1, NULL),
  (8, 3, 1, NULL),
  (8, 15, 1, NULL),
  (8, 16, 1, NULL),
  (10, 1, 1, NULL),
  (10, 3, 1, NULL),
  (10, 8, 1, NULL),
  (10, 20, 1, NULL),
  (10, 21, 1, NULL),
  (11, 1, 1, NULL),
  (11, 3, 1, NULL),
  (11, 8, 1, NULL),
  (11, 20, 1, NULL),
  (11, 22, 1, NULL),
  (12, 9, 1, NULL),
  (12, 10, 1, NULL),
  (12, 23, 1, NULL),
  (13, 1, 1, NULL),
  (13, 5, 1, NULL),
  (13, 8, 1, NULL),
  (13, 9, 1, NULL),
  (13, 11, 1, NULL),
  (13, 13, 1, NULL),
  (13, 22, 1, NULL),
  (13, 24, 1, NULL),
  (13, 25, 1, NULL),
  (14, 9, 1, NULL),
  (14, 13, 1, NULL),
  (14, 18, 1, NULL),
  (15, 1, 1, NULL),
  (15, 3, 1, NULL),
  (15, 4, 1, NULL),
  (15, 5, 1, NULL),
  (15, 6, 1, NULL),
  (15, 7, 1, NULL),
  (15, 8, 1, NULL),
  (15, 18, 1, NULL);
