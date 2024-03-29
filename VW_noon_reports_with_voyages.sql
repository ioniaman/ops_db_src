ALTER view [dbo].[VW_noon_reports_with_voyages] as
select v.VesselName, n.ReportDateTime, g.Display GMTDiff,
  n.LatDegrees, n.LatMin, n.LatSecs, n.LongDegrees, n.LongMin, n.LongSecs, n.EastWestId, n.NorthSouthId,
  vl.VoyageId, vl.VoyageLegId, vl.DepartureTime, vl.ArivalTime, p1.PortName dep_port, p2.PortName arr_port
from NoonReports n
join Hephaestus.dbo.Vessels v on n.VesselId = v.VesselId
join GMTDiff g on n.GmtDiffId = g.GMTDiffId
left join VoyageLeg vl on ( (n.VoyageId = vl.VoyageId and n.VoyageLegId = vl.VoyageLegId) or n.voyageleguid = vl.ID)
  and vl.VoyageId <> 'LYS-2022-V01-047' -- temporary, also added in Technical.NoonReportsViewAll
--join DepartureDetails d on ( (d.VoyageId = vl.VoyageId and d.VoyageLegId = vl.VoyageLegId) or d.voyageleguid = vl.ID)
left JOIN PortsV2 p1 ON vl.DepPortId = p1.PortId
left JOIN PortsV2 p2 ON vl.DestPortId = p2.PortId
where n.ReportDateTime > convert(date, '2022-01-01', 102)
GO
