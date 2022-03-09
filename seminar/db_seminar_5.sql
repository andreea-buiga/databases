-- indexes in SQL Server (I)

-- index 
-- - structure - stored on the disk
--             - table/view
-- optimise retrived operations 
-- CREATE [UNIQUE][CLUSTERED | NON CLUSTERED] 
--		INDEX index_name
-- ON <object> (column [ , ... n])
-- [INCLUDE (column [ , ... n])]
-- [WHERE <filter_predicate>]

-- clustered/nonclustered

-- 1
SELECT *
FROM SantasList
WHERE RequestDate = '1-1-2018'
-- CTRL + L

CREATE CLUSTERED INDEX index__cl_rd
	ON SantasList(RequestDate)	

SELECT *
FROM SantasList
WHERE RequestDate = '1-1-2018'

-- 2
sp_helpindex Children

SELECT Age, ChildId
FROM Children
WHERE Age = 40

SELECT Age, ChildId
FROM Children
WHERE ChildId = 40

CREATE INDEX idx_ncl_age 
	ON Children(Age)

-- 3
sp_helpindex Children

SELECT *
FROM Children
WHERE Age = 40

SELECT *
FROM Childrem 
WITH(INDEX(idx_ncl_age))
WHERE AGE = 40

-- unique/nonunique
-- 4
SELECT *
FROM Children
WHERE LName = 'Ionescu'

CREATE UNIQUE INDEX idx_ncl_uq_ln
	ON Children(LName)

-- 5
sp_helpindex SantasList

SELECT ChildId, PresentId
FROM SantasList
WHERE ChildId = 3000

SELECT ChildId, PresentId
FROM SantasList
WHERE PresentId = 3000

-- SK
sp_help_index Children

SELECT FName, LName
FROM Children
WHERE Age = 40

CREATE INDEX idx_ncl_age_i_fn_ln
	ON Children(Age)
	INCLUDE (FName, LName)
