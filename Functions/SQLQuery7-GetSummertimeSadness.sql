--SQLQuery7-GetSummertimeSadness.sql
USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION GetSummertimeSadness(@year		AS	SMALLINT)RETURNS DATE
AS
BEGIN
	DECLARE @date		AS	DATE	=	DATEFROMPARTS(@year, 08, 01);
	DECLARE @weekday	AS	TINYINT	=	DATEPART(WEEKDAY, @date);
	DECLARE @start_date	AS	DATE	=	DATEADD(DAY, 1-@weekday, @date);
	RETURN	@start_date;
END