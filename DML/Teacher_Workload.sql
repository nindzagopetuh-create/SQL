USE PV_521_Import;

SELECT 
    last_name + ' ' + first_name AS TeacherName,
    COUNT(discipline) AS DisciplinesCount
FROM Teachers 
LEFT JOIN TeachersDisciplinesRelation ON teacher_id = teacher
GROUP BY teacher_id, last_name, first_name;

SELECT 
    discipline_name AS DisciplineName,
    COUNT(teacher) AS TeachersCount
FROM Disciplines
LEFT JOIN TeachersDisciplinesRelation tdr ON discipline_id = discipline
GROUP BY discipline_id, discipline_name;