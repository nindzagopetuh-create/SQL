--SQLQuery1-SELECT DIRECTIONS.sql
USE PV_521_Import;

SELECT * FROM Groups,Directions WHERE Groups.direction = Directions.direction_id;
--	   * Все поля