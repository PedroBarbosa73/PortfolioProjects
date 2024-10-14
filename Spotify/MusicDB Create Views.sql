USE MusicDB;
GO

----- 1 Lista alfabetica de utilizadores ?

CREATE VIEW 
	dbo.vAlphabeticUsers AS
SELECT
	CONCAT([FirstName],' ', LastName) AS 'Name'
FROM
	dbo.[user];
GO

----- 2 Lista alfabetica de Generos musicais ?

CREATE VIEW 
	dbo.vAlphabeticGenre AS
SELECT
  [GenreName] AS 'Music Genre'
FROM
  dbo.[Genre];
GO

----- 3 Lista alfabetica de Etiquetas/Labels ? 

CREATE VIEW 
	dbo.vAlphabeticLabels AS
SELECT
	[LabelName] AS 'Label Name'
FROM
	dbo.[Label];
GO

----- 4 Lista alfabetica de bandas, por paises ?

CREATE VIEW 
	dbo.vAlphabeticBandPerCountry AS
SELECT
	C.[CountryName] AS 'Country',
	A.[ArtistName] AS 'Band Name'
FROM
	dbo.[Artist] AS A
	INNER JOIN dbo.[Country] AS C ON A.[CountryID] = C.[CountryID];
GO

----- 5 Lista alfabética de banda, label, género, nome album ? 

CREATE VIEW
 dbo.vBandLabelGenreAlbum AS
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
    JOIN dbo.[Genre] AS g ON g.[genreID] = m.[genreID];
GO

-----  6 Lista dos 5 países com mais bandas ? 

CREATE VIEW
	dbo.vTop5CountryWithMostBands AS
SELECT	
	c.[countryname] AS 'Country Name',
	COUNT(*) AS 'Band Amount'
FROM
	dbo.[Country] AS c
	JOIN dbo.[Artist] AS ar ON c.[countryid] = ar.[CountryID]
GROUP BY
	c.[countryname];
GO

----- 7 Lista das 10 bandas com mais albuns ? 
CREATE VIEW 
	dbo.vTop10BandsWithMostAlbums AS
SELECT 
    ar.[artistname] AS 'Artist',
    COUNT(*) AS 'Album Amount'	
FROM
    dbo.[Artist] AS ar
    JOIN dbo.[Album] AS al ON ar.[artistid] = al.[ArtistID]
GROUP BY
    ar.[artistname];
GO

----- 8 Lista das 5 etiquetas com mais albuns ? 

CREATE VIEW
	dbo.vTop5LabelsWithMostAlbums AS
SELECT
   l.[labelname] AS 'Label',
  Count(*) AS 'Album Amount'
FROM
  dbo.[Artist] AS ar
JOIN dbo.[Album] AS al ON ar.[artistID] = al.[artistID]
  JOIN dbo.[Label] AS l ON l.[labelID] = ar.[labelID]
GROUP BY
  l.[labelname];
GO

----- 9 Lista dos 5 géneros musicais com mais albuns ? 

CREATE VIEW
	dbo.vTop5GenresWithMostAlbums AS
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
  Genre;
GO

----- 10 Lista dos 20 temas de albuns mais longos ? 

CREATE VIEW  
 dbo.vTop20LongestThemesFromAlbums
 AS	

SELECT
	ar.artistname AS 'Artist Name',
	al.albumname AS 'Album Name',
	m.musicname AS 'Theme',
	CAST(DATEADD(SECOND, m.Duration, '00:00:00') AS TIME(0)) AS 'Duration'
FROM
	dbo.music AS m
	JOIN dbo.album AS al ON al.albumid = m.albumid
	JOIN dbo.artist AS ar ON ar.artistid = al.artistid;
 GO

----- 11 Lista dos 20 temas de albuns mais rápidos ?

CREATE VIEW
	dbo.vTop20FastestThemesFromAlbums AS
SELECT
	ar.artistname AS 'Artist Name',
	al.albumname AS 'Album Name',
	m.musicname AS 'Theme',
	CAST(DATEADD(SECOND, m.Duration, '00:00:00') AS TIME(0)) AS 'Duration'
FROM
	dbo.music AS m
	JOIN dbo.album AS al ON al.albumid = m.albumid
	JOIN dbo.artist AS ar ON ar.artistid = al.artistid;
 GO

----- 12 Lista dos 10 albuns que demoram mais tempo ? 

CREATE VIEW
	dbo.vLongestAlbums AS
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
GO


----- 13 Quantos temas tem cada album ?

CREATE VIEW
	dbo.vAlbumThemeAmount AS
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
	ar.[artistname] ,al.[albumname];
GO

----- 14 Quantos temas de albuns demoram mais que 5 minutos ? 

CREATE VIEW
	dbo.vAlbumMore5mins AS
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
m.duration > 300;
 GO

----- 15 Quais são as músicas mais ouvidas ? 

CREATE VIEW
	dbo.vMostHeardSongs AS
SELECT
m.[musicname] AS 'Song Name',
	COUNT(*) AS 'Times Listened'
FROM
	dbo.[Music] AS m
	JOIN dbo.[musicHistory] AS h ON m.[musicid] = h.[MusicID]
GROUP BY
	m.[musicname];
GO

----- 16 Quais são as músicas mais ouvidas, por país, entre as 0000AM e as 08AM ? 

 CREATE VIEW
	dbo.vMostHeardSongPerCountryFrom00TO08 AS
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
		CAST(h.[timelistened] AS TIME) BETWEEN '00:00' AND '08:00' 
		GROUP BY  
			c.countryname,
			m.musicname  
	) subq  
WHERE 
	RANKE=1
GO


----- 17 Quais são as músicas mais ouvidas, por país, entre as 08:00 e as 16:00 ? 
   

 CREATE VIEW
	dbo.vMostHeardSongPerCountryFrom08TO16 AS
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
	RANKE = 1;
GO

----- 18 Qual o genero musical mais ouvido por país ? 

CREATE VIEW
	dbo.vMostHeardGenrePerCountry AS
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
  RANKE = 1;
GO

----- 19 Qual o genero musical mais ouvido por país, entre as 0000AM e as 08AM ? 

CREATE VIEW
	dbo.vMostHeardGenrePerCountry00to08 AS
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
	RANKE = 1;
GO

----- 20 Qual o genero musical mais ouvido por país, entre as 16:00 e as 24:00 ? 

CREATE VIEW
	dbo.vMostHeardGenrePerCountry16to24 AS
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
			AND '23:59:59.9999999'  or CAST(h.[timelistened] AS TIME)  = '00:00:00'
		GROUP BY
			c.[countryname],
			g.genrename
  ) subq
WHERE
	RANKE = 1;
GO













