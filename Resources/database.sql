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
  (ScheduledFor Date NOT NULL,
   ScheduleNumber   INTEGER NOT NULL,
   DishID       INTEGER REFERENCES Dishes,
   PRIMARY KEY (ScheduleNumber, ScheduledFor));

INSERT INTO Schedule(ScheduleNumber, ScheduledFor, DishID)
VALUES
  (0, date('now','start of year','+4 months','+0 days'), 1),
  (0, date('now','start of year','+4 months','+1 days'), 2),
  (0, date('now','start of year','+4 months','+2 days'), 3),
  (1, date('now','start of year','+4 months','+2 days'), 11),
  (0, date('now','start of year','+4 months','+3 days'), 4),
  (0, date('now','start of year','+4 months','+4 days'), 5),
  (0, date('now','start of year','+4 months','+5 days'), 6),
  (0, date('now','start of year','+4 months','+6 days'), 7),
  (0, date('now','start of year','+4 months','+7 days'), 8),
  (0, date('now','start of year','+4 months','+8 days'), 9);

INSERT INTO Dishes(Name, ImageFile, Description)
VALUES
  ('Tomate Mozarella',    'tomatemozzarella', 'Italienisches Gericht mit Tomaten, Mozzarella und Basilikum.'),
  ('Salat mit Hünchen',   'huhnsalat',        'Huhn mit diesem eklig gesunden, grünen zeug.'),
  ('Schnitzel mit Reis',  'reisschnitzel',    '3 mal darfst du raten was da jetzt drin ist...'),
  ('Brotzeit',            'brotzeit',         'Aufschnitt mit Brot, wahlweise Fingerfood und etwas Gemüse'),
  ('Lachsfilet',          'lachsfilet',       'Blub blub blub.'),
  ('Gemüsekacka',         'gemuesekack',      'Bäh bäh. Gemüseexplosion. Nur gesunde Menschen essen sowas.'),
  ('Pfannenkuchen',       'pfannkuchen',      'Kuchen aus der Pfanne.'),
  ('Pizza',               'pizza',            'Pizza ist wesentlich besser als jedes andere Gericht.'),
  ('Asiatisch',           'asiatisch',        'Wenn man sein Ohr ganz dicht ans Essen hält, hört man noch den Hund bellen.'),
  ('Bolognese',           'bolognese',        'Nudeln mit Hackfleisch-Tomatensauce.'),
  ('Nudeln Arrabiata',    'arrabiata',        'Nudeln mit scharfer Tomatensauce.'),
  ('Sahnehünchen',        'sahnehuhn',        'Huhn mit Sahnesoße.'),
  ('Döner',               'doener',           'Fussion alles göttlichen in delikatem Brot, serviert zum hier Essen oder Mitnehmen.'),
  ('Grillen',             'grillen',          'Wehe da kommt Gemüse auf den Grill!'),
  ('Salat mit Steak',     'salatsteak',       'Überaschung! Da ist genau das drinnen was drauf steht.');

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
  ('Hund'),
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
  (9, 1, 70),
  (9, 2, 80),
  (9, 3, 100),
  (10, 1, 50),
  (10, 2, 50),
  (10, 3, 50),
  (11, 1, 50),
  (11, 2, 50),
  (11, 3, 60),
  (12, 1, 50),
  (12, 2, 50),
  (12, 3, 60),
  (13, 1, 50),
  (13, 2, 50),
  (13, 3, 100),
  (14, 1, 80),
  (14, 2, 90),
  (14, 3, 50),
  (15, 1, 60),
  (15, 2, 100),
  (15, 3, 50);

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
  (9, 21, 1, NULL),
  (10, 1, 1, NULL),
  (10, 3, 1, NULL),
  (10, 8, 1, NULL),
  (10, 20, 1, NULL),
  (10, 22, 1, NULL),
  (11, 1, 1, NULL),
  (11, 3, 1, NULL),
  (11, 8, 1, NULL),
  (11, 20, 1, NULL),
  (11, 23, 1, NULL),
  (12, 9, 1, NULL),
  (12, 10, 1, NULL),
  (12, 24, 1, NULL),
  (13, 1, 1, NULL),
  (13, 5, 1, NULL),
  (13, 8, 1, NULL),
  (13, 9, 1, NULL),
  (13, 11, 1, NULL),
  (13, 13, 1, NULL),
  (13, 23, 1, NULL),
  (13, 25, 1, NULL),
  (13, 26, 1, NULL),
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
