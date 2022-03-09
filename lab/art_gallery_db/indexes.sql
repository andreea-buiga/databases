CREATE DATABASE Lab_5

USE Lab_5
GO

/*
Work on 3 tables of the form Ta(aid, a2, …), Tb(bid, b2, …), Tc(cid, aid, bid, …), where:
	• aid, bid, cid, a2, b2 are integers;
	• the primary keys are underlined;
	• a2 is UNIQUE in Ta;
	• aid and bid are foreign keys in Tc, referencing the primary keys in Ta and Tb, respectively.
*/

-----------------------------------------------------------------------------------------

-- Ta
DROP TABLE IF EXISTS GalleryEmployees
CREATE TABLE GalleryEmployees(
	GalleryEmployeeId INT PRIMARY KEY,
	CNP INT UNIQUE,
	DateEmployeed DATE
	)

-- Tb
DROP TABLE IF EXISTS Exhibitions
CREATE TABLE Exhibitions(
	ExhibitionId INT PRIMARY KEY,
	TicketPrice INT,
	ExhibitionName VARCHAR(100)
	)

-- Tc
DROP TABLE IF EXISTS GalleryEmployeesExhibitions
CREATE TABLE GalleryEmployeesExhibitions (
	GEEId INT PRIMARY KEY, 
	ExhibitionId INT FOREIGN KEY REFERENCES Exhibitions(ExhibitionId),
	GalleryEmployeeId INT FOREIGN KEY REFERENCES GalleryEmployees(GalleryEmployeeId)
	)

-----------------------------------------------------------------------------------------

SELECT * FROM GalleryEmployees
SELECT * FROM Exhibitions
SELECT * FROM GalleryEmployeesExhibitions

-----------------------------------------------------------------------------------------

-- a. Write queries on Ta such that their execution plans contain the following operators:

-- • clustered index scan
-- • condition: column DateEmployeed

SELECT GalleryEmployeeId, CNP
FROM GalleryEmployees
WHERE DateEmployeed IN ('2009-12-10', '2010-12-10')


-- • clustered index seek
-- • condition: column GalleryEmployeeId (primary key)

SELECT GalleryEmployeeId, CNP
FROM GalleryEmployees
WHERE GalleryEmployeeId BETWEEN 6 AND 30


-- • nonclustered index scan
-- • CNP - nonclustered index

SELECT CNP
FROM GalleryEmployees

-- • nonclustered index seek
-- • CNP - nonclustered index
-- • ESC: 0.0032831

SELECT CNP
FROM GalleryEmployees
WHERE CNP BETWEEN 60001 AND 60010


-- • key lookup
-- • nonclustered index seek + key lookup

SELECT DateEmployeed
FROM GalleryEmployees
WHERE CNP = 60001

-- b. Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan.
-- Create a nonclustered index that can speed up the query.
-- Examine the execution plan again.

-- • clustered index scan
-- • esc: 0.003392
SELECT ExhibitionId
FROM Exhibitions
WHERE ExhibitionName LIKE 'exhibition2%'

-- • non-clustered index seek

DROP INDEX IF EXISTS index_Exhibitions_ExhibitionName ON Exhibitions

GO
CREATE INDEX index_Exhibitions_ExhibitionName ON Exhibitions(ExhibitionName)

-- • execution plan: nonclustered index seek, which would be more efficient
-- • esc: 0.0032967
SELECT ExhibitionId
FROM Exhibitions
WHERE ExhibitionName LIKE 'exhibitions2%'
GO

-- c. Create a view that joins at least 2 tables.
-- Check whether existing indexes are helpful; if not, reassess existing indexes / examine the cardinality of the tables.

GO
CREATE OR ALTER VIEW view_GalleryEmployees_Exhibitions
AS
	SELECT GE.CNP, E.ExhibitionName
	FROM Exhibitions E
	INNER JOIN GalleryEmployeesExhibitions GEE ON GEE.ExhibitionId = E.ExhibitionId
	INNER JOIN GalleryEmployees GE ON GE.GalleryEmployeeId = GEE.GalleryEmployeeId
	WHERE TicketPrice > 100
GO

-- • clustered index seek (GE.GalleryEmployeeId) + clustered index scan (GEE.GEEId) for GEE.ExhibitionId and GEE.GalleryEmployeeId + clustered index seek (Exhibitions.TicketPrice)
-- • esc: 0.0275408
-- • cannot be optimized: the index scan is needed, has to go through all rows to check: TicketPrice > 100

SELECT *
FROM view_GalleryEmployees_Exhibitions

DROP INDEX IF EXISTS index_GalleryEmployeesExhibitions ON GalleryEmployeesExhibitions
CREATE NONCLUSTERED INDEX index_GalleryEmployeesExhibitions ON GalleryEmployeesExhibitions(ExhibitionId, GalleryEmployeeId)

SELECT *
FROM view_GalleryEmployees_Exhibitions


