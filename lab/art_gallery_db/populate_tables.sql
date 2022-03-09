USE ArtGalleryDB
GO

-- art movement
INSERT INTO ArtMovement(ArtMovementId, ArtMovementName, ArtMovementDescription) 
VALUES
(1, 'Post-impressionism', 'Post-Impressionism is a predominantly French art movement that developed roughly between 1886 and 1905.'),
(2, 'Expressionism', 'Expressionism is a modernist movement originating in Northern Europe around the beginning of the 20th century.'),
(3, 'Pop-Art', 'Pop art is an art movement that emerged in the United Kingdom and the United States during the mid- to late-1950s.'),
(4, 'Surrealism', 'Surrealism was a cultural movement which developed in Europe in the aftermath of World War I and was largely influenced by Dada.'),
(5, 'High-Renaissance', ' High Renaissance was a short period of the most exceptional artistic production in the Italian states during the Italian Renaissance.')
INSERT INTO ArtMovement(ArtMovementId, ArtMovementName, ArtMovementDescription) 
VALUES
(6, 'Impressionism', 'Impressionism is characterised by relatively small, thin, visible brush strokes, open composition, emphasis on accurate depiction of light.')


-- artist
INSERT INTO Artist(ArtistId, ArtMovementId, FirstName, LastName, DOB)
VALUES
(1, 2, 'Vincent', 'van Gogh', '1890-07-27'),
(2, 5, 'Leonardo', 'da Vinvi', '1452-07-15'),
(3, 3, 'Yayoi', 'Kusama', '1929-03-22'),
(4, 4, 'Salvador', 'Dali', '1904-05-11'),
(5, 2, 'Edvard', 'Munch', '1863-12-12'),
(6, 5, 'Michelangelo', 'Buonarroti', '1475-03-06'),
(7, 3, 'Keith', 'Haring', '1958-05-04'),
(8, 3, 'Andy', 'Warhol', '1928-08-06')
INSERT INTO Artist(ArtistId, ArtMovementId, FirstName, LastName, DOB)
VALUES
(9, 6, 'Claude', 'Monet', '1840-11-14')
INSERT INTO Artist(ArtistId, ArtMovementId, FirstName, LastName, DOB)
VALUES
(10, NULL, 'Xohn', 'Xena', '1919-09-10'),
(11, NULL, 'Ovidiu', 'Stan', '1966-12-10')
INSERT INTO Artist(ArtistId, ArtMovementId, FirstName, LastName, DOB)
VALUES
(12, 4, 'Andrew', 'Red', '1999-09-10'),
(13, 4, 'Luke', 'Blue', '1999-05-11')
-- insert data – one statement should violate referential integrity constraints (1)
-- INSERT INTO Artist(ArtistId, ArtMovementId, FirstName, LastName, DOB) VALUES (11, 99, 'A', 'B', '1999-01-01')
-- update data (1)
UPDATE Artist
SET LastName = 'da Vinci'
WHERE (ArtistId = 2 AND FirstName = 'Leonardo')


-- artwork medium
INSERT INTO ArtworkMedium(ArtworkMediumId, ArtworkMediumName)
VALUES
(1, 'oil'),
(2, 'pastel'),
(3, 'acrylics'),
(4, 'marble sculpture')
INSERT INTO ArtworkMedium(ArtworkMediumId, ArtworkMediumName)
VALUES
(5, 'graffiti'),
(6, 'synthetic polymer')
-- delete (1)
DELETE
FROM ArtworkMedium
WHERE ArtworkMediumId = 2

-- artwork
INSERT INTO Artwork(ArtworkId, ArtistId, ArtworkMediumId, Title, YearFinished)
VALUES
(1, 1, 1, 'The Starry Night', 1889),
(2, 1, 1, 'Green Wheat Field with Cypress', 1889),
(3, 1, 1, 'Starry Night Over the Rhône', 1888),
(4, 1, 1, 'Sunflowers', 1888),
(5, 2, 1, 'Mona Lisa', 1517),
(6, 2, 1, 'The Last Supper', 1498),
(7, 4, 1, 'The First Days of Spring', 1929),
(8, 4, 1, 'The Burning Giraffe', 1937),
(9, 4, 1, 'The Invisible Man', 1932),
(10, 3, 3, 'Flowers', 1983),
(11, 5, 1, 'The Dance of Life', 1900),
(12, 5, 3, 'Love and Pain', 1895),
(13, 5, 1, 'The Scream', 1893),
(14, 6, 4, 'David', 1504),
(15, 6, 4, 'Madonna of Bruges', 1504),
(16, 6, 3, 'The Creation of Adam', 1512),
(17, 7, 5, 'Keith Haring Mural', 1984),
(18, 8, 6, 'Campbells Soup Cans', 1962),
(19, 8, 3, 'Shot Marilyns', 1964),
(20, 9, 1, 'Woman with a Parasol', 1875),
(21, 9, 1, 'Impression, Sunrise', 1872),
(22, 9, 1, 'Le Bassin Aux Nymphéas', 1919)
INSERT INTO Artwork(ArtworkId, ArtistId, ArtworkMediumId, Title, YearFinished)
VALUES
(23, 9, 1, NULL, NULL)
INSERT INTO Artwork(ArtworkId, ArtistId, ArtworkMediumId, Title, YearFinished)
VALUES
(24, 2, 1, NULL, 1499)
INSERT INTO Artwork(ArtworkId, ArtistId, ArtworkMediumId, Title, YearFinished)
VALUES
(25, 10, 1, NULL, NULL)
-- insert data – one statement should violate referential integrity constraints (2)
-- INSERT INTO Artwork(ArtworkId, ArtistId, ArtworkMediumId, Title, YearFinished) VALUES (23, 11, 7, 'Problem Painting', 666)


