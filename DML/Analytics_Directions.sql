USE PV_521_Import;

SELECT 
    direction_name AS N'Направление обучения',
    COUNT(DISTINCT group_id) AS N'Количество групп',
    COUNT(stud_id) AS N'Количество студентов'
FROM Directions d
LEFT JOIN Groups ON direction_id = direction
LEFT JOIN Students ON group_id = [group]
GROUP BY direction_id, direction_name
ORDER BY direction_name;