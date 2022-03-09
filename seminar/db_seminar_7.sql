-- seminar 7
-- indexed views.

-- saving computation cost for selecting views -> materialise, by creating indexes.
-- 1. ANSI_NULLS
-- =, <>

SET ANSI_NULLS ON

DROP TABLE IF EXISTS t1

CREATE TABLE t1 (a INT NULL)

INSERT t1 VALUES (NULL), (1), (2)

SELECT * FROM t1

SELECT a
FROM t1
WHERE a = NULL -- if ANSI_NULLS is on, no columns because all comparisons againsts NULL are unknown.

SELECT a
FROM t1
WHERE a <> NULL -- if ANSI_NULLS is ON, same result, no rows; OFF - shows 1, 2.

SELECt 32 & @@OPTIONS -- ANSI_NULLS -> 0 - OFF, 32 - ON.

-- 2. ANSI_PADDING

SET ANSI_PADDING ON -- padding for char/varchar (spaces at the end, between the string etc.).

DROP TABLE IF EXISTS t1

CREATE TABLE t1
	(a CHAR(3) NULL,
	b VARCHAR(3) NULL)

INSERT t1 VALUES 
('1', '1'),
('1 ', '1  ')

SELECT '>' + a + '<', '>' + b + '<'
FROM t1

-- ANSI_PADDING ON
-- >1  <    >1<
-- >1  <    >1 <

-- ANSI_PADDING OFF
-- >1<    >1<
-- >1<    >1<

-- 3. ANSI_WARNINGS

SET ANSI_WARNINGS ON
DROP TABLE IF EXISTS t1

CREATE TABLE t1
	(a INT, b INT NULL,
	c VARCHAR(30))

INSERT t1 VALUES
(2, NULL, ''),
(2, 0, ''),
(3, 1, ''),
(3, 2, '')


SELECT a, SUM(b)
FROM t1
GROUP BY a  -- ANSI_WARNINGS ON, Warning: Null values is eliminated by an aggregate...

INSERT t1 VALUES
(4, 4, '    fsdfsfsd fs dfsdfsdfs sdfsdfsfsf  sfsdfsdf') -- ANSI_WARNINGS ON, length of the inserted string > than tha one declared, it will not be inserted; OFF - inserted, but truncated to the size of the column