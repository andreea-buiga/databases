-- functions, view, system catalog, triggers, MERGE in SQL Server

-- user-defined functions in sql server
-- - 2 types:
--     • scalar
--     • inline table-valued
--     • multistatement table-valued

-- • scalar functions
-- CREATE FUNCTION [OR ALTER] udfName (@paramName paramType, , )  -- if there are no parameters ()
-- RETURNS returnType [AS]
-- BEGIN
--    -- sql statements
--    RETURN scalarExpression
-- END

-- schemaName.functionName -> dbo.functionName

CREATE FUNCTION udfCountPiratesByReputation(@rep INT)
RETURNS INT
BEGIN
	DECLARE @numberOfPirates INT
	SELECT @numberOfPirates = COUNT(*) FROM Pirates WHERE Reputation >= @rep
	RETURN @numberOfPirates
END

PRINT dbo.udfCountPiratesByReputation(3)

-- • inline table-valued
-- CREATE FUNCTION [OR ALTER] udfName (@paramName paramType, , )
-- RETURNS TABLE [AS]
--    -- sql statements
--    RETURN select statement that returns the table

CREATE FUNCTION udfPiratesInYearRange(@startingYear SMALLINT, @endingYear SMALLINT)
RETURNS TABLE
	RETURN SELECT * 
		FROM Pirates 
		WHERE YEAR(DOB) BETWEEN @startingYear AND @endingYear

SELECT * FROM dbo.udfPiratesInYearRange(1601, 1607)

-- • multistatement table-valued
-- CREATE FUNCTION [OR ALTER] udfName (@paramName paramType, , )
-- RETURNS @tableName TABLE(@columnName columnType, , )
-- BEGIN
--    -- sql statements
--    RETURN scalarExpression
-- END

CREATE FUNCTION udfMSTVPiratesInYearRange(@startingYear SMALLINT, @endingYear SMALLINT)
RETURNS @PiratesInYR TABLE(PID INT, PFName VARCHAR(100), PLName VARCHAR(100))
BEGIN
	INSERT INTO @PiratesInYR
	SELECT PID, PFName, PLName 
	FROM Pirates
	WHERE YEAR(DOB) BETWEEN @startingYear AND @endingYear

	IF @@ROWCOUNT = 0
		INSERT INTO @PiratesInYR
		VALUES(0, 'no pirates found in the specified in year range.', NULL)

	RETURN 
END

SELECT * FROM dbo.udfMSTVPiratesInYearRange(1601, 1607)

-- views
-- CREATE VIEW viewName
-- AS
--		SELECT statement

-- entry
-- logical data independence - they are completely protected in the way the data is structured

-- CREATE VIEW V1
-- AS
--		SELECT c1, c2, c3
--		FROM T1 INJ T2
--		WHERE ...

-- SELECT *
-- FROM V1
-- WHERE ...

-- T1  - T11     T11 + columns
--     - T12     T12 + ...

-- -----|-----|------|----- 
--     t0     t1     t2

CREATE VIEW vPiratesShares
AS
	SELECT *  -- columns in each view must be unique
	FROM Pirates p
	INNER JOIN Shares S ON S.PID = P.PID

CREATE VIEW vPiratesShares
AS
	SELECT P.*, S.PID as PirateId, S.TID, S.Value
	FROM Pirates p
	INNER JOIN Shares S ON S.PID = P.PID

SELECT * FROM vPiratesShares

-- system catalog
SELECT m.definition, o.name, o.type, o.type_desc
FROM sys.sql_modules m
INNER JOIN sys.objects o ON o.object_id = m.object_id
WHERE o.type IN ('FN', 'IF', 'TF',  'V', 'P', 'TR')
ORDER BY o.create_date DESC

SELECT o.name, c.name, c.column_id
FROM sys.objects o
INNER JOIN sys.columns c ON c.object_id = c.object_id
WHERE type = 'U'
ORDER BY o.object_id, c.column_id

-- triggers
-- automatically executed DML statement (insert, updates, deletes) or DDL statement is executed
-- logn (?) trigger

-- CREATE TRIGGER trName
--		ON tableName
--		{FOR | AFTER | INSTEAD OF}
--      {[INSERT] [,] [UPDATE] [,] [DELETE]}
		-- • FOR/AFTER INSERT - whenever an insert is executed on a table, after it completes execution the trigger is fired
		-- • INSTEAD OF INSERT - whenever an insert is attempted on a table, the trigger is fired and all the statements in it will be executed
-- AS
--		-- sql statements

-- Products[PId, PName, Quantity]
-- 1, Chocolate, 100 - insert -> BuyLog
-- 2, Soda, 200      - delete -> sellLog
-- 2, Bread, 50
-- BuyLog[PName, OpDate, Quantity]
-- SellLog[PName, OpDate, Quantity]

CREATE TRIGGER t1WhenBuyingAProd 
	ON Products
	FOR INSERT
AS
	INSERT BuyLog(PName, OpDate, Quantity)    -- SellLog
	SELECT PName, GETDATE(), Quantity
	FROM inserted                             -- deleted

-- FOR UPDATE                              deleted       inserted
-- p1   100  |  60  ->  sold 40            p1   100      p1   60
-- p2   100  |  60  ->  sold 40            p2   100      p2   60
-- p3    0   |  60  ->  bought 60          p3    0       p3   60

-- MERGE
-- BookInventory
-- BookId    Title                Copies
-- 1         Un sofer de elita    5
-- 2         The Hobbit           4
-- 3         Databases            1

-- BookOrders
-- BookId    Title                Copies
-- 1         Un sofer de elita    6
-- 2         The Hobbit           2
-- 3         DBMSS                1

MERGE BookInventory bi
USING BookOrders bo
ON bi.BookId = bo.BookId
WHEN MATCHED THEN
	UPDATE
		SET bi.Copies = bi.Copies + bo.Copies
WHEN NOT MATCHED BY TARGET THEN
	INSERT VALUES(bo.BookId, bo.Title, bo.Copies); -- ; mandatory for MERGE
