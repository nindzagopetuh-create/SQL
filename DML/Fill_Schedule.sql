USE PV_521_Import;
USE PV_521_DDL;
IF NOT EXISTS (SELECT * FROM Directions)
BEGIN
    INSERT INTO Directions (direction_id, direction_name)
    VALUES 
        (1, N'Разработка программного обеспечения'),
        (2, N'Сетевые технологии и системное администрирование'),
        (3, N'Компьютерная графика и дизайн');
END

-- Проверка групп
IF NOT EXISTS (SELECT * FROM Groups)
BEGIN
    INSERT INTO Groups (group_id, group_name, direction)
    VALUES 
        (1, N'ПО-101', 1),
        (2, N'СТ-101', 2),
        (3, N'КГ-101', 3);
END

-- Проверка преподавателей
IF NOT EXISTS (SELECT * FROM Teachers)
BEGIN
    INSERT INTO Teachers (teacher_id, last_name, first_name, middle_name, birth_date)
    VALUES 
        (1, N'Иванов', N'Иван', N'Иванович', '1980-01-15'),
        (2, N'Петров', N'Петр', N'Петрович', '1975-03-20'),
        (3, N'Сидорова', N'Анна', N'Сергеевна', '1985-07-10');
END

-- Проверка дисциплин
IF NOT EXISTS (SELECT * FROM Disciplines)
BEGIN
    INSERT INTO Disciplines (discipline_id, discipline_name, number_of_lessons)
    VALUES 
        (1, N'Основы программирования', 72),
        (2, N'Базы данных', 64),
        (3, N'Компьютерные сети', 56),
        (4, N'Веб-дизайн', 48);
END

-- Заполнение расписания 
DECLARE @StartDate DATE = '2024-09-01'; -- Начало обучения
DECLARE @EndDate DATE = GETDATE(); -- Текущая дата
DECLARE @GroupID INT = 1; -- ID группы
DECLARE @LessonID BIGINT = 1;

-- Временная таблица для хранения занятий
DECLARE @Lessons TABLE (
    lesson_date DATE,
    lesson_time TIME(0),
    discipline_id SMALLINT,
    teacher_id INT
);

-- Заполняем занятия по понедельникам, средам, пятницам
WITH DateRange AS (
    SELECT @StartDate AS CurrentDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CurrentDate)
    FROM DateRange
    WHERE CurrentDate < @EndDate
)
INSERT INTO @Lessons (lesson_date, lesson_time, discipline_id, teacher_id)
SELECT 
    CurrentDate,
    CASE 
        WHEN DATEPART(WEEKDAY, CurrentDate) = 2 THEN '09:00:00' -- Понедельник
        WHEN DATEPART(WEEKDAY, CurrentDate) = 4 THEN '11:00:00' -- Среда
        WHEN DATEPART(WEEKDAY, CurrentDate) = 6 THEN '14:00:00' -- Пятница
    END,
    -- Чередуем дисциплины
    CASE 
        WHEN MONTH(CurrentDate) BETWEEN 9 AND 12 THEN 1 -- Осень: Основы программирования
        WHEN MONTH(CurrentDate) BETWEEN 1 AND 6 THEN 2 -- Весна: Базы данных
        ELSE 3
    END,
    -- Чередуем преподавателей
    CASE 
        WHEN DAY(CurrentDate) % 3 = 0 THEN 1
        WHEN DAY(CurrentDate) % 3 = 1 THEN 2
        ELSE 3
    END
FROM DateRange
WHERE DATEPART(WEEKDAY, CurrentDate) IN (2, 4, 6) -- Пн, Ср, Пт
OPTION (MAXRECURSION 0);


-- Данные в таблицу Schedule
INSERT INTO Schedule (lesson_id, [date], [time], [group], discipline, teacher, [subject], spent)
SELECT 
    ROW_NUMBER() OVER (ORDER BY l.lesson_date) + 
        ISNULL((SELECT MAX(lesson_id) FROM Schedule), 0) AS lesson_id,
    l.lesson_date,
    l.lesson_time,
    @GroupID,
    l.discipline_id,
    l.teacher_id,
    d.discipline_name AS [subject],
    CASE WHEN l.lesson_date <= GETDATE() THEN 1 ELSE 0 END AS spent
FROM @Lessons l
JOIN Disciplines d ON l.discipline_id = d.discipline_id
WHERE NOT EXISTS (
    SELECT 1 FROM Schedule s 
    WHERE s.[group] = @GroupID 
    AND s.[date] = l.lesson_date 
    AND s.[time] = l.lesson_time
);

-- Проверка результата
SELECT 
    lesson_id,
    [date] AS N'Дата',
    [time] AS N'Время',
    [subject] AS N'Предмет',
    teacher AS N'ID преподавателя',
    spent AS N'Проведено'
FROM Schedule
WHERE [group] = @GroupID
ORDER BY [date], [time];