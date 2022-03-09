CREATE TABLE ArtMovement
    (ArtMovementId INT PRIMARY KEY,
    ArtMovementName VARCHAR(50),
    ArtMovementDescription VARCHAR(150))

CREATE TABLE Artist
    (ArtistId INT PRIMARY KEY,
	ArtMovementId INT FOREIGN KEY REFERENCES ArtMovement(ArtMovementId),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE)

CREATE TABLE ArtworkMedium
    (ArtworkMediumId INT PRIMARY KEY,
    ArtworkMediumName VARCHAR(50))

CREATE TABLE Artwork 
    (ArtworkId INT PRIMARY KEY,
    ArtistId INT FOREIGN KEY REFERENCES Artist(ArtistId),
    ArtworkMediumId INT FOREIGN KEY REFERENCES ArtworkMedium(ArtworkMediumId),
    Title VARCHAR(50),
    YearFinished INT)

CREATE TABLE Exhibition
    (ExhibitionId INT PRIMARY KEY,
    ExhibitionName VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    ExhibitionDescription VARCHAR(150))

CREATE TABLE ArtworkRentalExhibition
    (ArtworkId INT REFERENCES Artwork(ArtworkId),
    ExhibitionId INT REFERENCES Exhibition(ExhibitionId),
	CONSTRAINT PK_ArtworkRentalExhibition PRIMARY KEY(ArtWorkId, ExhibitionId))

CREATE TABLE GalleryStaff
	(GalleryStaffId INT PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE,
	PhoneNumber VARCHAR(10) UNIQUE,
	Email VARCHAR(50) UNIQUE,
	Salary INT,
	DateEmployed DATE)


CREATE TABLE StaffExhibition
	(ExhibitionId INT REFERENCES Exhibition(ExhibitionId),
	GalleryStaffId INT REFERENCES GalleryStaff(GalleryStaffId),
	CONSTRAINT PK_StaffExhibitionRole PRIMARY KEY(ExhibitionId, GalleryStaffId))

CREATE TABLE Customer
	(CustomerId INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(10) UNIQUE,
	Email VARCHAR(50) UNIQUE)

CREATE TABLE ArtworkPurchaseHistory 
	(CustomerId INT REFERENCES Customer(CustomerId),
	ArtworkId INT REFERENCES Artwork(ArtworkId),
	Price INT,
	DateOfPurchase DATE,
	CONSTRAINT PK_ArtworkPurchase PRIMARY KEY(CustomerId, ArtworkId))

CREATE TABLE PartnerCompany
	(PartnerCompanyId INT PRIMARY KEY,
    PartnerCompanyName VARCHAR(50),
    PhoneNumber VARCHAR(10) UNIQUE,
	Email VARCHAR(50) UNIQUE)

CREATE TABLE Partnership 
	(PartnerCompanyId INT REFERENCES PartnerCompany(PartnerCompanyId),
	ExhibitionId INT REFERENCES Exhibition(ExhibitionId),
	CONSTRAINT PK_Sponsorship PRIMARY KEY(PartnerCompanyId, ExhibitionId))
