USE master
GO

IF DB_ID('BBBmark2908') IS NOT NULL
BEGIN
ALTER DATABASE BBBmark2908 SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE BBBmark2908
END

CREATE DATABASE BBBmark2908
GO
USE BBBmark2908
GO

DROP TABLE IF EXISTS Vaskerier
CREATE TABLE Vaskerier (
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Navn NVARCHAR(MAX),
Åben TIME,
Lukket TIME
)

DROP TABLE IF EXISTS Brugere
CREATE TABLE Brugere (
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Username NVARCHAR(MAX),
Mail NVARCHAR(50) UNIQUE,
[Password] NVARCHAR(MAX) CHECK (LEN([Password]) >= 5),
Konto DECIMAL,
Bruger_Vaskeri INT FOREIGN KEY(Bruger_Vaskeri) REFERENCES Vaskerier(Id),
Oprettet DATETIME
)

DROP TABLE IF EXISTS Maskiner
CREATE TABLE Maskiner (
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Navn NVARCHAR(MAX),
Pris_Vask DECIMAL,
Tid_Per_Vask INT,
Vaskeri_Id INT FOREIGN KEY(Vaskeri_Id) REFERENCES Vaskerier(Id)
)

DROP TABLE IF EXISTS Bookinger
CREATE TABLE Bookinger (
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
BookTidspunkt DATETIME,
Bruger_ID INT FOREIGN KEY REFERENCES Brugere(Id),
Maskine_ID INT FOREIGN KEY REFERENCES Maskiner(Id)
)
GO
INSERT INTO Vaskerier (Navn, Åben, Lukket)
VALUES('Whitewash Inc', '08:00', '20:00')
INSERT INTO Vaskerier (Navn, Åben, Lukket)
VALUES('Double Bubble', '02:00', '22:00')
INSERT INTO Vaskerier (Navn, Åben, Lukket)
VALUES('Wash & Coffee', '12:00', '20:00')

INSERT INTO Maskiner (Navn, Pris_Vask, Tid_Per_Vask, Vaskeri_Id)VALUES('Mielle 911 Turbo', 5.00 , 60, 2)
INSERT INTO Maskiner (Navn, Pris_Vask, Tid_Per_Vask, Vaskeri_Id)VALUES('Siemons IClean', 10000.00 , 30, 1)
INSERT INTO Maskiner (Navn, Pris_Vask, Tid_Per_Vask, Vaskeri_Id)VALUES('Electrolax FX-2', 15.00 , 45, 2)
INSERT INTO Maskiner (Navn, Pris_Vask, Tid_Per_Vask, Vaskeri_Id)VALUES('NASA Spacewasher 8000', 500.00, 5, 1)
INSERT INTO Maskiner (Navn, Pris_Vask, Tid_Per_Vask, Vaskeri_Id)VALUES('The Lost Sock', 3.50 , 90, 3)
INSERT INTO Maskiner (Navn, Pris_Vask, Tid_Per_Vask, Vaskeri_Id)VALUES('Yo Mama', 0.50 , 120, 3)

INSERT INTO Brugere (Username, Mail, [Password], Konto, Bruger_Vaskeri, Oprettet)
VALUES ('John', 'john_doe66@gmail.com', 'password',	100.00, 2, 2021-02-15)
INSERT INTO Brugere (Username, Mail, [Password], Konto, Bruger_Vaskeri, Oprettet)
VALUES ('Neil Armstrong', 'firstman@nasa.gov', 'eagleLander69',	1000.00, 1, 2021-02-10)
INSERT INTO Brugere (Username, Mail, [Password], Konto, Bruger_Vaskeri, Oprettet)
VALUES ('Batman', 'noreply@thecave.com', 'Rob1n', 500.00, 3, 2020-03-10)
INSERT INTO Brugere (Username, Mail, [Password], Konto, Bruger_Vaskeri, Oprettet)
VALUES ('Goldman Sachs', 'moneylaundering@gs.com', 'NotRecognized',	100000.00, 1, 2021-01-01)
INSERT INTO Brugere (Username, Mail, [Password], Konto, Bruger_Vaskeri, Oprettet)
VALUES ('50 Cent', '50cent@gmail.com', 'ItsMyBirthday', 0.50, 3, 2020-07-06)

INSERT INTO Bookinger (BookTidspunkt, Bruger_ID, Maskine_ID)VALUES ('2021-02-26 12:00', 1, 1)
INSERT INTO Bookinger (BookTidspunkt, Bruger_ID, Maskine_ID)VALUES ('2021-02-26 16:00', 1, 3)
INSERT INTO Bookinger (BookTidspunkt, Bruger_ID, Maskine_ID)VALUES ('2021-02-26 08:00', 2, 4)
INSERT INTO Bookinger (BookTidspunkt, Bruger_ID, Maskine_ID)VALUES ('2021-02-26 15:00', 3, 5)
INSERT INTO Bookinger (BookTidspunkt, Bruger_ID, Maskine_ID)VALUES ('2021-02-26 20:00', 4, 2)
INSERT INTO Bookinger (BookTidspunkt, Bruger_ID, Maskine_ID)VALUES ('2021-02-26 19:00', 4, 2)
INSERT INTO Bookinger (BookTidspunkt, Bruger_ID, Maskine_ID)VALUES ('2021-02-26 10:00', 4, 2)
INSERT INTO Bookinger (BookTidspunkt, Bruger_ID, Maskine_ID)VALUES ('2021-02-26 16:00', 5, 6)
INSERT INTO Bookinger (BookTidspunkt, Bruger_ID, Maskine_ID)VALUES ('2023-02-02 12:00', 4, 2) 

UPDATE Brugere
SET Konto = Konto - (SELECT Pris_Vask FROM Maskiner WHERE Maskiner.Id = 2)
WHERE Brugere.Id = 4

SELECT Brugere.Konto FROM Brugere WHERE Brugere.Username = 'Goldman Sachs'

GO
CREATE VIEW Booking AS
SELECT Bookinger.BookTidspunkt, Brugere.Username, Maskiner.Navn, Maskiner.Pris_Vask as 'Pris per vask'
FROM Bookinger
JOIN Brugere ON Bookinger.ID = Brugere.ID
JOIN Maskiner ON Bookinger.ID = Maskiner.ID;
GO
SELECT * FROM Booking

SELECT Mail FROM Brugere WHERE Mail like '%gmail.com%'

SELECT Maskiner.Navn as "Machine Name", Vaskerier.Navn as "Laundry Name", Vaskerier.Åben as 'Åbningstid', Vaskerier.Lukket as 'Lukningstid'
FROM Maskiner
INNER JOIN Vaskerier ON Maskiner.Vaskeri_ID = Vaskerier.ID
ORDER BY Vaskerier.ID;

SELECT Maskiner.ID AS 'Maskine ID', COUNT(Bookinger.ID) AS 'Antal Bookinger'
FROM Maskiner
JOIN Bookinger ON Maskiner.ID = Bookinger.Maskine_ID
GROUP BY Maskiner.ID;

DELETE FROM Bookinger
WHERE CAST(Bookinger.BookTidspunkt AS TIME) BETWEEN '12:00' AND '13:00';

SELECT * FROM Bookinger


UPDATE Brugere
SET Password = 'SelinaKyle'
WHERE Username = 'Batman';
SELECT Brugere.Password FROM Brugere WHERE Brugere.Username = 'Batman'
--------------------------------------------------------------------------------------------------------------