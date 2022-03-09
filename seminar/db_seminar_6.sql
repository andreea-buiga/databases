CREATE DATABASE SEMINAR6

USE SEMINAR6
GO

-- 1
CREATE TABLE TrainTypes
	(TrainTypeId INT PRIMARY KEY,
	TTName VARCHAR(50),
	TTDescription VARCHAR(300))

CREATE TABLE Trains
	(TrainId INT PRIMARY KEY,
	TName VARCHAR(50),
	TrainTypeId INT REFERENCES TrainTypes(TrainTypeId))

CREATE TABLE Routes
	(RouteId INT PRIMARY KEY,
	RName VARCHAR(50) UNIQUE,
	TrainId INT REFERENCES Trains(TrainId))

CREATE TABLE Stations
	(StationId INT PRIMARY KEY,
	SName VARCHAR(50) UNIQUE)

CREATE TABLE StationsRoutes
	(RouteId INT REFERENCES Routes(RouteId),
	StationId INT REFERENCES Stations(StationId),
	Arrival TIME,
	Departure TIME,
	PRIMARY KEY(RouteId, StationId))

-- 2 
GO
CREATE OR ALTER PROCEDURE uspUpdateRoute (@RName VARCHAR(50), @SName VARCHAR(50), @Arrival TIME, @Departure TIME)
AS
	BEGIN
		DECLARE @RID INT, @SID INT
		IF NOT EXISTS (SELECT * FROM Routes WHERE RName = @RName)
			BEGIN
				RAISERROR('invalid route.', 16, 1)
				RETURN
			END
		IF NOT EXISTS (SELECT * FROM Stations WHERE SName = @SName)
			BEGIN
				RAISERROR('invalid station.', 16, 1)
				RETURN
			END
		
		SELECT @RID = (SELECT RouteId FROM Routes WHERE RName = @RName)
		SELECT @SID = (SELECT StationId FROM Stations WHERE SName = @SName)

		IF EXISTS (SELECT * FROM StationsRoutes WHERE StationId = @SId AND RouteId = @RId)
			BEGIN
				UPDATE StationsRoutes
				SET Arrival = @Arrival, Departure = @Departure 
				WHERE StationId = @SID AND RouteId = @RID
			END
		ELSE
			BEGIN
				INSERT StationsRoutes VALUES (@RId, @SId, @Arrival, @Departure)
			END
	END
GO

INSERT TrainTypes VALUES (1, 'type1', 'descr')
INSERT Trains VALUES (1, 't1', 1), (2, 't2', 1), (3, 't3', 1)
INSERT Routes VALUES (1, 'r1', 1), (2, 'r2', 2), (3, 'r3', 3)
INSERT Stations VALUES (1, 's1'), (2, 's2'), (3, 's3')

SELECT * FROM TrainTypes
SELECT * FROM Trains
SELECT * FROM Routes
SELECT * FROM Stations

EXEC uspUpdateRoute @RName = 'r1', @SName = 's1', @Arrival = '5:00', @Departure = '5:10'
EXEC uspUpdateRoute @RName = 'r1', @SName = 's2', @Arrival = '5:20', @Departure = '5:30'
EXEC uspUpdateRoute @RName = 'r1', @SName = 's3', @Arrival = '5:40', @Departure = '5:50'

EXEC uspUpdateRoute @RName = 'r2', @SName = 's1', @Arrival = '6:00', @Departure = '6:10'
EXEC uspUpdateRoute @RName = 'r2', @SName = 's2', @Arrival = '6:20', @Departure = '6:30'
EXEC uspUpdateRoute @RName = 'r2', @SName = 's3', @Arrival = '6:40', @Departure = '6:50'

-- invalid station
EXEC uspUpdateRoute @RName = 'r3', @SName = 's5', @Arrival = '6:40', @Departure = '6:10'

-- 3 view

SELECT StationId
FROM Stations
EXCEPT
SELECT StationId
FROM StationsRoutes
WHERE RouteId = 3

GO
CREATE OR ALTER VIEW vRoutesWithAllStations
AS
	SELECT r.RName
	FROM Routes r
	WHERE NOT EXISTS
		(SELECT StationId
		FROM Stations S
		EXCEPT
		SELECT StationId
		FROM StationsRoutes SR
		WHERE SR.RouteId = R.RouteId)
GO


SELECT * FROM vRoutesWithAllStations

SELECT StationId, COUNT(*)
FROM StationsRoutes SR
GROUP BY SR.StationId
HAVING COUNT(*) > 2


-- 4 
GO
CREATE OR ALTER FUNCTION ufFilterStationsByNoRoutes (@R INT)
RETURNS TABLE
RETURN SELECT S.SName
	FROM Stations S
	WHERE S.StationId IN
		(SELECT StationId
		FROM StationsRoutes SR
		GROUP BY SR.StationId 
		HAVING COUNT(*) > @R)
GO

SELECT *
FROM ufFilterStationsByNoRoutes(4)