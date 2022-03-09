CREATE DATABASE WomenShoes

USE WomenShoes
GO

-- 1) sql script that creates the corresponding relational data model

DROP TABLE IF EXISTS Transactions
DROP TABLE IF EXISTS ShoeStocks
DROP TABLE IF EXISTS Shoes
DROP TABLE IF EXISTS ShoeModels
DROP TABLE IF EXISTS PresentationShops
DROP TABLE IF EXISTS Women

CREATE TABLE PresentationShops
	(ShopId INT PRIMARY KEY,
	ShopName VARCHAR(100),
	City VARCHAR(100))

CREATE TABLE Women
	(WomanId INT PRIMARY KEY,
	WomanName VARCHAR(100),
	MaxAmount INT)

CREATE TABLE ShoeModels
	(ShoeModelId INT PRIMARY KEY,
	ShoeModelName VARCHAR(100),
	Season VARCHAR(100))

CREATE TABLE Shoes
	(ShoeId INT PRIMARY KEY,
	Price INT,
	ShoeModelId INT FOREIGN KEY REFERENCES ShoeModels(ShoeModelId))

CREATE TABLE ShoeStocks
	(ShoeStock INT PRIMARY KEY IDENTITY (1, 1),
	NoAvailableShoes INT,
	ShopId INT FOREIGN KEY REFERENCES PresentationShops(ShopId),
	ShoesId INT FOREIGN KEY REFERENCES Shoes(ShoeId))

CREATE TABLE Transactions
	(TransactionId INT PRIMARY KEY,
	WomanId INT FOREIGN KEY REFERENCES Women(WomanId),
	ShoeId INT FOREIGN KEY REFERENCES Shoes(ShoeId),
	NoShoesBought INT,
	SpentAmount INT)

-- 2) a stored procedure that receives a shoes, a presentation shop and the number of shoes and 
-- adds the shoe to the presentation shop
GO 
CREATE OR ALTER PROCEDURE uspAddShoeToShop (@shoeId INT, @shopId INT, @noShoes INT)
AS
	INSERT INTO ShoeStocks VALUES (@noShoes, @shopId, @noShoes)
GO

EXEC uspAddShoeToShop 1, 1, 100;

-- 3) a view that shows the women that bought at least 2 shoes from a given shoe model
GO
CREATE OR ALTER VIEW viewWomenWithAtLeast2Shoes
AS
	SELECT W.WomanId, W.WomanName
	FROM Women W
	WHERE W.WomanId IN 
		(SELECT T.WomanId
		FROM Transactions T 
		INNER JOIN Shoes S ON S.ShoeId = T.ShoeId
		WHERE S.ShoeModelId = 2
		GROUP BY T.WomanId
		HAVING SUM(T.NoShoesBought) >= 2)
GO

SELECT * FROM viewWomenWithAtLeast2Shoes;

-- 4) a function that lists the shoes that can be found in at least T presentation shops, 
-- where T >= 1 is a function parameter
GO
CREATE OR ALTER FUNCTION ufListShoesInAtLestTShops (@T INT)
RETURNS TABLE
AS
	RETURN SELECT S.ShoeId, S.Price
			FROM Shoes S
			WHERE S.ShoeId IN
				(SELECT SS.ShoesId
				FROM ShoeStocks SS 
				GROUP BY SS.ShoesId
				HAVING COUNT(*) >= @T)

GO

SELECT * FROM ufListShoesInAtLestTShops(2);