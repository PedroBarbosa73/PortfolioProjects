USE MusicDB;
GO

----- 1 Lista alfabetica de utilizadores ? f

CREATE PROCEDURE 
	dbo.uspAlphabeticUsers AS
SELECT
	CONCAT([FirstName],' ', LastName) AS 'Name'
FROM
	dbo.[user]
ORDER BY
	[Name] ASC;
GO

----- 2 Lista alfabetica de Generos musicais ?

CREATE PROCEDURE 
	dbo.uspAlphabeticGenre AS
SELECT
  [GenreName] AS 'Music Genre'
FROM
  dbo.[Genre]
ORDER BY
	[Music Genre] ASC;
GO

----- 3 Lista alfabetica de Etiquetas/Labels ? 

CREATE PROCEDURE 
	dbo.uspAlphabeticLabels AS
SELECT
	[LabelName] AS 'Label Name'
FROM
	dbo.[Label]
ORDER BY
	[Label Name] ASC;
GO

----- 4 Lista alfabetica de bandas, por paises ?

CREATE PROCEDURE 
	dbo.uspAlphabeticBandPerCountry AS
SELECT
	C.[CountryName] AS 'Country',
	A.[ArtistName] AS 'Band Name'
FROM
	dbo.[Artist] AS A
	INNER JOIN dbo.[Country] AS C ON A.[CountryID] = C.[CountryID]
ORDER BY
	[Country] ASC,
	[Band Name] ASC;
GO

----- 5 Lista alfabética de banda, label, género, nome album ? 

CREATE PROCEDURE
 dbo.uspBandLabelGenreAlbum AS
SELECT
    ar.[artistName] AS 'Artist Name', 
    l.[labelName] AS 'Label Name',  
    al.[albumName] AS 'Album Name',
    
    g.[genreName] AS 'Genre'
FROM
    dbo.[Artist] AS ar
    JOIN dbo.[Label] AS l ON l.[labelID] = ar.[labelID]
    JOIN dbo.[Album] AS al ON al.[artistID] = ar.[artistID]
    JOIN dbo.[Music] AS m ON m.[AlbumID] = al.[albumID]
    JOIN dbo.[Genre] AS g ON g.[genreID] = m.[genreID]
ORDER BY
	[Artist Name] ASC,
	[Label Name] ASC,
	[Album Name] ASC;
GO

-----  6 Lista dos 5 países com mais bandas ? 

CREATE PROCEDURE
	dbo.uspTop5CountryWithMostBands AS
SELECT	
	c.[countryname] AS 'Country Name',
	COUNT(*) AS 'Band Amount'
FROM
	dbo.[Country] AS c
	JOIN dbo.[Artist] AS ar ON c.[countryid] = ar.[CountryID]
GROUP BY
	c.[countryname]
ORDER BY
	[Band Amount] DESC
GO

----- 7 Lista das 10 bandas com mais albuns ? 
CREATE PROCEDURE 
	dbo.uspTop10BandsWithMostAlbums AS
SELECT 
    ar.[artistname] AS 'Artist',
    COUNT(*) AS 'Album Amount'	
FROM
    dbo.[Artist] AS ar
    JOIN dbo.[Album] AS al ON ar.[artistid] = al.[ArtistID]
GROUP BY
    ar.[artistname]
ORDER BY
	[Album Amount] DESC;
GO

----- 8 Lista das 5 etiquetas com mais albuns ? 

CREATE PROCEDURE
	dbo.uspTop5LabelsWithMostAlbums AS
SELECT
   l.[labelname] AS 'Label',
  Count(*) AS 'Album Amount'
FROM
  dbo.[Artist] AS ar
JOIN dbo.[Album] AS al ON ar.[artistID] = al.[artistID]
  JOIN dbo.[Label] AS l ON l.[labelID] = ar.[labelID]
GROUP BY
  l.[labelname]
ORDER BY
  [Album Amount] DESC;
GO


----- 9 Lista dos 5 géneros musicais com mais albuns ? 

CREATE PROCEDURE
	dbo.uspTop5GenresWithMostAlbums AS
SELECT
  Genre AS 'Genre',
  COUNT(*) AS 'Album Amount'
FROM
	(   		
	SELECT     	 
			al.[albumid],
			 g.[genrename] AS 'Genre',
			COUNT(*) AS 'Song Amount'
		FROM
			dbo.[Genre] AS g
			JOIN dbo.[Music] AS m ON m.[genreID] = g.[genreid]
			JOIN dbo.[Album] AS al ON m.[albumID] = al.[albumid]
		GROUP BY
			al.[albumid],
			g.[genrename]
	)	AS sub
GROUP BY
  Genre
ORDER BY
  [Album Amount] DESC;
GO


----- 10 Lista dos 20 temas de albuns mais longos ? 

CREATE PROCEDURE  
 dbo.uspTop20LongestThemesFromAlbums
 AS	

