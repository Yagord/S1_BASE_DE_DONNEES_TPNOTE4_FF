CREATE SCHEMA universitee;

CREATE TABLE Sexe (
    Cdsexe INTEGER PRIMARY KEY,
    Lbsexe VARCHAR(15)
);


CREATE TABLE Enseignant (
    numens INTEGER primary key,
    nomens VARCHAR(15),
    grade VARCHAR(26),
    ancien INTEGER
);


CREATE TABLE Etudiant (
    numetu INTEGER PRIMARY KEY,
    nometu VARCHAR(15),
    dtnaiss DATE,
    cdsexe INTEGER,
    CONSTRAINT fk_EtudiantSexe FOREIGN KEY (cdsexe)
        REFERENCES Sexe (cdsexe)
);

CREATE TABLE Matiere (
    numat INTEGER PRIMARY KEY,
    nomat VARCHAR(15),
    coeff INTEGER,
    numens INTEGER,
    CONSTRAINT fk_MatiereEnseignant FOREIGN KEY (numens)
        REFERENCES Enseignant(numens)
);

 CREATE TABLE Notes (
    numetu INTEGER,
    numat INTEGER,
    note INTEGER,
    PRIMARY KEY (numetu , numat),
     constraint fk_NotesEtudiant foreign key (numetu) references Etudiant(numEtu),
     constraint fk_NotesMatiere foreign key (numat) references Matiere(numat)
);

INSERT INTO `Sexe` (`Cdsexe`, `Lbsexe`) VALUES
(1, 'garçon'),
(2, 'fille');

INSERT INTO `Enseignant` (`numens`, `nomens`, `grade`, `ancien`) VALUES
(1, 'Fermat', 'agrégé', 15),
(2, 'Cassini', 'maitre de conférence', 10),
(3, 'Hubert', 'professeur des universités', 3),
(4, 'Champollion', 'agrégé', 7),
(5, 'Ouvrard', 'maitre de conférence', 8),
(6, 'Dreutti', 'assistant', 12),
(7, 'Benlarbi', 'maitre de conférence', 25),
(8, 'Tovarich', 'professeur des universités', 30);

INSERT INTO `Etudiant` (`numetu`, `nometu`, `dtnaiss`, `cdsexe`) VALUES
(1, 'Raphaelli', '1998-12-17', 1),
(2, 'Trompeux', '1998-06-04', 1),
(3, 'Francour', '1998-01-29', 2),
(4, 'Goerg', '1998-04-13', 1),
(5, 'Luciere', '1998-05-24', 2),
(6, 'Grouillon', '1997-01-01', 1),
(7, 'Turcaniounou', '1996-06-14', 2),
(8, 'Ahouy', '1999-12-15', 1),
(9, 'Schmidt', '1998-02-12', 1);

INSERT INTO `Matiere` (`numat`, `nomat`, `coeff`, `numens`) VALUES
(1, 'Mathématiques', 3, 4),
(2, 'Littérature', 5, 2),
(3, 'Physique', 7, 1),
(4, 'Sociologie', 5, 5),
(5, 'Informatique', 6, 4),
(6, 'Histoire', 3, 7);

INSERT INTO `Notes` (`numetu`, `numat`, `note`) VALUES
(1, 3, 10),
(2, 1, 13),
(2, 2, 15),
(3, 1, 7),
(3, 2, 4),
(3, 3, 13),
(3, 4, 15),
(3, 5, 10),
(3, 6, 11),
(4, 1, 8),
(5, 1, 14),
(5, 3, 7),
(8, 1, 12),
(8, 2, 9),
(8, 3, 5),
(8, 4, 10),
(8, 5, 11),
(8, 6, 3),
(9, 1, 13),
(9, 2, 14),
(9, 3, 14),
(9, 4, 4),
(9, 5, 17),
(9, 6, 5);

-- 1 --
SELECT numetu, nometu, dtnaiss, lbsexe
FROM Etudiant INNER JOIN Sexe ON Etudiant.cdsexe = Sexe.cdsexe;

