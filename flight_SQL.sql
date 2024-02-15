
USE [2-Flights]
GO

ALTER TABLE [dbo].[Airports]
ALTER COLUMN [Airport ID] NVARCHAR(50) NOT NULL;
ALTER TABLE [dbo].[Planes]
ALTER COLUMN [Plane ID] NVARCHAR(50) NOT NULL;
ALTER TABLE [dbo].[Flights]
ALTER COLUMN [Flight ID] NVARCHAR(50) NOT NULL;
ALTER TABLE [dbo].[Flights]
ALTER COLUMN [Arrival Airport ID] NVARCHAR(50) NOT NULL;
ALTER TABLE [dbo].[Flights]
ALTER COLUMN [Departure Airport ID] NVARCHAR(50) NOT NULL;
ALTER TABLE [dbo].[Flights]
ALTER COLUMN [Plane ID] NVARCHAR(50) NOT NULL;


--Adding primary key(PK) and Foreign key(FK)
--PK
ALTER TABLE[dbo].[Airports]
ADD PRIMARY KEY ([Airport ID]);
ALTER TABLE [dbo].[Flights]
ADD PRIMARY KEY ([Flight ID]);
ALTER TABLE [dbo].[Planes]
ADD PRIMARY KEY ([Plane ID]);--FKALTER TABLE [dbo].[Flights]
ADD FOREIGN KEY ([Departure Airport ID])
REFERENCES [dbo].[Airport]([Airport ID]);
ALTER TABLE [dbo].[Flight]
ADD FOREIGN KEY ([Arrival Airport ID])
REFERENCES [dbo].[Airports]([Airport ID]);
ALTER TABLE [dbo].[Flights]
ADD FOREIGN KEY ([Plane ID])
REFERENCES [dbo].[Planes]([Plane ID]);
--Flights – Master Table 
SELECT A.[Flight ID]
,A.[Airline]
,A.[Departure Airport ID]
,A.[Arrival Airport ID]
,A.[Plane ID]
,A.[Flight Delay Flag]
,A.[Flight Delay Time (mins)]
,B.[Airport Country] AS [Departure Airport Country]
,B.[Opening Year] AS [Departure Airport Opening Year]
,B.[Customer Satisfaction Rating] AS [Departure Airport Customer Satisfaction Rating]
,C.[Airport Country] AS [Arrival Airport Country]
,C.[Opening Year] AS [Arrival Airport Opening Year]
,C.[Customer Satisfaction Rating] AS [Arrival Airport Customer Satisfaction Rating]
,D.[Suppliers Name]
,D.[Passenger Capacity]
,D.[Commission Year]
,D.[Life Time]
INTO [Flights - Master]
FROM [dbo].[Flights] AS A
LEFT JOIN [dbo].[Airports] AS B
ON A.[Departure Airport ID] = B.[Airport ID]
LEFT JOIN [dbo].[Airports] AS C
ON A.[Arrival Airport ID] = C.[Airport ID]
LEFT JOIN [dbo].[Planes] AS D
ON A.[Plane ID] = D.[Plane ID]

/*
We will look at the following aspects in the data:
• The metrics surrounding the departure and arrival airports
• The customer satisfaction scores and relating it to airport activity
• The planes which are used for the flights
*/

/*This tells us how often a flight route occurred in the lists of
flights present in the data*/

SELECT [Departure Airport ID]
,[Departure Airport Country]
,[Arrival Airport ID]
,[Arrival Airport Country]
,COUNT(*) AS [Airport Frequency]
FROM [dbo].[Flights - Master]
GROUP BY [Departure Airport ID]
,[Departure Airport Country]
,[Arrival Airport ID]
,[Arrival Airport Country]

/*The airport customer satisfaction rating can be analysed to see how it
relates to the number of flights in their respective airports*/

-- Departure Airport CustomerSatisfaction Analysis

SELECT [Departure Airport ID]
,[Departure Airport Country]
,COUNT(*) AS [Departure Airport Frequency]
,[Departure Airport Customer Satisfaction Rating]
FROM [dbo].[Flights - Master]
GROUP BY [Departure Airport ID]
,[Departure Airport Country]
,[Departure Airport Customer Satisfaction Rating]
ORDER BY COUNT(*) DESC

--Arrival Airport Customer Satisfaction Analysis
SELECT [Arrival Airport ID]
,[Arrival Airport Country]
,COUNT(*) AS [Arrival Airport Frequency]
,[Arrival Airport Customer Satisfaction Rating]
FROM [dbo].[Flights - Master]
GROUP BY [Arrival Airport ID]
,[Arrival Airport Country]
,[Arrival Airport Customer Satisfaction Rating]
ORDER BY COUNT(*) DESC

--The planes which are used for the flights

SELECT [Plane ID]
,[Plane Name]
,[Suppliers Name]
,[Commission Year]
,[Passenger Capacity]
,COUNT(*) AS [Flight Count]
FROM [dbo].[Flights - Master]
GROUP BY [Plane ID]
,[Plane Name]
,[Suppliers Name]
,[Commission Year]
,[Passenger Capacity]
ORDER BY [Flight Count] DESC