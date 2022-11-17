-- First find all the vessel's noon reports in the main database, and see which ones are missing:
select * from NoonReports where VesselId = 'FB3D7B91-D983-4435-A77F-A3BDCC68957A' order by ReportDateTime desc

-- Confirm the above
select * from TelemachusOperations.dbo.NoonReports
where ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)
order by ReportDateTime desc

-- Then find voyages that are completely missing:
select *
from TelemachusOperations.dbo.voyage
where VoyageId in (
  select distinct VoyageId from TelemachusOperations.dbo.NoonReports
  where ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)
  and VoyageId not in (select voyageid from Voyage)
)

-- Then find legs that are missing:
select distinct voyageid, voyagelegid
from TelemachusOperations.dbo.NoonReports n
where ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)
and concat(voyageid,'-',voyagelegid) not in (select concat(voyageid,'-',voyagelegid) from voyageleg)
order by 1,2

-- (the below was tried, but not used)
-- https://stackoverflow.com/questions/1474964/using-tuples-in-sql-in-clause
select * from VoyageLeg l
where exists
(
  select *
  from TelemachusOperations.dbo.NoonReports n
  where ReportDateTime between convert(date, '2022-09-05', 102) and convert(date, '2022-10-21', 102)
  and n.VoyageId = l.VoyageId and n.VoyageLegId = l.VoyageLegId
)

-- https://stackoverflow.com/questions/319354/what-is-the-equivalent-of-describe-table-in-sql-server
Select COLUMN_NAME From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'oildata'

-- add commas to every line using shift+option+i according to the below:
-- https://www.folkstalk.com/2022/09/vs-code-add-commas-to-end-of-every-line-with-code-examples.html
-- xcode: Hold Control and Shift then click
-- https://twitter.com/meggsila/status/1593268037607723010

--------------------- INSERTS -------------------------

insert into Voyage(VoyageId,VesselId,VoyageNo,CreatedById,ModifiedById,DateCreated,DateModified,VoyageYear,ChartererId,BrokerId,CargoTypeId,CargoId,
LaycanStart,LaycanEnd,IsTC,TCId,TotalNumberOfDays,VoyageStatusId,VoyageStart,VoyageEnd,IsReceived,IsTransferred,IsCorrectionRequested,
IsUpdated,IsSubmitted,IsAccepted,DateSubmitted,DateReceived,DateCorrectionRequested,DateUpdated,DateAccepted
)
select VoyageId,VesselId,VoyageNo,CreatedById,ModifiedById,getdate(),DateModified,VoyageYear,ChartererId,BrokerId,CargoTypeId,CargoId,
LaycanStart,LaycanEnd,IsTC,TCId,TotalNumberOfDays,VoyageStatusId,VoyageStart,VoyageEnd,IsReceived,IsTransferred,IsCorrectionRequested,
IsUpdated,IsSubmitted,IsAccepted,DateSubmitted,DateReceived,DateCorrectionRequested,DateUpdated,DateAccepted
from TelemachusOperations.dbo.voyage
where VoyageId in (
  select distinct VoyageId from TelemachusOperations.dbo.NoonReports
  where VoyageId not in (select voyageid from Voyage)
  and ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)
)

-----------------------------------------

insert into voyageoil(VoyageId,VoyageLegId,CylinderOilReceived,MEOilReceived,DGOilReceived,CylinderOilDepartureROB,MEOilDepartureROB,
DGOilDepartureROB,CylinderOilArrivalROB,MEOilArrivalROB,DGOilArrivalROB,CylinderOilCons,MEOilCons,DGOilCons,
CreatedById,ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed
)
select VoyageId,VoyageLegId,CylinderOilReceived,MEOilReceived,DGOilReceived,CylinderOilDepartureROB,MEOilDepartureROB,
DGOilDepartureROB,CylinderOilArrivalROB,MEOilArrivalROB,DGOilArrivalROB,CylinderOilCons,MEOilCons,DGOilCons,
getdate(),ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed
from TelemachusOperations.dbo.voyageoil
where voyageid = 'EST-2022-V06-(044)'

-----------------------------------------

