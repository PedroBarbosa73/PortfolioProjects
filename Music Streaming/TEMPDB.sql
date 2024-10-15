
USE tempdb;  -- Ensure you're in the tempdb database

-- Declare the file name you want to delete
DECLARE @fileName NVARCHAR(255) = 'tempdb_NewData';  -- Change this to your file name

-- Check if the file exists
IF EXISTS (SELECT 1 FROM sys.database_files WHERE name = @fileName)
BEGIN
    -- If it exists, drop the file
   
DBCC SHRINKFILE (tempdb_NewData, EMPTYFILE);
ALTER DATABASE [tempdb] REMOVE FILE tempdb_NewData;

END
ELSE
BEGIN
    PRINT 'File does not exist: ' + @fileName;
END


ALTER DATABASE [tempdb] 
ADD FILE ( 
	NAME = N'tempdb_NewData',  -- Nome lógico do novo arquivo
    FILENAME = N'C:\BDT\tempdb_NewData.ndf' , 
    SIZE = 8192KB , -- Tamanho inicial do arquivo
    FILEGROWTH = 65536KB -- Crescimento automático do arquivo
    )
GO

USE tempdb;
GO
--DBCC SHOWFILESTATS;
--GO


