create procedure SP_Approve_noon_reports as
update NoonReports
set ReportStatusId = 8,
  IsAccepted = 1,
  DateAccepted = GETDATE()
where ReportDateTime > convert(date, '2022-03-19', 102)
and IsAccepted is NULL
