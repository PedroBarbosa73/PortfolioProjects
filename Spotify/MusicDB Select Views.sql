USE MusicDB;
GO

----- 1 Lista alfabetica de utilizadores ?

SELECT 
	[Name]
FROM 
	dbo.vAlphabeticUsers
ORDER BY
	[Name] ASC;
GO

----- 2 Lista alfabetica de Generos musicais ? 

SELECT 
	[Music Genre] 
FROM 
	dbo.vAlphabeticGenre
ORDER BY
	[Music Genre] ASC;
GO

----- 3 Lista alfabetica de Etiquetas/Labels ? 

SELECT
	[Label Name]
FROM
	dbo.vAlphabeticLabels
ORDER BY
	[Label Name] ASC;
GO

----- 4 Lista alfabetica de bandas, por paises ? 

SELECT 
	[Country],
	[Band Name]
FROM 
	dbo.vAlphabeticBandPerCountry
ORDER BY
	[Country] ASC,
	[Band Name] ASC;
 GO

----- 5 Lista alfabética de banda, label, género, nome album ? 

SELECT 
	[Artist Name],
	[Label Name],
	[Album Name],
	[Genre]	
FROM 
	dbo.vBandLabelGenreAlbum
ORDER BY
	[Artist Name] ASC,
	[Label Name] ASC,
	[Album Name] ASC;
GO

----- 6 Lista dos 5 países com mais bandas ?

SELECT 
	TOP(5) WITH TIES 
		[Country Name], 
		[Band Amount] 
FROM 
	dbo.vTop5CountryWithMostBands
ORDER BY
	[Band Amount] DESC
GO

----- 7 Lista das 10 bandas com mais albuns ? 

SELECT 
	TOP(10) WITH TIES 
		[Artist], 
		[Album Amount]  
FROM 
	dbo.vTop10BandsWithMostAlbums
ORDER BY
	[Album Amount] DESC;
GO

----- 8 Lista das 5 etiquetas com mais albuns ? 

SELECT 
	TOP(5) WITH TIES 
		[Label],
		[Album Amount]
FROM
	dbo.vTop5LabelsWithMostAlbums
ORDER BY
  [Album Amount] DESC;
GO

----- 9 Lista dos 5 géneros musicais com mais albuns ?

SELECT 
	 [Genre],
	 [Album Amount] 
FROM 
	dbo.vTop5GenresWithMostAlbums
ORDER BY
  [Album Amount] DESC;
GO

----- 10 Lista dos 20 temas de albuns mais longos ? 

SELECT 
	TOP(20) WITH TIES 
		[Artist Name], 
		[Album Name], 
		[Theme], 
		[Duration]
FROM 
	dbo.vTop20LongestThemesFromAlbums
ORDER BY 
	[Duration] DESC;	
GO

----- 11 Lista dos 20 temas de albuns mais rápidos ?

SELECT 
	TOP(20) WITH TIES 
		[Artist Name], 
		[Album Name], 
		[Theme], 
		[Duration]
FROM 
	dbo.vTop20FastestThemesFromAlbums
ORDER BY 
	[Duration] ASC;
GO

----- 12 Lista dos 10 albuns que demoram mais tempo ? 

SELECT  
	TOP(10) WITH TIES  
		[Artist Name], 
		[Album], 
		[Duration] 
FROM 
	dbo.vLongestAlbums
ORDER BY
	Duration DESC;
GO

----- 13 Quantos temas tem cada album ? 

SELECT 
	[Artist Name], 
	[Album Name], 
	[Music Amount]
FROM 
	dbo.vAlbumThemeAmount
ORDER BY
	[Music Amount] DESC;
GO

----- 14 Quantos temas de albuns demoram mais que 5 minutos ?

SELECT 
	TOP(10) WITH TIES 
	[Artist Name],
	[Music Name],
	[Album Name],
	[Duration]
FROM 
	dbo.vAlbumMore5mins 
ORDER BY
	[Duration] DESC;
GO

----- 15 Quais são as músicas mais ouvidas ?

SELECT 
	TOP(10) WITH TIES 
	[Song Name],
	[Times Listened]
FROM 
	dbo.vMostHeardSongs
ORDER BY
	[Times Listened] DESC;
GO

----- 16 Quais são as músicas mais ouvidas, por país, entre as 0000AM e as 08AM ? 

SELECT  
	[Country], 
	[Song Name], 
	[Times Listened Between 00:00 and 08:00]
FROM 	
	dbo.vMostHeardSongPerCountryFrom00TO08
ORDER BY
  [Times Listened Between 00:00 and 08:00] DESC;
GO

----- 17 Quais são as músicas mais ouvidas, por país, entre as 08:00 e as 16:00 ? 

SELECT 
	[Country], 
	[Song Name],
	[Times Listened Between 08:00 and 16:00]
FROM 
	dbo.vMostHeardSongPerCountryFrom08TO16
ORDER BY
  [Times Listened Between 08:00 and 16:00] DESC;
GO

----- 18 Qual o genero musical mais ouvido por país ? 

SELECT 
	[Country], 
	[Genre], 
	[Times Listened]
FROM 
	dbo.vMostHeardGenrePerCountry
ORDER BY 
  [Country] ASC;
GO

----- 19 Qual o genero musical mais ouvido por país, entre as 0000AM e as 08AM ? 

SELECT 
	[Country], 
	[Genre], 
	[Times Listened Between 00:00 and 08:00]
FROM 
	dbo.vMostHeardGenrePerCountry00to08
ORDER BY
 [Times Listened Between 00:00 and 08:00] DESC;
 GO

----- 20 Qual o genero musical mais ouvido por país, entre as 16:00 e as 24:00 ? 

SELECT 
	[Country], 
	[Genre], 
	[Times Listened Between 16:00 and 24:00]
FROM 
	dbo.vMostHeardGenrePerCountry16to24
ORDER BY
	[Times Listened Between 16:00 and 24:00] DESC;
GO

