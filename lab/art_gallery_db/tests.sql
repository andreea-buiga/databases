USE ArtGalleryDB
GO

-- create views
CREATE OR ALTER VIEW View_1 AS
SELECT ArtworkId, ArtistId, ArtworkMediumId, Title, YearFinished
FROM Artwork
GO

-- SELECT * FROM View_1

CREATE OR ALTER VIEW View_2 AS
SELECT A.FirstName, A.LastName, Art.Title, AM.ArtMovementName
FROM Artist A
INNER JOIN ArtMovement AM ON AM.ArtMovementId = A.ArtMovementId
INNER JOIN Artwork Art ON Art.ArtistId = A.ArtistId
INNER JOIN ArtworkRentalExhibition ARE ON ARE.ArtworkId = Art.ArtworkId
GO

-- SELECT * FROM View_2

CREATE OR ALTER VIEW View_3 AS
SELECT E.ExhibitionId, COUNT(GS.GalleryStaffId) as 'NoEmployees'
FROM Exhibition E
INNER JOIN StaffExhibition SE ON E.ExhibitionId = SE.ExhibitionId
INNER JOIN GalleryStaff GS ON GS.GalleryStaffId = SE.GalleryStaffId
WHERE FLOOR(DATEDIFF(DAY, GS.DateEmployed, GETDATE())/365) > 10
GROUP BY E.ExhibitionId
GO

-- SELECT * FROM View_3

-----------------------------------------------------------------------------------------

INSERT INTO Tables(Name) Values
('Exhibition'),
('Artworks'),
('ArtworkRentalExhibition')

SELECT *
FROM Tables

INSERT INTO Views Values
('View_1'),
('View_2'),
('View_3')

SELECt * FROM Views

INSERT INTO Tests VALUES
('selectView'),
('insertExhibition'),
('deleteExhibition'),
('insertArtwork'),
('deleteArtwork'),
('insertArtworkRentalExhibition'),
('deleteArtworkRentalExhibition')

SELECT *
FROM Tests

INSERT INTO TestViews VALUES
(1, 1),
(1, 2),
(1, 3)

SELECT *
FROM TestViews

INSERT INTO TestTables VALUES
(2, 1, 500, 1),
(4, 2, 500, 2),
(6, 3, 500, 3)

SELECT *
FROM TestTables

-----------------------------------------------------------------------------------------

GO
CREATE OR ALTER PROCEDURE insertArtwork @rows INT
AS
	BEGIN
		DECLARE @id INT
		DECLARE @artistId INT
		DECLARE @artworkMediumId INT
		DECLARE @title VARCHAR(50)
		DECLARE @i INT
		DECLARE @lastId INT
		SET @i = 1
		SET @artistId = 1
		SET @artworkMediumId = 1

		WHILE @i <= @rows
			BEGIN 
				SET @id = 1000 + @i
				SET @title = 'ArtworkName' + CONVERT(VARCHAR(5), @id)
				INSERT INTO Artwork VALUES(@id, @artistId, @artworkMediumId, NULL, @title)
				SET @i = @i + 1
			END
	END
GO

CREATE OR ALTER PROCEDURE deleteArtwork @rows int
AS
	BEGIN
		DECLARE @id int
		DECLARE @i int
		DECLARE @lastId int

		SET @id = 1000
		SET @i = @rows

		WHILE @i > 0
			BEGIN
				SET @id = 1000 + @i
				DELETE FROM Artwork WHERE Artwork.ArtworkId = @id
				SET @i = @i - 1
			END
	END
GO

CREATE OR ALTER PROCEDURE insertExhibition @rows INT
AS
	BEGIN
		DECLARE @id INT
		DECLARE @name VARCHAR(50)
		DECLARE @description VARCHAR(150)
		DECLARE @i INT
		DECLARE @lastId INT
		SET @i = 1
		

		WHILE @i <= @rows
			BEGIN 
				SET @id = 1000 + @i
				SET @name = 'ExhibitionName' + CONVERT(VARCHAR(5), @id)
				SET @description = 'ExhibitionDescrition' + CONVERT(VARCHAR(5), @id)
				INSERT INTO Exhibition VALUES(@id, @name, NULL, NULL, @description)
				SET @i = @i + 1
			END
	END
GO

CREATE OR ALTER PROCEDURE deleteExhibition @rows INT
AS
	BEGIN
		DECLARE @id int
		DECLARE @i int
		DECLARE @lastId int

		SET @id = 1000
		SET @i = @rows

		WHILE @i > 0
			BEGIN
				SET @id = 1000 + @i
				DELETE FROM Exhibition WHERE Exhibition.ExhibitionId = @id
				SET @i = @i - 1
			END
	END
GO

CREATE OR ALTER PROCEDURE insertArtworkRentalExhibition @rows INT 
AS
	BEGIN
		DECLARE @i INT
		SET @i = 1

		WHILE @i <= @rows
			BEGIN
				INSERT INTO ArtworkRentalExhibition VALUES (@i + 1000, @i + 1000)
				SET @i = @i + 1
			END
	END
GO

CREATE OR ALTER PROCEDURE deleteArtworkRentalExhibition @rows INT
AS
	BEGIN
		DECLARE @i INT
		DECLARE @idA INT
		SET @i = @rows

		WHILE @i > 0
			BEGIN
				SELECT TOP 1 @idA = Artwork.ArtworkId FROM dbo.Artwork ORDER BY Artwork.ArtworkId DESC
				IF @idA > 1
					BEGIN
						DELETE 
						FROM ArtworkRentalExhibition 
						WHERE ArtworkRentalExhibition.ArtworkId = @i + 1000
					END
				SET @i = @i - 1
			END
	END
