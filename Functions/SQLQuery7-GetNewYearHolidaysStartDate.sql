--SQLQuery7-GetNewYearHolidaysStartDate.sql
USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION GetNewYearHolidaysStartDate(@year	AS	SMALLINT)RETURNS DATE
AS
BEGIN
	DECLARE @new_years_date	AS	DATE	=	DATEFROMPARTS(@year,01,01);
	DECLARE @weekday		AS	TINYINT	=	DATEPART(WEEKDAY,@new_years_date);
	DECLARE @start_date		AS	DATE	=	DATEADD(DAY,1 - @weekday,@new_years_date);
	IF @weekday=7	SET @start_date = DATEADD(DAY, -1, @new_years_date);
	RETURN	@start_date
END