SELECT
	ar.artistname AS 'Artist Name',
	al.albumname AS 'Album Name',
	m.musicname AS 'Theme',
	CAST(DATEADD(SECOND, m.Duration, '00:00:00') AS TIME(0)) AS 'Duration'
FROM
	dbo.music AS m
	JOIN dbo.album AS al ON al.albumid = m.albumid
	JOIN dbo.artist AS ar ON ar.artistid = al.artistid
ORDER BY 
	[Duration] DESC;	
GO

 GO

----- 11 Lista dos 20 temas de albuns mais rápidos ?

CREATE PROCEDURE
	dbo.uspTop20FastestThemesFromAlbums AS
SELECT
	ar.artistname AS 'Artist Name',
	al.albumname AS 'Album Name',
	m.musicname AS 'Theme',
	CAST(DATEADD(SECOND, m.Duration, '00:00:00') AS TIME(0)) AS 'Duration'
FROM
	dbo.music AS m
	JOIN dbo.album AS al ON al.albumid = m.albumid
	JOIN dbo.artist AS ar ON ar.artistid = al.artistid
ORDER BY 
	[Duration] ASC;
 GO

----- 12 Lista dos 10 albuns que demoram mais tempo ? 

CREATE PROCEDURE
	dbo.uspLongestAlbums AS
SELECT
	ar.artistname AS 'Artist Name',
	al.[albumname] AS 'Album',
	CAST(DATEADD(SECOND, SUM(m.duration), '00:00:00') AS TIME(0)) AS 'Duration'
FROM
	dbo.album AS al
	JOIN dbo.[Music] AS m ON al.[albumid] = m.[albumid]
	JOIN dbo.[Artist] AS ar ON ar.[artistid] = al.[artistid]
GROUP BY
ar.artistname,	al.[albumname]
ORDER BY
	Duration DESC;
GO

----- 13 Quantos temas tem cada album ?

CREATE PROCEDURE
	dbo.uspAlbumThemeAmount AS
SELECT
	ar.[artistname] AS 'Artist Name',
	al.[albumname] AS 'Album Name',
	COUNT(*) AS 'Music Amount'
FROM
	dbo.[Album] AS al
	JOIN dbo.[Music] AS m ON al.[albumID] = m.[albumid]
	JOIN dbo.[Genre] AS g ON m.[genreID] = g.[genreid]
	JOIN dbo.[Artist] AS ar ON ar.[artistid] = al.[artistid]
GROUP BY
	ar.[artistname] ,al.[albumname]
ORDER BY
	[Music Amount] DESC;
GO

----- 14 Quantos temas de albuns demoram mais que 5 minutos ? 

CREATE PROCEDURE
	dbo.uspAlbumMore5mins AS
SELECT
	ar.artistname AS 'Artist Name',
	al.albumname AS 'Album Name',
	m.musicname AS 'Music Name',
	CAST(DATEADD(SECOND, Duration, '00:00:00') AS TIME(0)) AS 'Duration'
FROM
	dbo.album AS al
	JOIN dbo.music AS m ON m.albumid = al.albumid
	JOIN dbo.artist as ar ON ar.artistid = al.artistid
WHERE
m.duration > 300
ORDER BY
	[Duration] DESC;
 GO

----- 15 Quais são as músicas mais ouvidas ? 

CREATE PROCEDURE
	dbo.uspMostHeardSongs AS
SELECT
m.[musicname] AS 'Song Name',
	COUNT(*) AS 'Times Listened'
FROM
	dbo.[Music] AS m
	JOIN dbo.[musicHistory] AS h ON m.[musicid] = h.[MusicID]
GROUP BY
	m.[musicname]
ORDER BY
	[Times Listened] DESC;
GO

----- 16 Quais são as músicas mais ouvidas, por país, entre as 0000AM e as 08AM ? 

 CREATE PROCEDURE
	dbo.uspMostHeardSongPerCountryFrom00TO08 AS
 SELECT  
	Country AS 'Country',
	Songname AS 'Song Name',
	Contagem AS 'Times Listened Between 00:00 and 08:00' 
 FROM 
	(
		SELECT 
			c.countryname AS 'Country',
			m.[musicname] AS 'SongName',
			COUNT(*) AS 'Contagem',
			RANK() OVER (
				PARTITION BY  
					c.countryname 
				ORDER BY 
					COUNT(*) DESC)  AS [RANKE]
		FROM
			dbo.[Music] AS m
			JOIN dbo.[musichistory] AS h ON m.[musicid] = h.[MusicID]
			JOIN dbo.[country] AS c ON h.[countryid] = c.[countryID]
	WHERE
		h.[timelistened] BETWEEN '00:00' AND '08:00' 
		GROUP BY  
			c.countryname,
			m.musicname  
	) subq  
WHERE 
	RANKE=1
