--SQLQuery1-sp INSERT Schedule.sql
USE PV_521_Import;
GO	--Применить

CREATE OR ALTER PROCEDURE sp_InsertScheduleStacionar
	@group_name			AS	NCHAR(10),
	@discipline_name	AS	NVARCHAR(150),
	@teacher_first_name	AS	NVARCHAR(50),
	@start_date			AS	DATE	=	N'1900-01-01'
AS
BEGIN
	DECLARE	@group				AS	INT		= (SELECT group_id			FROM Groups			WHERE group_name LIKE @group_name);
	DECLARE @teacher			AS	SMALLINT= (SELECT teacher_id		FROM Teachers		WHERE first_name LIKE @teacher_first_name);
	DECLARE @discipline			AS	SMALLINT= (SELECT discipline_id		FROM Disciplines	WHERE discipline_name LIKE @discipline_name);
	DECLARE @number_of_lessons	AS	TINYINT	= (SELECT number_of_lessons FROM Disciplines	WHERE discipline_name LIKE @discipline_name);
	--DECLARE @lesson_number		AS	TINYINT = 0;
	--DECLARE @date				AS	DATE	= @start_date;
	DECLARE @start_time			AS	TIME	= (SELECT start_time FROM Groups WHERE group_id=@group);

	
	PRINT(@group);
	PRINT(@discipline);
	PRINT(@number_of_lessons);
	PRINT(@teacher);
	PRINT(@start_date);
	PRINT(@start_time);
	PRINT('==========================================================')
	
	--В цикле перебираем занятия по номеру, опрделяем дату и время каждого занятия
	DECLARE @date			AS	DATE	= 
	IIF(@start_date<>N'1900-01-01', @start_date,(SELECT MAX([date]) FROM Schedule WHERE [group]=@group));
	DECLARE @lesson_number	AS	TINYINT	= dbo.CountLessons(@group,@discipline);
	DECLARE @time			AS	TIME	=	@start_time;
	WHILE	(@lesson_number < @number_of_lessons)
	BEGIN
			SET @date = dbo.GetNextLearningDate(@group_name, @date);
			SET @time=@start_time;
			PRINT(FORMATMESSAGE(N'%i   %s   %s   %s',@lesson_number,CAST(@date AS VARCHAR(24)),DATENAME(WEEKDAY,@date),CAST(@time AS VARCHAR(24))));
		--IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date]=@date AND [time]=@time AND [group]=@group)
		--	INSERT	Schedule VALUES	(@group,@discipline,@teacher,@date,@time,IIF(@date<GETDATE(),1,0));
		--SET @lesson_number = @lesson_number + 1;
		--SET @time = DATEADD(MINUTE, 95, @start_time);
			
--			IF EXISTS (SELECT holiday FROM DaysOFF WHERE [date]=@date)CONTINUE;

			EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lesson_number OUTPUT;
	
			--PRINT(FORMATMESSAGE(N'%i   %s   %s   %s',@lesson_number,CAST(@date AS VARCHAR(24)),DATENAME(WEEKDAY,@date),CAST(@time AS VARCHAR(24))));
		--IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date]=@date AND [time]=@time AND [group]=@group)
		--	INSERT	Schedule VALUES	(@group,@discipline,@teacher,@date,@time,IIF(@date<GETDATE(),1,0));
		--SET @lesson_number = @lesson_number + 1;
			EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lesson_number OUTPUT;
	
--			DECLARE @day	AS	TINYINT	= DATEPART(WEEKDAY, @date);	--Как раз для этого выше написано 'SET DATEFIRST 1;'
--			PRINT(@day);
--			SET @date	=	DATEADD(DAY,IIF(@day=5,3,2),@date);
--			SET @date	=	dbo.GetNextLearningDate(@group_name, @date);
	END

--PRINT(@time);

END