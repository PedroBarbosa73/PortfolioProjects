USE MusicDB;
GO

----- 1 Lista alfabetica de utilizadores ? f

EXEC dbo.uspAlphabeticUsers
GO

----- 2 Lista alfabetica de Generos musicais ? 

EXEC	dbo.uspAlphabeticGenre
GO

----- 3 Lista alfabetica de Etiquetas/Labels ? 

EXEC	dbo.uspAlphabeticLabels
GO

----- 4 Lista alfabetica de bandas, por paises ? 

EXEC	dbo.uspAlphabeticBandPerCountry
GO

----- 5 Lista alfabética de banda, label, género, nome album ? 

EXEC	dbo.uspBandLabelGenreAlbum

GO

----- 6 Lista dos 5 países com mais bandas ?

EXEC	dbo.uspTop5CountryWithMostBands
GO

----- 7 Lista das 10 bandas com mais albuns ? 

EXEC	dbo.uspTop10BandsWithMostAlbums
GO

----- 8 Lista das 5 etiquetas com mais albuns ? 

EXEC	dbo.uspTop5LabelsWithMostAlbums
GO

----- 9 Lista dos 5 géneros musicais com mais albuns ?

EXEC	dbo.uspTop5GenresWithMostAlbums
GO

----- 10 Lista dos 20 temas de albuns mais longos ? 

EXEC	dbo.uspTop20LongestThemesFromAlbums
GO

----- 11 Lista dos 20 temas de albuns mais rápidos ?

EXEC	dbo.uspTop20FastestThemesFromAlbums
GO

----- 12 Lista dos 10 albuns que demoram mais tempo ? 


EXEC	dbo.uspLongestAlbums
GO

----- 13 Quantos temas tem cada album ? 

EXEC	dbo.uspAlbumThemeAmount
GO

----- 14 Quantos temas de albuns demoram mais que 5 minutos ?

EXEC	dbo.uspAlbumMore5mins 
GO

----- 15 Quais são as músicas mais ouvidas ?

EXEC	dbo.uspMostHeardSongs
GO

----- 16 Quais são as músicas mais ouvidas, por país, entre as 0000AM e as 08AM ? 

EXEC	dbo.uspMostHeardSongPerCountryFrom00TO08
GO

----- 17 Quais são as músicas mais ouvidas, por país, entre as 08:00 e as 16:00 ? 

EXEC	dbo.uspMostHeardSongPerCountryFrom08TO16
GO

----- 18 Qual o genero musical mais ouvido por país ? 

EXEC	dbo.uspMostHeardGenrePerCountry
GO

----- 19 Qual o genero musical mais ouvido por país, entre as 0000AM e as 08AM ? 

EXEC dbo.uspMostHeardGenrePerCountry00to08
GO

----- 20 Qual o genero musical mais ouvido por país, entre as 16:00 e as 24:00 ? 

EXEC	dbo.uspMostHeardGenrePerCountry16to24
GO