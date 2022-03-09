USE ArtGalleryDB
GO

-- a. modify the type of a column.

CREATE OR ALTER PROCEDURE uspModifyArtworkYearFinishedToBIGINT AS
BEGIN
	ALTER TABLE Artwork
	ALTER COLUMN YearFinished BIGINT
END

EXEC uspModifyArtworkYearFinishedToBIGINT

GO
CREATE OR ALTER PROCEDURE ruspModifyArtworkYearFinishedToINT AS
BEGIN
	ALTER TABLE Artwork
	ALTER COLUMN YearFinished INT
END

EXEC ruspModifyArtworkYearFinishedToINT

-- b. add / remove a column.
GO
CREATE OR ALTER PROCEDURE uspRemoveColumnArtworkTitle AS
BEGIN
	IF EXISTS(SELECT 1 
          FROM sys.columns 
          WHERE name = 'Title' AND  
          OBJECT_ID = OBJECT_ID('[dbo].[Artwork]'))
	ALTER TABLE Artwork
	DROP COLUMN Title
END

EXEC uspRemoveColumnArtworkTitle

GO
CREATE OR ALTER PROCEDURE ruspAddColumnArtworkTitle AS
BEGIN
	ALTER TABLE Artwork
	ADD Title VARCHAR(50)
END

EXEC ruspAddColumnArtworkTitle

--------------------------------------------------------------------

-- c. add / remove a DEFAULT constraint.
GO
CREATE OR ALTER PROCEDURE uspAddDefaultPrice AS
BEGIN
	ALTER TABLE ArtworkPurchaseHistory
	DROP CONSTRAINT IF EXISTS df_Price
	ALTER TABLE ArtworkPurchaseHistory
	ADD CONSTRAINT df_Price DEFAULT 0 FOR Price
END

EXEC uspAddDefaultPrice

GO
CREATE OR ALTER PROCEDURE ruspRemoveDefaultPrice AS
BEGIN
	ALTER TABLE ArtworkPurchaseHistory
	DROP CONSTRAINT IF EXISTS df_Price
END

EXEC ruspRemoveDefaultPrice

--------------------------------------------------------------------

-- d. add / remove a primary key.
GO
CREATE OR ALTER PROCEDURE uspRemovePKArtworkRentalExhibition AS
BEGIN
	ALTER TABLE ArtworkRentalExhibition
	DROP CONSTRAINT IF EXISTS PK_ArtworkRentalExhibition
END

EXEC uspRemovePKArtworkRentalExhibition

GO
CREATE OR ALTER PROCEDURE ruspReAddPKArtworkRentalExhibition AS
BEGIN
	ALTER TABLE ArtworkRentalExhibition
	DROP CONSTRAINT IF EXISTS PK_ArtworkRentalExhibition
	ALTER TABLE ArtworkRentalExhibition
	ADD CONSTRAINT PK_ArtworkRentalExhibition PRIMARY KEY NONCLUSTERED(ArtworkId, ExhibitionId)
END

EXEC ruspReAddPKArtworkRentalExhibition

--------------------------------------------------------------------

-- e. add / remove a candidate key.
GO
CREATE OR ALTER PROCEDURE uspAddCKGalleryStaff AS
BEGIN
	ALTER TABLE GalleryStaff
	DROP CONSTRAINT IF EXISTS CK_GalleryStaff
	ALTER TABLE GalleryStaff
	ADD CONSTRAINT CK_GalleryStaff UNIQUE (GalleryStaffId, DOB)
END

EXEC uspAddCKGalleryStaff

GO
CREATE OR ALTER PROCEDURE ruspRemoveCKGalleryStaff AS
BEGIN
	ALTER TABLE GalleryStaff
	DROP CONSTRAINT IF EXISTS CK_GalleryStaff
END

EXEC ruspRemoveCKGalleryStaff

--------------------------------------------------------------------

-- f. add / remove a foreign key.
GO
CREATE OR ALTER PROCEDURE uspRemoveFKArtist AS
BEGIN
	ALTER TABLE Artist
	DROP CONSTRAINT IF EXISTS ArtMovementId
END

EXEC uspRemoveFKArtist

