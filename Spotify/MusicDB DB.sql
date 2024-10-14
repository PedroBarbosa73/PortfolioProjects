USE [MASTER];
GO

DROP DATABASE IF EXISTS [MusicDB] ;
GO

--------------- CREATE DATABASE ---------------

CREATE DATABASE [MusicDB]
	
	ON PRIMARY
		( 
		NAME = N'MusicDB',
		--FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MusicDB.mdf',
		FILENAME = N'C:\BDT\MusicDB.mdf', 
		SIZE = 50MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 65536KB
		),
	
FILEGROUP MH01-- 1 antes de 2020
(       NAME = N'AW01',
		FILENAME =N'C:\BDT\aw01.ndf',
		SIZE = 10MB,
		MAXSIZE = 100MB,
		FILEGROWTH = 5MB),

FILEGROUP MH02  -- 2 Entre 2020 e antes de 2021
(       NAME = N'AW02',
		FILENAME =N'C:\BDT\aw02.ndf',
		SIZE = 10MB,
		MAXSIZE = 100MB,
		FILEGROWTH = 5MB),
FILEGROUP MH03 -- 3 Entre 2021 e antes de 2022
(       NAME = N'AW03',
		FILENAME =N'C:\BDT\aw03.ndf',
		SIZE = 10MB,
		MAXSIZE = 100MB,
		FILEGROWTH = 5MB),
FILEGROUP MH04 -- 4 Entre 2022 e antes de 2023
(       NAME = N'AW04',
		FILENAME =N'C:\BDT\aw04.ndf',
		SIZE = 10MB,
		MAXSIZE = 100MB,
		FILEGROWTH = 5MB),
 FILEGROUP MH05 -- 5 Entre 2023 e antes de 2024 
 (       NAME = N'AW05',
		FILENAME =N'C:\BDT\aw05.ndf',
		SIZE = 10MB,
		MAXSIZE = 100MB,
		FILEGROWTH = 5MB),

 FILEGROUP MH06 -- 6 Depois de 2024 
 (       NAME = N'AW06',
		FILENAME =N'C:\BDT\aw06.ndf',
		SIZE = 10MB,
		MAXSIZE = 100MB,
		FILEGROWTH = 5MB)

	LOG ON
	(	
		NAME = N'MusicDB_Log',
	--	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MusicDB.ldf', --Disco D (Não tenho outro disco)
		FILENAME = N'C:\BDT\MusicDB_Log.ldf', 
		SIZE = 8192KB,
		FILEGROWTH = 65536KB
	)	
COLLATE Latin1_General_CI_AS;
GO

USE [MusicDB];
GO


--ALTER DATABASE MusicDB 
--	SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON

ALTER DATABASE MusicDB 
	ADD FILEGROUP [MEM_FG]
		CONTAINS MEMORY_OPTIMIZED_DATA;


ALTER DATABASE MusicDB 
	ADD FILE (
		NAME='MEM_FG', 
		FILENAME='C:\BDT\MEM_FG') 
	TO FILEGROUP MEM_FG



--------------- CREATE TABLES ---------------

CREATE TABLE dbo.[Country] (
	CountryID TINYINT IDENTITY(1,1) NOT NULL,
	CountryName NVARCHAR(50) NOT NULL,
	CONSTRAINT pk_CountryID PRIMARY KEY (CountryID)
)
CREATE TABLE dbo.[Genre] (
	GenreID INT IDENTITY(1,1) NOT NULL,
	GenreName NVARCHAR(50) NOT NULL,
	CONSTRAINT pk_GenreID PRIMARY KEY (GenreID)
)

CREATE TABLE dbo.[User] (
	UserID INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_UserID PRIMARY KEY (UserID),
	CountryID TINYINT NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	UserName NVARCHAR(50) UNIQUE NOT NULL,
	Email NVARCHAR(50) UNIQUE NOT NULL,
	CONSTRAINT fk_UserCountryID FOREIGN KEY (CountryID) REFERENCES [Country] (CountryID)
)


