USE ArtGalleryDB
GO


-- a. 2 queries with the union operation; use UNION [ALL] and OR.

-- display all the information about the artworks that were finished after 1800 or do not have the price in the purchase history.
-- • UNION
SELECT A.ArtworkId
FROM Artwork A
WHERE A.YearFinished >= 1800
UNION
SELECT APH.ArtworkId
FROM ArtworkPurchaseHistory APH
WHERE APH.Price IS NULL

-- display the exhibitions who had as partners 'Alverde' or 'Samsung'.
-- • OR
SELECT DISTINCT E.ExhibitionName, E.ExhibitionDescription
FROM Exhibition E, Partnership P, PartnerCompany PC
WHERE P.ExhibitionId = E.ExhibitionId AND PC.PartnerCompanyId = P.PartnerCompanyId AND 
		(PC.PartnerCompanyName = 'Alverde' OR PC.PartnerCompanyName = 'Samsung')
ORDER BY E.ExhibitionName

------------------------------------------------------------------------------------------

-- b. 2 queries with the intersection operation; use INTERSECT and IN.

-- display the id, the name and the price paid of the customers who paid a sum over 500.000 and since the beginning of 2020.
-- • INTERSECT
SELECT C.CustomerId, C.FirstName, C.LastName, APH.Price
FROM Customer C, ArtworkPurchaseHistory APH
WHERE APH.CustomerId = C.CustomerId AND APH.Price >= 600000
INTERSECT
SELECT C.CustomerId, C.FirstName, C.LastName, APH.Price
FROM Customer C, ArtworkPurchaseHistory APH
WHERE APH.CustomerId = C.CustomerId AND APH.DateOfPurchase >= '2020-01-01'

-- display the name of the gallery staff, their salary increased by 25%, who worked on exhibitions and who have a salary of 2100, 2400 or 2700, ordered by last name.
-- • IN
SELECT DISTINCT GS.FirstName, GS.LastName, Gs.Salary + GS.Salary * 0.25 AS 'SalaryIncreased'
FROM GalleryStaff GS
INNER JOIN StaffExhibition SE ON SE.GalleryStaffId = GS.GalleryStaffId
WHERE GS.Salary IN (2100, 2400, 2700)
ORDER BY GS.LastName

------------------------------------------------------------------------------------------

-- c. 2 queries with the difference operation; use EXCEPT and NOT IN.

-- display the ids of the artworks that were finished after 1900, but weren't rented for an exhibition.
-- • EXCEPT
SELECT ArtworkId 
FROM Artwork
WHERE YearFinished >= 1900
EXCEPT
SELECT ArtworkId
FROM ArtworkRentalExhibition

-- display the artists who had artworks that were rented, but don't belong in the art movements Pop-Art or Impressionism.
-- • NOT IN
SELECT DISTINCT A.FirstName, A.LastName, AM.ArtMovementName
FROM Artist A
INNER JOIN ArtMovement AM ON AM.ArtMovementId = A.ArtMovementId
INNER JOIN Artwork Art ON Art.ArtistId = A.ArtistId
INNER JOIN ArtworkRentalExhibition ARE ON ARE.ArtworkId = Art.ArtworkId
WHERE AM.ArtMovementName NOT IN ('Pop-Art', 'Impressionism')

------------------------------------------------------------------------------------------

-- d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN (one query per operator).
--    one query will join at least 3 tables, while another one will join at least two many-to-many relationships.

-- display the expositions id along with the number of emplyees that workes on it and have been employed for over 10 years.
-- • INNER JOIN
SELECT E.ExhibitionId, COUNT(GS.GalleryStaffId) as 'NoEmployees'
FROM Exhibition E
INNER JOIN StaffExhibition SE ON E.ExhibitionId = SE.ExhibitionId
INNER JOIN GalleryStaff GS ON GS.GalleryStaffId = SE.GalleryStaffId
WHERE FLOOR(DATEDIFF(DAY, GS.DateEmployed, GETDATE())/365) > 10
GROUP BY E.ExhibitionId
ORDER BY E.ExhibitionId