-- 2 --
SELECT lbsexe, COUNT(note)
FROM Etudiant INNER JOIN Sexe ON Etudiant.cdsexe = Sexe.cdsexe INNER JOIN Notes ON Etudiant.numetu = Notes.numetu
GROUP BY lbsexe;

-- 3 --
SELECT nomens, COUNT(numat)
FROM Enseignant NATURAL JOIN Matiere
GROUP BY nomens;

-- 4 --
SELECT lbsexe, COUNT(numetu)
FROM Etudiant INNER JOIN Sexe ON Etudiant.cdsexe = Sexe.cdsexe
GROUP BY lbsexe;

-- 5 --
SELECT Etudiant.numetu, Etudiant.nometu
FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu INNER JOIN Matiere ON Notes.numat = Matiere.numat
WHERE note = (SELECT MAX(note)
			FROM Notes INNER JOIN Matiere ON Notes.numat = Matiere.numat
			WHERE nomat = 'Physique');

-- 6 --            
SELECT Etudiant.numetu, Etudiant.nometu, COUNT(note)
FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu INNER JOIN Matiere ON Notes.numat = Matiere.numat
GROUP BY Etudiant.numetu, Etudiant.nometu
HAVING COUNT(note) = 1;

-- 7 --
SELECT numat, nomat
FROM Matiere NATURAL JOIN Enseignant
WHERE nomens = 'Champollion';

-- 8 --
SELECT Etudiant.numetu, Etudiant.nometu
FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu INNER JOIN Matiere ON Notes.numat = Matiere.numat NATURAL JOIN Enseignant
WHERE nomens = 'Champollion'
GROUP BY Etudiant.numetu, Etudiant.nometu
HAVING COUNT(note) >= 1;

-- 9 --
SELECT Etudiant.numetu, Etudiant.nometu, COUNT(note)
FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu INNER JOIN Matiere ON Notes.numat = Matiere.numat NATURAL JOIN Enseignant
WHERE nomens = 'Champollion'
GROUP BY Etudiant.numetu, Etudiant.nometu;

-- 10 --
SELECT Etudiant.numetu, Etudiant.nometu, COUNT(note) AS nbNoteMax
FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu 
GROUP BY Etudiant.numetu, Etudiant.nometu
HAVING COUNT(note) =
(SELECT COUNT(note)
FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu 
GROUP BY Etudiant.numetu, Etudiant.nometu
ORDER BY COUNT(note) DESC
limit 1);

-- 11 --
SELECT Etudiant.numetu, Etudiant.nometu
FROM Etudiant
WHERE Etudiant.numetu NOT IN
(SELECT Etudiant.numetu
FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu INNER JOIN Matiere ON Notes.numat = Matiere.numat NATURAL JOIN Enseignant
GROUP BY Etudiant.numetu, Etudiant.nometu
HAVING COUNT(note) >= 1);

-- 12 --
SELECT Etudiant.numetu, Etudiant.nometu, COUNT(note)
FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu
GROUP BY Etudiant.numetu, Etudiant.nometu
HAVING COUNT(note) = (
						SELECT COUNT(note)
						FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu
						WHERE nometu = 'Trompeux');

-- 13 --
SELECT numat, nomat, lbsexe, AVG(note) AS moyenne
FROM Matiere NATURAL JOIN Notes NATURAL JOIN Etudiant NATURAL JOIN Sexe
GROUP BY numat, nomat, lbsexe;

-- 14 --
SELECT Etudiant.numetu, Etudiant.nometu, SUM(note*coeff)/SUM(coeff) AS moyenneGénérale
FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu INNER JOIN Matiere ON Notes.numat = Matiere.numat
GROUP BY Etudiant.numetu, Etudiant.nometu;

-- 15 --
SELECT Etudiant.numetu, Etudiant.nometu, SUM(note*coeff)/SUM(coeff) AS moyenneGénérale
FROM Etudiant INNER JOIN Notes ON Etudiant.numetu = Notes.numetu INNER JOIN Matiere ON Notes.numat = Matiere.numat
GROUP BY Etudiant.numetu, Etudiant.nometu
ORDER BY SUM(note*coeff)/SUM(coeff) DESC
limit 1;
