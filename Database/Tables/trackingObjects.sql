-- Check SQL Server Version
DECLARE @ProductVersion NVARCHAR(128) = SERVERPROPERTY('ProductVersion')
DECLARE @ProductMajorVersion INT
DECLARE @SQLCmd NVARCHAR(MAX)
DECLARE @LedgerTableSuffix NVARCHAR(50)

SET @ProductMajorVersion = CONVERT(INT, PARSENAME(@ProductVersion, 4))

-- Check if SQL Server version is 2022 or later (Major Version >= 16 for SQL Server 2022)
IF @ProductMajorVersion >= 16
BEGIN
    SET @LedgerTableSuffix = N' WITH (SYSTEM_VERSIONING = ON (LEDGER = ON))'
    PRINT N'SQL Server version is 2022 or later. Creating Ledger tables.'
END
ELSE
BEGIN
    SET @LedgerTableSuffix = N'' -- Empty suffix for regular tables
    PRINT N'SQL Server version is older than 2022. Creating regular tables (Ledger functionality disabled).'
END
GO 

SET @SQLCmd = N'
CREATE TABLE Events.trackingObjects (
    EventTime DATETIME2 GENERATED ALWAYS AS ROW START,
    TransactionId BIGINT GENERATED ALWAYS AS TRANSACTION_ID START HIDDEN,
    SequenceNumber BIGINT GENERATED ALWAYS AS SEQUENCE_NUMBER START HIDDEN,
    EventID INT NULL,
    ObjectName NVARCHAR(256) NULL,
    ObjectType NVARCHAR(128) NULL,
    действие NVARCHAR(128) NULL,
    SchemaName NVARCHAR(128) NULL,
    ServerPrincipalName NVARCHAR(128) NULL,
    LoginName NVARCHAR(128) NULL,
    ClientAppName NVARCHAR(128) NULL,
    ClientHostName NVARCHAR(128) NULL,
    TSQLCommand NVARCHAR(MAX) NULL,
    CONSTRAINT PK_trackingObjects PRIMARY KEY CLUSTERED (EventTime, TransactionId, SequenceNumber)
)' + @LedgerTableSuffix + N'

CREATE NONCLUSTERED INDEX IX_trackingObjects_ObjectType_Action_Principal
ON Events.trackingObjects (ObjectType, действие, ServerPrincipalName)
INCLUDE (EventTime, ObjectName, SchemaName)
';

EXEC sp_executesql @SQLCmd
GO