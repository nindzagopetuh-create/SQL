--SQLQuery7-sp_InsertHolidaysFor.sql
USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER PROCEDURE sp_InsertHolidaysFor
	@year		AS	SMALLINT,
	@holiday	AS	NVARCHAR(150)
AS
BEGIN
	DECLARE @holiday_id	AS	TINYINT	=	(SELECT holiday_id	FROM Holidays	WHERE holiday_name LIKE @holiday);
	DECLARE @duration	AS	TINYINT	=	(SELECT duration	FROM Holidays	WHERE holiday_id=@holiday_id);
	DECLARE @month		AS	TINYINT	=	(SELECT month		FROM Holidays	WHERE holiday_id=@holiday_id);
	DECLARE @day		AS	TINYINT	=	(SELECT day			FROM Holidays	WHERE holiday_id=@holiday_id);
	DECLARE @start_date	AS	DATE = 
	CASE @holiday		--SWITCH
		WHEN N'Нов%'			THEN	dbo.GetNewYearHolidaysStartDate(@year)	--CASE '1'
		WHEN N'Пасха'			THEN	dbo.GetEasterDate(@year)				--CASE '2'
		--	.............................................................................
		WHEN N'Летние каникулы'	THEN	dbo.GetSummertimeSadness(@year)			--CASE 'N'
		ELSE DATEFROMPARTS(@year, @month, @day)									--DEFAULT
	END
	--IF @month IS NOT NULL AND @day IS NOT NULL	SET @start_date = DATEFROMPARTS(@year, @month, @day);
	--IF @holiday LIKE N'Нов%'					SET @start_date = dbo.GetNewYearHolidaysStartDate(@year);
	--IF @holiday LIKE N'Пасха'					SET @start_date = dbo.GetEasterDate(@year);
	--IF @holiday LIKE N'Летние каникулы'					SET @start_date = dbo.GetSummertimeSadness(@year);

	DECLARE @date		AS	DATE	=	@start_date;
	DECLARE @day_num	AS	TINYINT	=	0;
	WHILE @day_num < @duration
	BEGIN
		INSERT	DaysOFF	VALUES	(@date, @holiday_id)
		SET @day_num = @day_num+1;
		SET @date = DATEADD(DAY, 1, @date);
	END
END