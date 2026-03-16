--SQLQuery0-CREATE DATABASE.sql
--https://learn.microsoft.com/en-us/sql/t-sql/statements/create-database-transact-sql?view=sql-server-ver17&tabs=sqlpool#:~:text=the%20SIZE%20parameter.-,SQL,-Copy

CREATE DATABASE PV_521_DDL
ON
(
	NAME		=	PV_521_DDL,
	FILENAME	=	'D:\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\PV_521_DDL.mdf',
	SIZE		=	  8 MB,
	MAXSIZE		=	500 MB,
	FILEGROWTH	=	  8 MB
)
LOG ON
(
	NAME		=	PV_521_DDL_log,
	FILENAME	=	'D:\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\PV_521_DDL.ldf',
	SIZE		=	  8 MB,
	MAXSIZE		=	500 MB,
	FILEGROWTH	=	  8 MB
)