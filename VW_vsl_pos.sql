CREATE view [dbo].[VW_vsl_pos] as
select v.VesselName, n.ReportDateTime,
	--n.LatDegrees, n.LatMin, n.LatSecs, n.LongDegrees, n.LongMin, n.LongSecs,
	CASE
    WHEN n.EastWestId = 1 THEN (-1)*(n.LatDegrees+n.LatMin/60+n.LatSecs/3600)
    ELSE (n.LatDegrees+n.LatMin/60+n.LatSecs/3600)
	END lat,
	CASE
    WHEN n.NorthSouthId = 1 THEN (-1)*(n.LongDegrees+n.LongMin/60+n.LongSecs/3600)
    ELSE (n.LongDegrees+n.LongMin/60+n.LongSecs/3600)
	END long
from NoonReports n
inner join Hephaestus.dbo.Vessels v ON n.VesselId = v.VesselId
where n.ReportDateTime >= GETDATE()-11
GO
