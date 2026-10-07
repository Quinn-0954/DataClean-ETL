IF NOT EXISTS (
    SELECT name
    FROM sys.databases
    WHERE name = 'DataCleanDB'
)
BEGIN
CREATE DATABASE DataCleanDB;
END;
GO

PRINT 'Database DataCleanDB criado com sucesso.';
GO