CREATE TABLE dbo.[Label] (
	LabelID INT IDENTITY(1,1) NOT NULL,
	CountryID TINYINT NOT NULL,
	LabelName NVARCHAR(50) NOT NULL,
	YearFounded DATE NOT NULL,
	CONSTRAINT pk_LabelID PRIMARY KEY (LabelID),
	CONSTRAINT fk_LabelCountryID FOREIGN KEY (CountryID) REFERENCES [Country] (CountryID)
)

CREATE TABLE dbo.[Artist] (
	ArtistID INT IDENTITY(1,1) NOT NULL,
	LabelID INT NOT NULL,
	CountryID TINYINT NOT NULL,
	ArtistName NVARCHAR(50) NOT NULL,
	CONSTRAINT pk_ArtistID PRIMARY KEY (ArtistID),
	CONSTRAINT fk_ArtistLabelID FOREIGN KEY (LabelID) REFERENCES [Label] (LabelID),
	CONSTRAINT fk_ArtistCountryID FOREIGN KEY (CountryID) REFERENCES [Country] (CountryID)
)

CREATE TABLE dbo.[Album] (
	AlbumID INT IDENTITY(1,1) NOT NULL,
	ArtistID INT NOT NULL,
	AlbumName NVARCHAR(50) NOT NULL,
	ReleaseYear DATE NOT NULL,
	CONSTRAINT pk_AlbumID PRIMARY KEY (AlbumID),
	CONSTRAINT fk_AlbumArtistID FOREIGN KEY (ArtistID) REFERENCES [Artist] (ArtistID)
)

CREATE TABLE [Music]  (
	MusicID INT IDENTITY(1,1) NOT NULL,
	GenreID INT NOT NULL,
	AlbumID INT NOT NULL,
	MusicName NVARCHAR(80) NOT NULL,
	Duration INT NOT NULL,
	CONSTRAINT pk_MusicID PRIMARY KEY (MusicID),
	CONSTRAINT fk_MusicGenreID FOREIGN KEY (GenreID) REFERENCES [Genre] (GenreID),
	CONSTRAINT fk_MusicAlbumID FOREIGN KEY (AlbumID) REFERENCES [Album] (AlbumID)

)

CREATE TABLE dbo.[MusicHistory] (
	MusicHistoryID INT IDENTITY(1,1) NOT NULL,
	UserID INT NOT NULL,
	MusicID INT NOT NULL,
	CountryID TINYINT NOT NULL,
	TimeListened DATETIME2 NOT NULL,
	CONSTRAINT pk_MusicHistoryID PRIMARY KEY (MusicHistoryID),
	CONSTRAINT fk_MusicHistoryUserID FOREIGN KEY (UserID) REFERENCES [User] (UserID),
	CONSTRAINT fk_MusicHistoryMusicID FOREIGN KEY (MusicID) REFERENCES [Music] (MusicID), 
	CONSTRAINT fk_MusicHistoryCountryID FOREIGN KEY (CountryID) REFERENCES [Country] (CountryID)
)
GO

--------------- CREATE LOG TABLE FOR USER ---------------

CREATE TABLE User_Log (
	UserID INT NOT NULL PRIMARY KEY NONCLUSTERED,
	CountryID TINYINT NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	UserName NVARCHAR(50)  NOT NULL,
	Email NVARCHAR(50)  NOT NULL,
	LastOP NVARCHAR(20) NOT NULL,
	DateCreated DATETIME2 NOT NULL,
	DateModified DATETIME2 NULL,
	ModifiedBy NVARCHAR(100) NOT NULL,
	Deleted BIT NOT NULL,
)
WITH
	(MEMORY_OPTIMIZED = ON,
	DURABILITY = SCHEMA_AND_DATA);
GO





--------------- CREATE PARTITION TABLE ---------------