-- display the top 10 name of the artists and the artworks that were not sold to any customer.
-- • LEFT JOIN
SELECT TOP 10 A.FirstName, A.LastName, ART.Title
FROM Artwork ART
LEFT JOIN ArtworkPurchaseHistory APH on APH.ArtworkId = ART.ArtworkId
INNER JOIN Artist A ON A.ArtistId = ART.ArtistId
WHERE APH.CustomerId IS NULL
ORDER BY A.FirstName

-- determine the customers that made purchases and have an gmail address.
-- • RIGHT JOIN
SELECT DISTINCT C.FirstName, C.LastName
FROM Customer C
RIGHT JOIN ArtworkPurchaseHistory APH ON APH.CustomerId = C.CustomerId
WHERE C.Email LIKE '%@gmail.com'


-- display for the exhibitions in partnership with 'Chess.com' or 'Alverde' and that were held since 2019, the number of artists that contributed for each exhibition.
-- • FULL JOIN
-- • 2 m:n relationships
SELECT E.ExhibitionId, COUNT(DISTINCT A.ArtistId) AS 'NumberOfArtists'
FROM Artist A
FULL JOIN Artwork ART ON ART.ArtistId = A.ArtistId
FULL JOIN ArtworkRentalExhibition ARE ON ARE.ArtworkId = ART.ArtworkId
FULL JOIN Exhibition E ON E.ExhibitionId = ARE.ExhibitionId
FULL JOIN Partnership P ON P.ExhibitionId = E.ExhibitionId
FULL JOIN PartnerCompany PC ON PC.PartnerCompanyId = P.PartnerCompanyId
WHERE E.ExhibitionName IS NOT NULL AND E.ExhibitionId IS NOT NULL AND A.ArtistId IS NOT NULL AND E.StartDate >= '2019-01-01' AND (PC.PartnerCompanyName = 'Chess.com' OR PC.PartnerCompanyName = 'Alverde')
GROUP BY E.ExhibitionId

------------------------------------------------------------------------------------------

-- e. 2 queries with the IN operator and a subquery in the WHERE clause.
--    in at least one case, the subquery should include a subquery in its own WHERE clause.

-- display the title of the artworks that were purchased with the sum over 600000 by the customer with the id 1.
SELECT A.Title
FROM Artwork A
WHERE A.ArtworkId IN
	(SELECT APH.ArtworkId
	FROM ArtworkPurchaseHistory APH
	WHERE APH.Price >= 600000 AND APH.CustomerId = 1)

-- display the exhibitions name that rented artworks that were finished between 1800 and 1920. 
SELECT E.ExhibitionName
FROM Exhibition E
WHERE E.ExhibitionId IN 
	(SELECT ARE.ExhibitionId
	FROM ArtworkRentalExhibition ARE
	WHERE ARE.ArtworkId IN
		(SELECT A.ArtworkId
		FROM Artwork A
		WHERE A.YearFinished >= 1800 AND A.YearFinished <= 1920
		)
	)

------------------------------------------------------------------------------------------

-- f. 2 queries with the EXISTS operator and a subquery in the WHERE clause.

-- display the name and the phone number of the partner companies that were in partnership at exhibitions with id 1 or id 5.
SELECT PC.PartnerCompanyName, PC.PhoneNumber
FROM PartnerCompany PC
WHERE EXISTS 
	(SELECT *
	FROM Partnership P
	WHERE P.PartnerCompanyId = PC.PartnerCompanyId AND (P.ExhibitionId = 1 OR P.ExhibitionId = 5))

-- display the name of the artists that have an art movement, but do not have any artworks in the database.
SELECT A.FirstName, A.LastName
FROM Artist A
WHERE EXISTS 
	(SELECT *
	FROM ArtMovement AM
	WHERE A.ArtMovementId = AM.ArtMovementId) 
AND NOT EXISTS
	(SELECT *
	FROM Artwork ART
	WHERE A.ArtistId = ART.ArtistId)

------------------------------------------------------------------------------------------

-- g. 2 queries with a subquery in the FROM clause.

