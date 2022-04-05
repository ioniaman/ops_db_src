USE msdb;
GO  
EXEC dbo.sp_add_job  
    @job_name = N'Approve noon reports';
GO  
EXEC sp_add_jobstep  
    @job_name = N'Approve noon reports',  
    @step_name = N'Step 1',  
    @subsystem = N'TSQL',
    @database_name = N'Operations',
    @command = N'EXECUTE SP_Approve_noon_reports',
    @retry_attempts = 5,  
    @retry_interval = 5 ;  
GO  
EXEC dbo.sp_add_schedule  
    @schedule_name = N'RunEvery30Minutes',
    @freq_type = 4,
    @freq_interval = 1,
    @freq_subday_type = 4,
    @freq_subday_interval = 30;
GO  
EXEC sp_attach_schedule
   @job_name = N'Approve noon reports',  
   @schedule_name = N'RunEvery20Minutes';
GO  
EXEC dbo.sp_add_jobserver  
    @job_name = N'Approve noon reports';  
GO  