ORDER BY
	[Times Listened Between 00:00 and 08:00] DESC;
GO


----- 17 Quais são as músicas mais ouvidas, por país, entre as 08:00 e as 16:00 ? 
   

 CREATE PROCEDURE
	dbo.uspMostHeardSongPerCountryFrom08TO16 AS
SELECT
	Country AS 'Country',
	Songname AS 'Song Name',
	Contagem AS 'Times Listened Between 08:00 and 16:00'
FROM
	(
		SELECT
			c.countryname AS 'Country',
			m.[musicname] AS 'SongName',
			COUNT(*) AS 'Contagem',
			 RANK() OVER (
				PARTITION BY 
					c.countryname
				ORDER BY
					COUNT(*) DESC) AS [RANKE]
		FROM
			dbo.[Music] AS m
			JOIN dbo.[musichistory] AS h ON m.[musicid] = h.[MusicID]
			JOIN dbo.[country] AS c ON h.[countryid] = c.[countryID]
		WHERE
			CAST(h.[timelistened] AS TIME) BETWEEN '08:00' AND '16:00'
		GROUP BY
			c.countryname,
			m.musicname
	) subq
WHERE
	RANKE = 1
ORDER BY
  [Times Listened Between 08:00 and 16:00] DESC;
GO

----- 18 Qual o genero musical mais ouvido por país ? 

CREATE PROCEDURE
	dbo.uspMostHeardGenrePerCountry AS
SELECT
	Country AS 'Country',
	Genre AS 'Genre',
	Contagem AS 'Times Listened'
FROM
	(
		SELECT
			c.[countryname] AS 'Country',
			g.genrename AS 'Genre',
			COUNT(*) AS 'Contagem',
			RANK() OVER (
			PARTITION BY 
				c.countryname
			ORDER BY
				COUNT(*) DESC) AS [RANKE]
		FROM
			dbo.[Music] AS m
			JOIN dbo.[musicHistory] AS h ON m.[musicid] = h.[MusicID]
			JOIN dbo.[Genre] AS g ON g.[genreid] = m.[GenreID]
			JOIN dbo.[country] AS c ON c.countryid = h.countryid
		GROUP BY
			c.[countryname],
			g.genrename
	) subq
WHERE
	RANKE = 1
ORDER BY 
	[Country] ASC;
GO

----- 19 Qual o genero musical mais ouvido por país, entre as 0000AM e as 08AM ? 

CREATE PROCEDURE
	dbo.uspMostHeardGenrePerCountry00to08 AS
SELECT
	Country AS 'Country',
	Genre AS 'Genre',
	Contagem AS 'Times Listened Between 00:00 and 08:00'
FROM
	(
		SELECT
			c.[countryname] AS 'Country',
			g.genrename AS 'Genre',
			COUNT(*) AS 'Contagem',
			RANK() OVER (
				PARTITION BY 
					c.countryname
				ORDER BY  
					COUNT(*) DESC) AS RANKE
		FROM
			dbo.[Music] AS m
			JOIN dbo.[musicHistory] AS h ON m.[musicid] = h.[MusicID]
			JOIN dbo.[Genre] AS g ON g.[genreid] = m.[GenreID]
			JOIN dbo.[country] AS c ON c.countryid = h.countryid
		WHERE
			CAST(h.[timelistened] AS TIME) BETWEEN '00:00' AND '08:00'
		GROUP BY
			c.[countryname],
			g.genrename
	) subq
WHERE
	RANKE = 1
ORDER BY
	[Times Listened Between 00:00 and 08:00] DESC;
GO

----- 20 Qual o genero musical mais ouvido por país, entre as 16:00 e as 24:00 ? 

CREATE PROCEDURE
	dbo.uspMostHeardGenrePerCountry16to24 AS
SELECT
	Country AS 'Country',
	Genre AS 'Genre',
	Contagem AS 'Times Listened Between 16:00 and 24:00'  
FROM
	(
  		SELECT
			c.[countryname] AS 'Country',
			g.genrename AS 'Genre',
			COUNT(*) AS 'Contagem',
			RANK() OVER (
				PARTITION BY 
					c.countryname
				ORDER BY
					COUNT(*) DESC)	AS RANKE
		FROM
			dbo.[Music] AS m
			JOIN dbo.[musicHistory] AS h ON m.[musicid] = h.[MusicID]
			JOIN dbo.[Genre] AS g ON g.[genreid] = m.[GenreID]
			JOIN dbo.[country] AS c ON c.countryid = h.countryid
		WHERE
			CAST(h.[timelistened] AS TIME) BETWEEN '16:00'
			AND '23:59:59.9999999'  or CAST(h.[timelistened] AS TIME) = '00:00:00'
		GROUP BY
			c.[countryname],
			g.genrename
  ) subq
WHERE
	RANKE = 1
ORDER BY
	[Times Listened Between 16:00 and 24:00] DESC;
GO
