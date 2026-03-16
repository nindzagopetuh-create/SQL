--SQLQuery7-GetEasterDate.sql
USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION GetEasterDate(@year AS	SMALLINT)RETURNS DATE
AS
BEGIN
	DECLARE @a		AS	SMALLINT	= @year%19;
	DECLARE @b		AS	SMALLINT	= @year%4;
	DECLARE @c		AS	SMALLINT	= @year%7;
	DECLARE @d		AS	SMALLINT	= (19*@a + 15)%30;
	DECLARE @e		AS	SMALLINT	= (2*@b + 4*@c + 6*@d + 6)%7;
	DECLARE @f		AS	SMALLINT	= @d+@e;
	RETURN	DATEFROMPARTS(@year,	IIF(@f>26, 5, 4),		IIF(@f>26, @f-26, 4+@f));
END