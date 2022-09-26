alter view [dbo].[VW_Latest_Departure] as
select v.VesselId,
  max(FullAwayOnPassageDate) departure
from DepartureDetails d
--inner join Voyage v on v.VoyageId = d.VoyageId -- voyages aren't created anymore
inner join Hephaestus.dbo.Vessels v on SUBSTRING(v.VesselName,1,3) = SUBSTRING(d.VoyageId,1,3)
group by v.VesselId
GO