insert into voyageleg(VoyageId,VoyageLegId,DepPortId,DestPortId,ViaRouteId,OperationTypeId,AgentName,DACost,ArivalTime,DepartureTime,
VesselConditionId,CreatedById,ModifiedById,DateCreated,DateModified,TotalDistance,SecaDistance,SteamingDistance,ToGoDistance,
OrderedSpeed,ActualSpeed,DiffSpeed,TotalVoyageDays,SteamingDays,ToGoDays,ContractedETA,CaptainETA,ActualETA,DelayETA,
VoyageOil_VoyageId,VoyageOil_VoyageLegId,SlopsSludges_VoyageId,SlopsSludges_VoyageLegId,IsReceived,IsTransferred,
IsCorrectionRequested,IsUpdated,IsSubmitted,IsAccepted,DateSubmitted,DateReceived,DateCorrectionRequested,DateUpdated,DateAccepted
)
select VoyageId,VoyageLegId,DepPortId,DestPortId,ViaRouteId,OperationTypeId,AgentName,DACost,ArivalTime,DepartureTime,
VesselConditionId,CreatedById,ModifiedById,getdate(),DateModified,TotalDistance,SecaDistance,SteamingDistance,ToGoDistance,
OrderedSpeed,ActualSpeed,DiffSpeed,TotalVoyageDays,SteamingDays,ToGoDays,ContractedETA,CaptainETA,ActualETA,DelayETA,
VoyageOil_VoyageId,VoyageOil_VoyageLegId,SlopsSludges_VoyageId,SlopsSludges_VoyageLegId,IsReceived,IsTransferred,
IsCorrectionRequested,IsUpdated,IsSubmitted,IsAccepted,DateSubmitted,DateReceived,DateCorrectionRequested,DateUpdated,DateAccepted
from TelemachusOperations.dbo.VoyageLeg
where voyageid = 'EST-2022-V06-(044)'

-----------------------------------------
------------ PARTIAL INSERTS ------------
-----------------------------------------

insert into voyageoil(VoyageId,VoyageLegId,CylinderOilReceived,MEOilReceived,DGOilReceived,CylinderOilDepartureROB,MEOilDepartureROB,
DGOilDepartureROB,CylinderOilArrivalROB,MEOilArrivalROB,DGOilArrivalROB,CylinderOilCons,MEOilCons,DGOilCons,
CreatedById,ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed
)
select VoyageId,VoyageLegId,CylinderOilReceived,MEOilReceived,DGOilReceived,CylinderOilDepartureROB,MEOilDepartureROB,
DGOilDepartureROB,CylinderOilArrivalROB,MEOilArrivalROB,DGOilArrivalROB,CylinderOilCons,MEOilCons,DGOilCons,
getdate(),ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed
from TelemachusOperations.dbo.voyageoil
where (voyageid = 'GEA-2022-V08' and VoyageLegId in (5,6))
or (voyageid = 'GEA-2022-V09' and VoyageLegId between 2 and 6)

-----------------------------------------

insert into voyageleg(VoyageId,VoyageLegId,DepPortId,DestPortId,ViaRouteId,OperationTypeId,AgentName,DACost,ArivalTime,DepartureTime,
VesselConditionId,CreatedById,ModifiedById,DateCreated,DateModified,TotalDistance,SecaDistance,SteamingDistance,ToGoDistance,
OrderedSpeed,ActualSpeed,DiffSpeed,TotalVoyageDays,SteamingDays,ToGoDays,ContractedETA,CaptainETA,ActualETA,DelayETA,
VoyageOil_VoyageId,VoyageOil_VoyageLegId,SlopsSludges_VoyageId,SlopsSludges_VoyageLegId,IsReceived,IsTransferred,
IsCorrectionRequested,IsUpdated,IsSubmitted,IsAccepted,DateSubmitted,DateReceived,DateCorrectionRequested,DateUpdated,DateAccepted
)
select VoyageId,VoyageLegId,DepPortId,DestPortId,ViaRouteId,OperationTypeId,AgentName,DACost,ArivalTime,DepartureTime,
VesselConditionId,CreatedById,ModifiedById,getdate(),DateModified,TotalDistance,SecaDistance,SteamingDistance,ToGoDistance,
OrderedSpeed,ActualSpeed,DiffSpeed,TotalVoyageDays,SteamingDays,ToGoDays,ContractedETA,CaptainETA,ActualETA,DelayETA,
VoyageOil_VoyageId,VoyageOil_VoyageLegId,SlopsSludges_VoyageId,SlopsSludges_VoyageLegId,IsReceived,IsTransferred,
IsCorrectionRequested,IsUpdated,IsSubmitted,IsAccepted,DateSubmitted,DateReceived,DateCorrectionRequested,DateUpdated,DateAccepted
from TelemachusOperations.dbo.VoyageLeg
where (voyageid = 'GEA-2022-V08' and VoyageLegId in (5,6))
or (voyageid = 'GEA-2022-V09' and VoyageLegId between 2 and 6)

-----------------------------------------
---------- NOON REPORT INSERTS ----------
-----------------------------------------