CREATE PARTITION FUNCTION PartitionYear(DATETIME2)
	AS RANGE RIGHT
	FOR VALUES ( -- 1 antes de 2020
	'2020-01-01'/*2*/, -- 2 Entre 2020 e antes de 2021
	'2021-01-01'/*3*/, -- 3 Entre 2021 e antes de 2022
	'2022-01-01'/*4*/, -- 4 Entre 2022 e antes de 2023
	'2023-01-01'/*5*/, -- 5 Entre 2023 e antes de 2024 
	'2024-01-01'/*6*/); -- 6 Depois de 2024 
GO

CREATE PARTITION SCHEME MHAnual
	AS PARTITION PartitionYear
		TO (MH01,MH02,MH03,MH04,MH05,MH06);
GO

CREATE TABLE dbo.[MusicHistory_Partition] (
	MusicHistoryID INT NOT NULL,
	UserID INT NOT NULL,
	MusicID INT NOT NULL,
	CountryID TINYINT NOT NULL,
	TimeListened DATETIME2 NOT NULL
)
ON MHAnual(TimeListened);
GO


ALTER TABLE dbo.musichistory_partition REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE);
GO


--------------- CREATE TRIGGER TO INSERT IN MH_Partition --------------- 

CREATE TRIGGER InsertONPartition ON dbo.musichistory
	FOR INSERT AS
	SET NOCOUNT ON;
	INSERT INTO dbo.MusicHistory_Partition
		 ([MusicHistoryID], 
		 [UserID], [MusicID], 
		 [CountryID], 
		 [TimeListened])
	SELECT 
			[MusicHistoryID], 
			[UserID], [MusicID], 
			[CountryID], 
			[TimeListened]
	FROM 
			INSERTED
GO





--------------- CREATE TRIGGER INSERT INTO USER LOG ---------------

CREATE TRIGGER Insert_user_log ON dbo.[User]
	AFTER INSERT AS
	SET NOCOUNT ON;
	--DELETE FROM [USER_LOG] WHERE username IN (SELECT username FROM INSERTED)
	INSERT INTO dbo.user_log --([UserID], [CountryID], [FirstName], [LastName], [UserName], [Email], [LastOP], [DateCreated], [DateModified], [ModifiedBy], [Deleted]) 
	SELECT 
		[UserID],
		[CountryID],
		[FirstName],
		[LastName], 
		[UserName],
		[Email],
		'INSERTED',
		GETDATE(),
		GETDATE(),
		SUSER_NAME(),
		0 --DELETED STATUS
	FROM 
		INSERTED ;
GO
   
--------------- CREATE TRIGGER DELETE FROM USER LOG ---------------

CREATE  TRIGGER delete_user_log ON dbo.[User]
	INSTEAD OF DELETE AS
	SET NOCOUNT ON;
	UPDATE user_log
		SET 
			[LASTOP] = 'DELETED', 
			[DELETED] = 1, 
			[DateModified]= GETDATE(),
			[ModifiedBy] = SUSER_NAME()
	WHERE 
		userID IN (SELECT userID FROM DELETED)  
	DELETE FROM 
		[USER] 
	WHERE 
		userID IN (SELECT userID FROM DELETED)
GO
   

--------------- CREATE TRIGGER UPDATE FROM USER LOG ---------------

CREATE TRIGGER update_user_log ON dbo.[User]
	FOR UPDATE AS
	SET NOCOUNT ON;	
	--DELETE FROM [USER_Log] WHERE userID IN (SELECT userID FROM DELETED)
	
	UPDATE user_log 
	SET 
		Countryid = i.countryid,
		FirstName =i.firstname,
		LastName =i.LastName,
		UserName = i.UserName,
		Email = i.Email,
		[LASTOP] = 'UPDATED',
		DateModified = GETDATE(),
		ModifiedBy = SUSER_NAME()  
   FROM 
		inserted as i
   WHERE 
		user_log.userID IN (SELECT userID FROM INSERTED)
GO

--------------- INSERT INTO --------------------

INSERT INTO [Genre] ([GenreName]) 
	VALUES 
		('POP'),
		('ROCK'),
		('R&B');

