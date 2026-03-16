--SQLQuery1-GetNextLearningDate.sql
USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION GetNextLearningDate(@group_name AS NCHAR(10), @date AS	DATE = N'1900-01-01')RETURNS DATE
AS
BEGIN
	DECLARE @group_id	AS	INT		=	(SELECT group_id	FROM Groups		WHERE group_name=@group_name);
	IF @date=CAST(N'1900-01-01' AS DATE)
		SET @date	=	(SELECT MAX([date])	FROM Schedule	WHERE [group]=@group_id);
	--DECLARE @date		AS	DATE	=	(SELECT MAX([date])	FROM Schedule	WHERE [group]=@group_id);
	DECLARE @day		AS	SMALLINT	=	DATEPART(WEEKDAY, @date);
	DECLARE @next_day	AS	SMALLINT	=	dbo.GetNextLearningDay(@group_name, @date);
	DECLARE @interval	AS	SMALLINT	=	@next_day-@day;
	--		5-1=-4 => 7-4=3;
	IF @interval<0	SET @interval	=	7+@interval;
	IF @interval=0	SET @interval	=	7;
	DECLARE @next_date	AS	DATE	=	DATEADD(DAY, @interval, @date);
	RETURN	
	IIF(NOT EXISTS (SELECT holiday FROM DaysOFF WHERE [date]=@next_date), @next_date, dbo.GetNextLearningDate(@group_name, @next_date));
	--IF EXISTS (SELECT holiday FROM DaysOFF WHERE [date]=@next_date)SET @next_date = dbo.GetNextLearningDate(@group_name, @next_date);
	--RETURN	@next_date;
END