insert into noonreports(
NoonReportId,VesselId,ReportDateTime,GmtDiffId,VoyageId,LatDegrees,LatMin,LatSecs,LongDegrees,LongMin,LongSecs,
CreatedById,ModifiedById,DateCreated,DateModified,EastWestId,NorthSouthId,VoyageLegId,CaptainId,Remarks,OperatorId,
VesselConditionId,ReportStatusId,RepCompletedAtId,IsReceived,IsTransferred,IsCorrectionRequested,IsUpdated,
IsSubmitted,IsAccepted,DateSubmitted,DateReceived,DateCorrectionRequested,DateUpdated,DateAccepted,voyageleguid
)
select NoonReportId,VesselId,ReportDateTime,GmtDiffId,n.VoyageId,LatDegrees,LatMin,LatSecs,LongDegrees,LongMin,LongSecs,
n.CreatedById,n.ModifiedById,getdate(),n.DateModified,EastWestId,NorthSouthId,n.VoyageLegId,CaptainId,Remarks,OperatorId,
n.VesselConditionId,ReportStatusId,RepCompletedAtId,n.IsReceived,n.IsTransferred,n.IsCorrectionRequested,n.IsUpdated,
n.IsSubmitted,n.IsAccepted,n.DateSubmitted,n.DateReceived,n.DateCorrectionRequested,n.DateUpdated,n.DateAccepted, l.id
from TelemachusOperations.dbo.NoonReports n
inner join voyageleg l on l.voyageid = n.voyageid and l.voyagelegid = n.voyagelegid
where ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)

-----------------------------------------

insert into bunkersdata(NoonReportId,FuelTypeId,ROB,MainEngineCons,AuxCons,TotalCons,Propulsion,Boiler,Incinerator,CargoHeating,Others,
CreatedById,ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed,PreviousROB,Generators,Inerting
)
select b.NoonReportId,FuelTypeId,ROB,MainEngineCons,AuxCons,TotalCons,Propulsion,Boiler,Incinerator,CargoHeating,Others,
b.CreatedById,b.ModifiedById,ReviewedById,getdate(),b.DateModified,DateReviewed,PreviousROB,Generators,Inerting
from TelemachusOperations.dbo.bunkersdata b
inner join TelemachusOperations.dbo.NoonReports n on n.NoonReportId = b.NoonReportId
where ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)

-----------------------------------------

insert into voyagedata(NoonReportId,OrderedSpeed,ObservedDistance,EngineDistance,Salinity,Ballast,FwdDraft,MidDraft,AftDraft,Heading,SteamingHours,DWT,
Displacement,CreatedById,ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed,AverageSpeed,DistanceToGo,
AverageSpeedThruWater,Trim,Slip,AverageRPM,Pitch
)
select b.NoonReportId,OrderedSpeed,ObservedDistance,EngineDistance,Salinity,Ballast,FwdDraft,MidDraft,AftDraft,Heading,SteamingHours,DWT,
Displacement,b.CreatedById,b.ModifiedById,ReviewedById,getdate(),b.DateModified,DateReviewed,AverageSpeed,DistanceToGo,
AverageSpeedThruWater,Trim,Slip,AverageRPM,Pitch
from TelemachusOperations.dbo.voyagedata b
inner join TelemachusOperations.dbo.NoonReports n on n.NoonReportId = b.NoonReportId
where ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)

-----------------------------------------

insert into enginedata(NoonReportId,MEAverageTurboChargerRPM,FuelOilPumpIndex,MEScavengeAirPressure,MEScavengeAirInletTemp,MainEngineRevs,MainEngineOutput,
BoilerHours,IncineratorHours,FWGeneratorHours,Gen1Hrs,Gen2Hrs,Gen3Hrs,Gen4Hrs,MainEngineHrs,Gen1KW,Gen2KW,Gen3KW,Gen4KW,MainEngineKW,
METCAirInletTemp,MEAirCoolerCoolingWaterInletTemp,ExhaustGasTempBeforeTC,ExhaustGasTempAfterTC,ERTemp,EGESteamPress,BarometricPressure,
FOLowerCaloriferValue,MEAuxBlowerStatusOn,CreatedById,ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed
)
select b.NoonReportId,MEAverageTurboChargerRPM,FuelOilPumpIndex,MEScavengeAirPressure,MEScavengeAirInletTemp,MainEngineRevs,MainEngineOutput,
BoilerHours,IncineratorHours,FWGeneratorHours,Gen1Hrs,Gen2Hrs,Gen3Hrs,Gen4Hrs,MainEngineHrs,Gen1KW,Gen2KW,Gen3KW,Gen4KW,MainEngineKW,
METCAirInletTemp,MEAirCoolerCoolingWaterInletTemp,ExhaustGasTempBeforeTC,ExhaustGasTempAfterTC,ERTemp,EGESteamPress,BarometricPressure,
FOLowerCaloriferValue,MEAuxBlowerStatusOn,b.CreatedById,b.ModifiedById,ReviewedById,getdate(),b.DateModified,DateReviewed
from TelemachusOperations.dbo.enginedata b
inner join TelemachusOperations.dbo.NoonReports n on n.NoonReportId = b.NoonReportId
where ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)

