USE m106
GO

-- Record einfügen mit expliziter Angabe der Spalten
-- Achtung: Reihenfolge der Values muss stimmen
INSERT INTO verkauf.kunden (vorname, nachname) VALUES ('Hans', 'Meier');

-- Record einfügen ohne Angabe der Spalten
INSERT INTO verkauf.kunden VALUES ('Peter', 'Müller');

-- Record einfügen, bei dem der Default-Constraint greift
INSERT INTO verkauf.kunden (nachname) VALUES ('Matter');

-- Beispiel einer Fremdschlüsselverletzung
INSERT INTO verkauf.bestellungen (bestelldatum, kundenid) 
VALUES ('21.07.2023 10:34:05', 10)

-- Beispiel, bei dem der CHECK-Constraint verletzt wird 
INSERT INTO verkauf.produkte (produktname, energielabel) VALUES ('Elektrogrill', 'G');

-- mehrere Records mit einem Statement in die Tabelle kunden einfügen
INSERT INTO verkauf.kunden (vorname, nachname) 
VALUES ('Bruno', 'Moser'), ('Heinz', 'Manser');

-- mehrere Records mit einem Statement in die Tabelle produkte einfügen
INSERT INTO verkauf.produkte VALUES 
('Zitronenpresse',4.9,'A'), 
('Gartenlounge',224,NULL), 
('Fahrradträger',334.5,NULL), 
('Weinkühlschrank',139,'C');

-- mehrere Bestellungen mit einem Statement erfassen
INSERT INTO verkauf.bestellungen (bestelldatum, kundenid) VALUES 
('2023-09-10 11:20:07', 1),
('2023-05-11 17:43:13', 2),
('2023-12-27 09:32:55', 4);


-- Vorname und Nachname eines Kunden ändern
UPDATE verkauf.kunden
SET vorname = 'Pete', nachname = 'Muller'
WHERE kundenid = 2;

-- Nachname eines Kunden ändern
UPDATE verkauf.kunden 
SET nachname = 'Meyer' 
WHERE nachname = 'Meier';


DELETE FROM verkauf.produkte WHERE produktid = 3;


/*
Damit die Update-Weitergabe aktiviert werden kann, muss zunächst der
bestehende Fremdschlüssel entfernt werden
*/
ALTER TABLE verkauf.bestellungen DROP CONSTRAINT fk_bestellungen_kunden;

-- Updates auf der Primärschlüssel-Spalte automatisch weitergeben
ALTER TABLE verkauf.bestellungen  
ADD CONSTRAINT fk_bestellungen_kunden FOREIGN KEY (kundenid) 
REFERENCES verkauf.kunden(kundenid) ON UPDATE CASCADE;



/*
Damit die Löschweitergabe aktiviert werden kann, muss zunächst der
bestehende Fremdschlüssel entfernt werden
*/
ALTER TABLE verkauf.bestellungen DROP CONSTRAINT fk_bestellungen_kunden;

-- Nun kann die Löschweitergabe auf der Tabelle bestellungen definiert werden
ALTER TABLE verkauf.bestellungen  
ADD CONSTRAINT fk_bestellungen_kunden FOREIGN KEY (kundenid) 
REFERENCES verkauf.kunden(kundenid) ON DELETE CASCADE;


-- Kunde mit der kundenid 2 löschen
DELETE FROM verkauf.kunden WHERE kundenid = 2;

Alter TABLE verkauf.bestellungen DROP CONSTRAINT fk_bestellungen_kunden


ALTER TABLE verkauf.bestellungen  
ADD CONSTRAINT fk_bestellungen_kunden FOREIGN KEY (kundenid) 
REFERENCES verkauf.kunden(kundenid) ON UPDATE CASCADE ON DELETE CASCADE;

