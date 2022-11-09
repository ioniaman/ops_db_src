-- the below was dropped, in order for the OperationsWeb app to work

ALTER TABLE [dbo].[VoyageBunkers]  WITH CHECK 
ADD  CONSTRAINT [FK_dbo.VoyageBunkers_dbo.VoyageLeg_VoyageId_VoyageLegId] FOREIGN KEY([VoyageId], [VoyageLegId])
REFERENCES [dbo].[VoyageLeg] ([VoyageId], [VoyageLegId])
GO

ALTER TABLE [dbo].[VoyageBunkers] CHECK CONSTRAINT [FK_dbo.VoyageBunkers_dbo.VoyageLeg_VoyageId_VoyageLegId]
GO

-- replace with the below

ALTER TABLE [dbo].[VoyageBunkers]  WITH CHECK 
ADD  CONSTRAINT [FK_dbo.VoyageBunkers_dbo.VoyageLeg_uid] FOREIGN KEY(voyageleguid)
REFERENCES [dbo].[VoyageLeg] (id)