-----------------------------------------

insert into weatherdata(NoonReportId,AirTemp,[Current],SeaTemp,BadWeatherHours,BadWeatherDistance,SeaHeight,SwellHeight,SeaStateId,SwellId,WindForceId,
SeaDirId,SwellDirId,WindDirId,CurrentDirId,CreatedById,ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed
)
select b.NoonReportId,AirTemp,[Current],SeaTemp,BadWeatherHours,BadWeatherDistance,SeaHeight,SwellHeight,SeaStateId,SwellId,WindForceId,
SeaDirId,SwellDirId,WindDirId,CurrentDirId,b.CreatedById,b.ModifiedById,ReviewedById,getdate(),b.DateModified,DateReviewed
from TelemachusOperations.dbo.weatherdata b
inner join TelemachusOperations.dbo.NoonReports n on n.NoonReportId = b.NoonReportId
where ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)

-----------------------------------------

insert into waterdata(NoonReportId,DistilledWaterReceived,DistilledWaterConsumed,DistilledWaterROB,DistilledWaterProduced,
FreshWaterReceived,FreshWaterConsumed,FreshWaterROB,SlopsROB,
CreatedById,ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed,SlopsProduced,SludgeROB,BilgeROB
)
select b.NoonReportId,DistilledWaterReceived,DistilledWaterConsumed,DistilledWaterROB,DistilledWaterProduced,
FreshWaterReceived,FreshWaterConsumed,FreshWaterROB,SlopsROB,
b.CreatedById,b.ModifiedById,ReviewedById,getdate(),b.DateModified,DateReviewed,SlopsProduced,SludgeROB,BilgeROB
from TelemachusOperations.dbo.waterdata b
inner join TelemachusOperations.dbo.NoonReports n on n.NoonReportId = b.NoonReportId
where ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)

-----------------------------------------

insert into oildata(NoonReportId,CylinderOilCons,MEOilCons,DGOilCons,CylinderOilROB,MEOilROB,DGOilROB,MEOilAddChange,DGOilAddChange,
CreatedById,ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed,CylinderOilReceived,MEOilReceived,DGOilReceived
)
select b.NoonReportId,CylinderOilCons,MEOilCons,DGOilCons,CylinderOilROB,MEOilROB,DGOilROB,MEOilAddChange,DGOilAddChange,
b.CreatedById,b.ModifiedById,ReviewedById,getdate(),b.DateModified,DateReviewed,CylinderOilReceived,MEOilReceived,DGOilReceived
from TelemachusOperations.dbo.oildata b
inner join TelemachusOperations.dbo.NoonReports n on n.NoonReportId = b.NoonReportId
where ReportDateTime between convert(date, '2022-09-06', 102) and convert(date, '2022-10-25', 102)

-----------------------------------------
-------- FIX EXISTING REPORT ------------
-----------------------------------------

-- Find noon reports that are missing bunkers data
select *
from NoonReports n
left join bunkersdata b on n.NoonReportId = b.NoonReportId
where n.VesselId = 'FB3D7B91-D983-4435-A77F-A3BDCC68957A'
order by n.ReportDateTime desc


insert into bunkersdata(NoonReportId,FuelTypeId,ROB,MainEngineCons,AuxCons,TotalCons,Propulsion,Boiler,Incinerator,CargoHeating,Others,
CreatedById,ModifiedById,ReviewedById,DateCreated,DateModified,DateReviewed,PreviousROB,Generators,Inerting
)
select 'b6009e5e-47d3-46ef-8740-4482613f8bc5',FuelTypeId,ROB,MainEngineCons,AuxCons,TotalCons,Propulsion,Boiler,Incinerator,CargoHeating,Others,
b.CreatedById,b.ModifiedById,ReviewedById,getdate(),b.DateModified,DateReviewed,PreviousROB,Generators,Inerting
from TelemachusOperations.dbo.bunkersdata b
inner join TelemachusOperations.dbo.NoonReports n on n.NoonReportId = b.NoonReportId
where n.NoonReportId = 'e0b7c1df-be65-402f-a0c7-929eeddb55f9'