-- display the name of the artists that finished artworks before 1600 and do not have the title left empty.
SELECT DISTINCT A.FirstName, A.LastName
FROM Artist A INNER JOIN
	(SELECT *
	FROM Artwork
	WHERE YearFinished <= 1600 AND Title IS NOT NULL) ART
ON A.ArtistId = ART.ArtistId

-- display the customers that bought artworks that have the title empty, along with the price that has to be between 800.000 and 2.000.000.
SELECT C.FirstName, C.LastName, APH.Price
FROM (Artwork A INNER JOIN
		(SELECT *
		FROM ArtworkPurchaseHistory
		WHERE Price BETWEEN 800000 AND 2000000) APH
		ON A.ArtworkId = APH.ArtworkId
	)
	LEFT JOIN
		(SELECT *
		FROM Customer) C
		ON C.CustomerId = APH.CustomerId 
WHERE Title IS NULL

------------------------------------------------------------------------------------------

-- h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause.
--    2 of the latter will also have a subquery in the HAVING clause; use the aggregation operators: COUNT, SUM, AVG, MIN, MAX.

-- display for each customer the total prices paid for artworks, even if the price exist or not.
SELECT C.CustomerId, SUM(APH.Price) AS 'SumPrice'
FROM Customer C
LEFT JOIN ArtworkPurchaseHistory APH ON C.CustomerId = APH.CustomerId
GROUP BY C.CustomerId

-- determine the artists that made artworks and sold at least 2 artworks, display their id, the number of artworks sold and the average of the price artwork.
SELECT A.ArtistId, COUNT(APH.ArtworkId) AS 'NoArtworkSold', AVG(APH.Price) AS 'PriceAverage'
FROM Artist A
INNER JOIN Artwork Art ON A.ArtistId = Art.ArtistId
INNER JOIN ArtworkPurchaseHistory APH ON Art.ArtworkId = APH.ArtworkId
GROUP BY A.ArtistId
HAVING COUNT(*) >= 2
ORDER BY COUNT(*)

-- find the exhibitions id with the biggest number of rented artworks.
SELECT E.ExhibitionId
FROM Exhibition E
INNER JOIN ArtworkRentalExhibition ARE ON ARE.ExhibitionId = E.ExhibitionId
INNER JOIN Artwork A ON A.ArtworkId = ARE.ArtworkId
GROUP BY E.ExhibitionId
HAVING COUNT(*) = 
	(SELECT MAX(R.Maxim) AS MaxArtworks 
	FROM
		(SELECT COUNT(*) AS Maxim
		FROM Exhibition E
		INNER JOIN ArtworkRentalExhibition ARE ON ARE.ExhibitionId = E.ExhibitionId
		INNER JOIN Artwork A ON A.ArtworkId = ARE.ArtworkId
		GROUP BY E.ExhibitionId) R
	) 

-- find the artists id who finished the least artworks between 1800 and 2000.
SELECT A.ArtistId
FROM Artist A
INNER JOIN Artwork ART ON ART.ArtistId = A.ArtistId
WHERE ART.YearFinished BETWEEN 1800 AND 2000
GROUP BY A.ArtistId
HAVING COUNT(*) =
	(SELECT MIN(AR.Minim) AS MinArtworks
	FROM
		(SELECT A.ArtistId, COUNT(*) AS Minim
		FROM Artist A
		INNER JOIN Artwork ART ON ART.ArtistId = A.ArtistId
		WHERE ART.YearFinished BETWEEN 1800 AND 2000
		GROUP BY A.ArtistId) AR
	)

-- determine the gallery staff that worked on the most exhibitions.
SELECT GS.GalleryStaffId
FROM Exhibition E
INNER JOIN StaffExhibition SE ON E.ExhibitionId = SE.ExhibitionId
INNER JOIN GalleryStaff GS ON GS.GalleryStaffId = SE.GalleryStaffId
GROUP BY GS.GalleryStaffId
HAVING COUNT(E.ExhibitionId) >= ALL
	(SELECT COUNT(E.ExhibitionId)
	FROM Exhibition E
	INNER JOIN StaffExhibition SE ON E.ExhibitionId = SE.ExhibitionId
	INNER JOIN GalleryStaff GS ON GS.GalleryStaffId = SE.GalleryStaffId
	GROUP BY GS.GalleryStaffId
	)

