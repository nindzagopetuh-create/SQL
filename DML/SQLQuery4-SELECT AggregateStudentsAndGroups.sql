--SQLQuery4-SELECT AggregateStudentsAndGroups.sql
USE PV_521_Import;

SELECT
		direction_name				AS	N'Направление обучения'
		,COUNT(DISTINCT group_id)	AS	N'Количество групп'
		,COUNT(stud_id)				AS	N'Количество студентов'
FROM	Students,Groups,Directions
WHERE	Students.[group]			=	Groups.group_id
AND		Groups.direction			=	Directions.direction_id
GROUP BY	direction_name
;

SELECT
		direction_name		AS	N'Направление обучения'
		--,COUNT(stud_id)		AS	N'Количество судентов'
		--,COUNT(DISTINCT group_id)	AS	N'Количество групп'
		,(SELECT COUNT(group_id) FROM Groups WHERE direction=direction_id)	AS N'Количество групп'
		,(
			SELECT COUNT(stud_id) 
			FROM Students,Groups--,Directions 
			WHERE [group]=group_id 
			AND direction=direction_id
		 )	AS	N'Количество студентов'
FROM	Directions
;