-- exhibition
INSERT INTO Exhibition(ExhibitionId, ExhibitionName, StartDate, EndDate, ExhibitionDescription)
VALUES
(1, 'New Wave of Modern Art', '2021-04-12', '2021-05-29', NULL),
(2, 'Appreciation for Statues', '2021-12-05', '2022-01-15', 'Giving the statues the love they deserve, putting them in the spotlight.'),
(3, 'A Journey Back In Time', '2010-11-09', '2010-12-04', NULL),
(4, 'Oil Paintings', '2023-09-05', '2023-09-30', NULL),
(5, 'Women in the Center', '2020-05-06', '2020-06-10', 'This exhibitions is an appreciation for women and fights against discrimination.'),
(6, 'Nature', '2020-12-10', '2021-02-01', 'Although the exhibition is not set in the nature, give the nature some appreciation.')


-- artwork rental exhibition
INSERT INTO ArtworkRentalExhibition(ArtworkId, ExhibitionId)
VALUES
(17, 1),
(18, 1),
(19, 1),
(14, 2),
(15, 2),
(5, 3),
(1, 3),
(2, 3),
(3, 3),
(14, 3),
(16, 3),
(1, 4),
(2, 4),
(3, 4),
(5, 4),
(13, 4),
(15, 4),
(21, 4),
(5, 5),
(15, 5),
(19, 5),
(20, 5),
(2, 6),
(3, 6),
(10, 6),
(21, 6),
(22, 6)
INSERT INTO ArtworkRentalExhibition(ArtworkId, ExhibitionId)
VALUES
(8, 1)
INSERT INTO ArtworkRentalExhibition(ArtworkId, ExhibitionId)
VALUES
(15, 3)

-- gallery staff
INSERT INTO GalleryStaff(GalleryStaffId, FirstName, LastName, DOB, PhoneNumber, Email, Salary, DateEmployed)
VALUES
(1, 'Alice', 'Green', '1999-12-01', '0712111222', 'alicegreen@yahoo.com', 2000, '2010-10-09'),
(2, 'Tyrone', 'Mikelson', '1977-12-27', '0734112112', 'tyrone_mik@gmail.com', 2700, '2009-09-05'),
(3, 'Allen', 'Rock', '2000-06-09', '0799222333', 'allen.rock@gmail.com', 2200, '2010-07-09'),
(4, 'Heather', 'Johnson', '1994-03-11', '0766111444', 'heather_johnson11@gmail.com', 2600, '2012-09-12'),
(5, 'Diana', 'Bridge', '1989-12-22', '0788222333', 'dianaa.bridge@gmail.com', 2400, '2011-11-11'),
(6, 'John', 'Green', '1999-02-06', '0799111333', 'johngreen@yahoo.com', 2400, '2012-02-21'),
(7, 'Alexander', 'Bridge', '1979-09-01', '0777222111', 'alex_bridge@gmail.com', 2200, '2012-10-05'),
(8, 'Elizabeth', 'Johnson', '1989-12-22', '0744666222', 'liz_johnson@yahoo.com', 2200, '2011-01-11'),
(9, 'Manila', 'Johnson', '1986-09-04', '0733222555', NULL, 2700, '2021-11-01')
INSERT INTO GalleryStaff(GalleryStaffId, FirstName, LastName, DOB, PhoneNumber, Email, Salary, DateEmployed)
VALUES
(10, 'Emily', 'Baker', '2000-02-04', '0798555333', 'em_baker@yahoo.com', 2300, '2021-10-22')
INSERT INTO GalleryStaff(GalleryStaffId, FirstName, LastName, DOB, PhoneNumber, Email, Salary, DateEmployed)
VALUES
(11, 'Jack', 'Wilson', '2001-01-01', '0766343555', 'jack.wilson@yahoo.com', 2700, '2021-05-09')
-- update data (2)
UPDATE GalleryStaff
SET Email = 'manilaj@yahoo.com'
WHERE (Email IS NULL AND FirstName = 'Manila')