------------------------------------------------------------------------------------------

-- i. 4 queries using ANY and ALL to introduce a subquery in the WHERE clause (2 queries per operator)
--    rewrite 2 of them with aggregation operators, and the other 2 with IN / [NOT] IN.

-- display top 10 the artworks that were finished in a year greater than any of the artworks painted by Vincent van Gogh or Claude Monet (idV = 1, idM = 9) ordered by the year finished.
-- • ANY
SELECT TOP 10 A.YearFinished, A.Title
FROM Artwork A
WHERE A.YearFinished > ANY
	(SELECT A2.YearFinished
	FROM Artwork A2
	WHERE A2.ArtistId = 1 OR A2.ArtistId = 9
	)
ORDER BY A.YearFinished
-- REWRITTEN
SELECT TOP 10 A.YearFinished, A.Title
FROM Artwork A
WHERE A.YearFinished > 
	(SELECT MIN(A2.YearFinished)
	FROM Artwork A2
	WHERE A2.ArtistId = 1 OR A2.ArtistId = 9
	)
ORDER BY A.YearFinished

-- display the artwork purchases that had the price smaller than any of the artwork purchases in the summer of 2021, sorted descendingly by the price.
-- • ANY
SELECT APH.Price, APH.ArtworkId, APH.CustomerId, APH.DateOfPurchase
FROM ArtworkPurchaseHistory APH
WHERE APH.Price < ANY
	(SELECT APH2.Price
	FROM ArtworkPurchaseHistory APH2
	WHERE APH2.DateOfPurchase BETWEEN '2021-06-01' AND '2021-08-31'
	)
ORDER BY APH.Price DESC
-- REWRITTEN
SELECT APH.Price, APH.ArtworkId, APH.CustomerId, APH.DateOfPurchase
FROM ArtworkPurchaseHistory APH
WHERE APH.Price < 
	(SELECT MAX(APH2.Price)
	FROM ArtworkPurchaseHistory APH2
	WHERE APH2.DateOfPurchase BETWEEN '2021-06-01' AND '2021-08-31'
	)
ORDER BY APH.Price DESC

-- display the gallery staff (top 5) who has the salary different from those who do not have experience as a gallery staff employer for 1 year.
-- • ALL
SELECT TOP 5 GS.GalleryStaffId, GS.FirstName, GS.LastName, GS.Salary, GS.DateEmployed
FROM GalleryStaff GS
WHERE GS.Salary <> ALL
	(SELECT GS2.Salary
	FROM GalleryStaff GS2
	WHERE FLOOR(DATEDIFF(DAY, GS2.DateEmployed, GETDATE())/365) <= 1
	)
-- REWRITTEN
SELECT TOP 5 GS.GalleryStaffId, GS.FirstName, GS.LastName, GS.Salary, GS.DateEmployed
FROM GalleryStaff GS
WHERE GS.Salary NOT IN
	(SELECT GS2.Salary
	FROM GalleryStaff GS2
	WHERE FLOOR(DATEDIFF(DAY, GS2.DateEmployed, GETDATE())/365) <= 1
	)

-- display the artworks that were done in a diffent artwork medium than the artworks painted by Leonardo da Vinci or Yayoi Kusama (idV= 2, idD = 3).
-- • ALL
SELECT A.ArtworkId, A.Title
FROM Artwork A
WHERE A.ArtworkMediumId <> ALL
	(SELECT A2.ArtworkMediumId
	FROM Artwork A2
	WHERE A2.ArtistId = 2 OR A2.ArtistId = 3
	)
-- REWRITTEN
SELECT A.ArtworkId, A.Title
FROM Artwork A
WHERE A.ArtworkMediumId NOT IN
	(SELECT A2.ArtworkMediumId
	FROM Artwork A2
	WHERE A2.ArtistId = 2 OR A2.ArtistId = 3
	)