INSERT INTO [Country] (CountryName) 
	VALUES		
		('Portugal'),
		('Spain'),
		('USA'),
		('Australia'),
		('UK');

INSERT INTO [User] ([CountryID], [FirstName], [LastName], [UserName], [Email]) 
	VALUES
		(1,'Ana','Andrade','AnaAndrade212','AnaAndrade@gmail.com'),
		(1,'Bernardo','Bento','BernardoBento111','BernardoBento@gmail.com'),
		(1,'Carlos','Cardoso','CarlosCardoso333','CarlosCardoso@gmail.com'),
		(1,'Diana','Dias','DianaDias213','DianaDias@gmail.com'),
		(1,'Filipa','Ferraria','FilipaFerraria123','FilipaFerraria@gmail.com');

INSERT INTO [Label] ([CountryID], [LabelName], [YearFounded] ) 
	VALUES
		(1,'Blackened','2012'),
		(1,'Warner Bros','1958'),
		(1,'Universal','1934'),
		(1,'MCA','1962'),
		(1,'Elektra','1950'),
		(1,'Capitol','1942');

INSERT INTO [Artist] ([LabelID], [CountryID], [ArtistName]) 
	VALUES
		(1,3,'Metallica'),
		(1,3,'MegaDeth'),
		(1,3,'Anthrax'),
		(2,5,'Eric Clapton'),
		(2,3,'ZZ Top'),
		(2,3,'Van Halen'),
		(3,3,'Lynyrd Skynyrd'),
		(3,4,'AC/DC'),
		(6,5,'The Beatles');

INSERT INTO [Album] ([ArtistID], [AlbumName], [ReleaseYear]) 
	VALUES
		(1,'...And Justice For All','1988'),
		(1,'Black Album','1991'),
		(1,'Master of Puppets','1986'),
		(2, 'Endgame','2009'),
		(2, 'Peace Sells','1986'),
		(3, 'The Greater of 2 Evils','2004'),
		(4, 'Reptile','2001'),
		(4, 'Riding with the King','2000'),
		(5, 'Greatest Hits','1992'),
		(6, 'Greatest Hits','2004'),
		(7, 'All-Time Greatest Hits','1975'),
		(8, 'Greatest Hits','2003'),
		(9, 'Sgt. Pepper''s Lonely Hearts Club Band', '1967');

INSERT INTO [Music] ( [GenreID], [AlbumID], [MusicName], [Duration]) 
	VALUES
		(1,1,'One','470'),
		(1,1,'Blackened','402'),
		(1,2,'Enter Sandman','330'),
		(1,2,'Sad But True','329'),
		(1,3,'Master of Puppets','515'),
		(1,3,'Battery','313'),
		(1,4,'Dialectic Chaos','146'),
		(1,4,'Endgame','357'),
		(1,5,'Peace Sells','249'),
		(1,5,'The Conjuring','309'),
		(1,6,'Madhouse','266'),
		(1,6,'I am the Law','363'),
		(1,7,'Reptile','216'),
		(1,7,'Modern Girl','289'),
		(1,8,'Riding with the King','263'),
		(2,8,'Key to the Highway','219'),
		(2,9,'Sharp Dressed Man','255'),
		(2,9,'Legs','272'),
		(2,10,'Eruption','103'),
		(2,10,'Hot For Teacher','283'),
		(2,11,'Sweet Home Alabama','285'),
		(2,11,'Free Bird','863'),
		(2,12,'Thunderstruck','892'),
		(2,12,'T.N.T','215'),
		(2,13,'With a Little Help from My Friends', '193'),
		(2,13,'Lucy in the Sky with Diamonds', '226'),
		(2,13,'Getting Better', '170'),
		(2,13,'Fixing a Hole', '180'),
		(2,13,'She''s Leaving Home', '238'),
		(2,13,'Being for the Benefit of Mr. Kite!','181'),
		(3,13,'Within You Without You','306'),
		(3,13,'When I''m Sixty-Four','181'),
		(3,13,'Lovely Rita', '127'),
		(3,13,'Good Morning Good Morning', '187'),
		(3,13,'Sgt. Pepper''s Lonely Hearts Club Band (Reprise)', '91'),
		(3,13,'A Day in the Life', '365');