-- staff exhibition
INSERT INTO StaffExhibition(ExhibitionId, GalleryStaffId)
VALUES
(1, 1),
(1, 2),
(1, 6),
(1, 7),
(1, 8),
(2, 3),
(2, 4),
(2, 6),
(3, 1),
(3, 2),
(3, 3),
(4, 8),
(4, 6),
(4, 5),
(4, 4),
(5, 2),
(6, 2),
(6, 3)
INSERT INTO StaffExhibition(ExhibitionId, GalleryStaffId)
VALUES
(6, 6)


-- customer
INSERT INTO Customer(CustomerId, FirstName, LastName, PhoneNumber, Email)
VALUES
(1, 'John', 'Johnson', '0711000999', 'john_johnson@gmail.com'),
(2, 'John', 'Doe', '0711000111', 'john_doe@gmail.com'),
(3, 'Anna', 'Robbins', '0711000333', 'anna_robbins@gmail.com'),
(4, 'Emilia', 'Johnson', '0711000222', 'emilia_johnson@gmail.com'),
(5, 'Giorno', 'Giovanna', '0711000444', 'gg@gmail.com'),
(6, 'Kujo', 'Jotaro', '0711000555', 'kujo.jotaro@gmail.com'),
(7, 'Luke', 'Hemmings', '0711000777', 'Luke.hems@gmail.com'),
(8, 'Ryan', 'Golding', '0711000666', 'rg@gmail.com')
INSERT INTO Customer(CustomerId, FirstName, LastName, PhoneNumber, Email)
VALUES
(9, 'Robin', 'Night', '0780333222', 'robin_night@yahoo.com')
-- delete (2)
DELETE
FROM Customer
WHERE CustomerId IN (8, 10, 11)
-- update data (3)
UPDATE Customer
SET LastName = 'Todd'
WHERE (FirstName = 'Emilia' OR CustomerId IN (2, 3))


-- artwork purchase history
INSERT INTO ArtworkPurchaseHistory(CustomerId, ArtworkId, Price, DateOfPurchase)
VALUES
(1, 1, 600000, '2021-07-05'),
(1, 6, 700000, '2020-08-15'),
(1, 7, 5000000, '2020-01-09'),
(5, 9, 100000, '2021-04-09')
INSERT INTO ArtworkPurchaseHistory(CustomerId, ArtworkId, Price, DateOfPurchase)
VALUES
(2, 3, NULL, '2021-09-12'),
(2, 4, NULL, '2019-09-09'),
(3, 8, NULL, '2021-06-10')
INSERT INTO ArtworkPurchaseHistory(CustomerId, ArtworkId, Price, DateOfPurchase)
VALUES
(3, 10, 1000000, '2021-10-31')
INSERT INTO ArtworkPurchaseHistory(CustomerId, ArtworkId, Price, DateOfPurchase)
VALUES
(4, 23, 2000000, '2021-08-31'),
(6, 24, 900000, '2021-05-11')
INSERT INTO ArtworkPurchaseHistory(CustomerId, ArtworkId, Price, DateOfPurchase)
VALUES
(6, 2, 400000, '2020-11-09')
INSERT INTO ArtworkPurchaseHistory(CustomerId, ArtworkId, Price, DateOfPurchase)
VALUES
(9, 2, 450000, '2021-06-03')

-- partner company
INSERT INTO PartnerCompany(PartnerCompanyId, PartnerCompanyName, PhoneNumber, Email)
VALUES
(1, 'Lidl', '0791000111', 'lidl@company.com'),
(2, 'Kaufland', '0781000222', 'kaufland@company.com'),
(3, 'Chess.com', '0791000222', 'chess@comp.com'),
(4, 'Samsung', '0791000444', 'samsung@comp.com'),
(5, 'Apple', '0791000666', 'apple@comp.com'),
(6, 'Alverde', '0791000888', 'Alverde@company.com')
INSERT INTO PartnerCompany(PartnerCompanyId, PartnerCompanyName, PhoneNumber, Email)
VALUES
(7, 'DM Market', '0766222444', 'dm_market@company.com'),
(8, 'VOSS', '0711222444', 'VOSS@company.com')


-- partnership
INSERT INTO Partnership(PartnerCompanyId, ExhibitionId)
VALUES
(1, 1),
(1, 3),
(1, 5),
(2, 2),
(3, 4),
(3, 5),
(4, 6),
(5, 3),
(6, 6),
(6, 5)