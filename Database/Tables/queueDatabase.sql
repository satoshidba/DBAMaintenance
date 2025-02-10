SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[queueDatabase]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[queueDatabase](
  [QueueID] [int] NOT NULL,
  [DatabaseName] [sysname] NOT NULL,
  [DatabaseOrder] [int] NULL,
  [DatabaseStartTime] [datetime2](7) NULL,
  [DatabaseEndTime] [datetime2](7) NULL,
  [SessionID] [smallint] NULL,
  [RequestID] [int] NULL,
  [RequestStartTime] [datetime] NULL,
 CONSTRAINT [PK_QueueDatabase] PRIMARY KEY CLUSTERED
(
  [QueueID] ASC,
  [DatabaseName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_queueDatabase_Queue]') AND parent_object_id = OBJECT_ID(N'[dbo].[queueDatabase]'))
ALTER TABLE [dbo].[queueDatabase]  WITH CHECK ADD  CONSTRAINT [FK_queueDatabase_Queue] FOREIGN KEY([QueueID])
REFERENCES [dbo].[queue] ([QueueID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_queueDatabase_Queue]') AND parent_object_id = OBJECT_ID(N'[dbo].[queueDatabase]'))
ALTER TABLE [dbo].[queueDatabase] CHECK CONSTRAINT [FK_queueDatabase_Queue]
GO