GO
CREATE OR ALTER PROCEDURE ruspAddFKArtist AS
BEGIN
	ALTER TABLE Artist
	DROP CONSTRAINT IF EXISTS ArtMovementId
	ALTER TABLE Artist
	ADD CONSTRAINT ArtMovementId FOREIGN KEY (ArtMovementId) REFERENCES ArtMovement(ArtMovementId)
END

EXEC ruspAddFKArtist

--------------------------------------------------------------------

-- g. create / drop a table.
GO
CREATE OR ALTER PROCEDURE uspAddTableArtDepartment AS
BEGIN
	DROP TABLE IF EXISTS ArtDepartment
	CREATE TABLE ArtDepartment 
		(
		ArtDepartmentId INT PRIMARY KEY,
		ArtDepartmentName VARCHAR(50)
		)
END

EXEC uspAddTableArtDepartment

GO
CREATE OR ALTER PROCEDURE ruspRemoveTableArtDepartment AS
BEGIN 
	DROP TABLE IF EXISTS ArtDepartment
END

EXEC ruspRemoveTableArtDepartment

--------------------------------------------------------------------

DROP TABLE IF EXISTS Versions
CREATE TABLE Versions
	(crt_version INT,
	uspName VARCHAR(100),
	ruspName VARCHAR(100))

INSERT INTO Versions VALUES (1, 'uspModifyArtworkYearFinishedToBIGINT', 'ruspModifyArtworkYearFinishedToINT')
INSERT INTO Versions VALUES (2, 'uspRemoveColumnArtworkTitle', 'ruspAddColumnArtworkTitle')
INSERT INTO Versions VALUES (3, 'uspAddDefaultPrice', 'ruspRemoveDefaultPrice')
INSERT INTO Versions VALUES (4, 'uspRemovePKArtworkRentalExhibition', 'ruspReAddPKArtworkRentalExhibition')
INSERT INTO Versions VALUES (5, 'uspAddCKGalleryStaff', 'ruspRemoveCKGalleryStaff')
INSERT INTO Versions VALUES (6, 'uspRemoveFKArtist', 'ruspAddFKArtist')
INSERT INTO Versions VALUES (7, 'uspAddTableArtDepartment', 'ruspRemoveTableArtDepartment')

SELECT *
FROM Versions

--------------------------------------------------------------------

DROP TABLE IF EXISTS DatabaseVersions
CREATE TABLE DatabaseVersions
	(crt_version INT)

-- INSERT INTO DatabaseVersions VALUES (0)

--------------------------------------------------------------------

GO
CREATE OR ALTER PROCEDURE goToVersion 
	@version INT
AS BEGIN
	DECLARE @crtVersion INT
	SET @crtVersion = (SELECT D.crt_version 
					   FROM DatabaseVersions D)
	
	DECLARE @procedure VARCHAR(100)

	if ISNUMERIC(@version) != 1
	BEGIN
		print('not a number.')
		RETURN
	END

	IF @version < 0 OR @version > 7 -- check for wrong input version 
		BEGIN 
			PRINT 'version must be in [0, 7].'
			RETURN
		END
	
	IF @crtVersion = @version
		BEGIN
			PRINT 'the database is already in the version ' + CONVERT(VARCHAR(2), @crtVersion)
		END
	ELSE 
		BEGIN
			IF @version > @crtVersion 
				BEGIN
					WHILE @version > @crtVersion
						BEGIN
							SET @crtVersion = @crtVersion + 1
							SET @procedure = (SELECT V.uspName 
											  FROM Versions V
											  WHERE V.crt_version = @crtVersion)
							PRINT @procedure
							EXEC @procedure
						END
				END
			ELSE 
				BEGIN
					WHILE @version < @crtVersion 
						BEGIN
							IF @crtVersion != 0 
								BEGIN
									SET @procedure = (SELECT V.ruspName 
													  FROM Versions V
													  WHERE V.crt_version = @crtVersion)
									PRINT @procedure
									EXEC @procedure
								END
							SET @crtVersion = @crtVersion - 1
						END
				END
			UPDATE DatabaseVersions 
			SET crt_version = @version;
			RETURN
		END	
END

--------------------------------------------------------------------

EXEC goToVersion 0

SELECT * 
FROM DatabaseVersions

SELECT *
FROM Artwork

SELECT *
FROM ArtDepartment

