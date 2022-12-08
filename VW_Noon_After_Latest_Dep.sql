create view [dbo].[VW_Noon_After_Latest_Dep] as
select n.*
from NoonReportSummaryV2 n, VW_Latest_Departure d
where n.VesselId = d.VesselId
and n.ReportDateTime >= d.departure
GO