GO

-----------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE selectView (@viewName VARCHAR(50))
AS
	BEGIN
		IF @viewName = 'View_1'
			BEGIN
				SELECT *
				FROM View_1
			END
		IF @viewName = 'View_2'
			BEGIN
				SELECT *
				FROM View_2
			END
		IF @viewName = 'View_3'
			BEGIN
				SELECT *
				FROM View_3
			END
	END
GO

-----------------------------------------------------------------------------------------

CREATE OR ALTER PROC TestRunViewsProc --@viewName VARCHAR(50)
AS 
	DECLARE @start1 DATETIME
	DECLARE @start2 DATETIME
	DECLARE @start3 DATETIME
	DECLARE @end1 DATETIME
	DECLARE @end2 DATETIME
	DECLARE @end3 DATETIME
	
	SET @start1 = GETDATE()
	PRINT ('executing select * from View_1')
	EXEC selectView View_1
	SET @end1 = GETDATE()
	INSERT INTO TestRuns VALUES ('test_view_1', @start1, @end1)
	INSERT INTO TestRunViews VALUES (@@IDENTITY, 1, @start1, @end1)
	
	SET @start2 = GETDATE()
	PRINT ('executing SELECT * FROM View_2')
	EXEC selectView View_2
	SET @end2 = GETDATE()
	INSERT INTO TestRuns VALUES ('test_view_2', @start2, @end2)
	INSERT INTO TestRunViews VALUES (@@IDENTITY, 2, @start2, @end2)

	SET @start3 = GETDATE()
	PRINT ('executing SELECT * FROM View_3')
	EXEC selectView View_3
	SET @end3 = GETDATE()
	INSERT INTO TestRuns VALUES ('test_view_3', @start3, @end3)
	INSERT INTO TestRunViews VALUES (@@IDENTITY, 3, @start3, @end3)	
GO

CREATE OR ALTER PROC TestRunTablesProc --@tableName VARCHAR(50)
AS 
	DECLARE @start1 DATETIME
	DECLARE @start2 DATETIME
	DECLARE @start3 DATETIME
	DECLARE @start4 DATETIME
	DECLARE @start5 DATETIME
	DECLARE @start6 DATETIME
	DECLARE @end1 DATETIME
	DECLARE @end2 DATETIME
	DECLARE @end3 DATETIME
	DECLARE @end4 DATETIME
	DECLARE @end5 DATETIME
	DECLARE @end6 DATETIME


	DECLARE @rowsArtwork INT
	SELECT @rowsArtwork = NoOfRows FROM TestTables WHERE TestId = 2
			
	SET @start2 = GETDATE();
	PRINT('deleting data from Artwork.')
	EXEC deleteArtwork @rowsArtwork
	SET @end2 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_delete_artwork', @start2, @end2)
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 1, @start2, @end2)

	-------------------------------------------------------------------

	SET @start1 = GETDATE()
	PRINT('inserting data into Artwork.')
	EXEC insertArtwork @rowsArtwork
	SET @end1 = GETDATE()
	INSERT INTO TestRuns VALUES ('test_insert_artwork', @start1, @end1)
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 1, @start1, @end1)

	-------------------------------------------------------------------
	
	DECLARE @rowsExhibition INT
	SELECT @rowsExhibition = NoOfRows FROM TestTables WHERE TestId = 4

	SET @start4 = GETDATE()
	PRINT('deleting data from Exhibition')
	EXEC deleteExhibition @rowsExhibition
	SET @end4 = GETDATE()
	INSERT INTO TestRuns VALUES ('test_delete_exhibition', @start4, @end4)
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 2, @start4, @end4)

	-------------------------------------------------------------------

	SET @start3 = GETDATE()
	PRINT('inserting data into Exhibition.')
	EXEC insertExhibition @rowsExhibition
	SET @end3 = GETDATE()
	INSERT INTO TestRuns VALUES ('test_insert_exhibition', @start3, @end3)
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 2, @start3, @end3)

	-------------------------------------------------------------------

	DECLARE @rowsARE INT
	SELECT @rowsARE = NoOfRows FROM TestTables WHERE TestId = 6

	SET @start6 = GETDATE()
	PRINT('deleting data from ArtworkRentalExhibition.')
	EXEC deleteArtworkRentalExhibition @rowsARE
	SET @end6 = GETDATE()
	INSERT INTO TestRuns VALUES ('test_delete_are', @start6, @end6)
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 3, @start6, @end6)

	-------------------------------------------------------------------

	SET @start5 = GETDATE()
	PRINT('inserting data into ArtworkRentalExhibition.')
	EXEC insertArtworkRentalExhibition @rowsARE
	SET @end5 = GETDATE()
	INSERT INTO TestRuns VALUES ('test_insert_are', @start5, @end5)
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 3, @start5, @end5)
GO 

EXEC TestRunTablesProc 
EXEC TestRunViewsProc

SELECT * FROM Artwork
SELECT * FROM Exhibition
SELECT * FROM ArtworkRentalExhibition

SELECT * FROM TestRuns
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews

DELETE FROM TestRuns
DELETE FROM TestRunTables
DELETE FROM TestRunViews

/*
DROP TABLE TestRunViews
DROP TABLE TestRunTables
DROP TABLE TestRuns
DROP TABLE TestTables
DROP TABLE TestViews
DROP TABLE Tests
DROP TABLE Tables
DROP TABLE Views*/