GO

----------- INSERT INTO MusicHistory with random values ---------------

DECLARE 
	@i INT, 
	@qtUser INT, 
	@qtMusic INT, 
	@qtCountry TINYINT,
	@Beg DATETIME2(0),
	@End   DATETIME2(0);


SET @i=1;
SET @qtUser = (SELECT COUNT(Userid) FROM [dbo].[User]);
SET @qtMusic = (SELECT COUNT(Musicid) FROM [dbo].[Music]);
SET @qtCountry = (SELECT COUNT(Countryid) FROM [dbo].[Country]);

SET @Beg = '2020-01-01 00:00:00' -- Starting Date
SET @End = '2024-12-31 23:59:59' -- Ending Date

WHILE (@i<=1000) 
	BEGIN 
		SET NOCOUNT ON
		SET @i=@i+1;		
		DECLARE @Seconds INT = DATEDIFF(SECOND, @Beg, @End)
		DECLARE @Rand INT = ROUND(((@Seconds-1) * RAND()), 0)

		INSERT INTO dbo.musichistory( [UserID], [MusicID], [CountryID], [TimeListened]) 
			VALUES 
			(
				FLOOR(RAND()*(@qtUser)+1),
				FLOOR(RAND()*(@qtMusic)+1),
				FLOOR(RAND()*(@qtCountry)+1), 
				DATEADD(SECOND, @Rand, @Beg)
			); 
	END;
GO





----------- TEMP TABLE ----------- 

DROP TABLE IF EXISTS ##HistoryUSA ;

CREATE TABLE ##HistoryUSA (
	MusicHistoryID INT  NOT NULL,
	[Username] NVARCHAR(500) NOT NULL,
	[MusicName] NVARCHAR(500) NOT NULL,
	--Countryname NVARCHAR(500) NOT NULL,
	TimeListened DATETIME2 NOT NULL
);

INSERT INTO ##HistoryUSA
	SELECT mh.Musichistoryid,
	u.[Username], 
	m.[MusicName], 
	--c.Countryname, 
	mh.TimeListened
	FROM musichistory AS mh  JOIN [USER] AS u ON u.userid=mh.userid
	JOIN music AS m ON mh.musicid=m.musicid
	JOIN Country AS c ON mh.countryid= c.countryid
	WHERE mh.countryid=3 -- USA
	



----------- ----------- 

----------- DATA INTEGRITY -----------

--DBCC CHECKDB([MusicDB]);
GO








/*

   
select * from [user]
select * from [user_log] order by userid
select * from [user_log_old] order by userid


INSERT INTO [User] ([CountryID], [FirstName], [LastName], [UserName], [Email]) 
	VALUES
		(2,'TESTE2','TESTE2','TESTEE2221','TESTE2222@gmail.com'),
		(2,'TESTE2','TESTE2','TESTEE0000','TESTE0000@gmail.com');

update [user] set countryid=2 where Firstname='Ana'


		DELETE FROM [USER] WHERE Countryid='2'
		DELETE FROM [USER_log]
		DELETE FROM [USER]


select * from musichistory
delete from musichistory
select * from MusicHistory_Partition order by musichistoryid

SELECT
   *
FROM sys.dm_db_partition_stats
WHERE object_id = OBJECT_ID('dbo.MusicHistory_Partition');
GO

 
 EXEC sp_estimate_data_compression_savings 'dbo', 'musichistory_partition',
NULL, NULL, 'PAGE';

EXEC sp_estimate_data_compression_savings 'dbo', 'musichistory',
NULL, NULL, 'PAGE';


EXEC sp_estimate_data_compression_savings 'dbo', 'music',
NULL, NULL, 'PAGE';

exec sp_spaceused 'musichistory_partition'
SELECT d.compatibility_level
    FROM sys.databases as d
    WHERE d.name = Db_Name();

	*/