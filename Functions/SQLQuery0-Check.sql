--SQLQuery0-Check.sql
USE PV_521_Import;
SET DATEFIRST 1;

--EXEC sp_SelectScheduleFor N'PV_521'
--PRINT dbo.GetNextLearningDay(N'PV_521', DEFAULT);
PRINT dbo.GetNextLearningDay(N'PV_521', N'2026-03-05');
PRINT dbo.GetNextLearningDate(N'SPU_411', N'2026-03-07');
PRINT dbo.GetSummertimeSadness(2025);
PRINT dbo.GetEasterDate(2022);