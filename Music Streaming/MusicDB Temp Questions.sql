USE [MusicDB]

--------------- TEMP TABLE QUESTIONS ---------------


----- 21 Quais são as músicas mais ouvidas, por utilizador nos Estados Unidos da America? 

SELECT u,m,c from
(
SELECT 
	Username as 'u', 
	musicname as 'm',
	COUNT(*) as 'c',
	RANK() OVER (partition by username order by COUNT(*) DESC) as RANKE
FROM  
	##HistoryUSA
	GROUP BY Username,musicname
 ) as sub

 where RANKE=1 
 order by c desc
 GO
----- 22 Quais são as músicas mais ouvidas, por utilizador, entre as 08:00 e as 16:00 nos Estados Unidos da America ? 

SELECT u,m,c from
(
SELECT 
	Username as 'u', 
	musicname as 'm',
	COUNT(*) as 'c',
	RANK() OVER (partition by username order by COUNT(*) DESC) as RANKE
FROM  
	##HistoryUSA
	WHERE
			CAST(timelistened AS TIME) BETWEEN '08:00:00'
			AND '16:00:00'  
	GROUP BY Username,musicname
 
 ) as sub

 where RANKE=1 
 order by c desc
 GO


----- 23 Quais são as músicas mais ouvidas, por utilizador, entre as 16:00 e as 24:00 nos Estados Unidos da America  ?

SELECT u,m,c from
(
SELECT 
	Username as 'u', 
	musicname as 'm',
	COUNT(*) as 'c',
	RANK() OVER (partition by username order by COUNT(*) DESC) as RANKE
FROM  
	##HistoryUSA
	WHERE
			CAST(timelistened AS TIME) BETWEEN '16:00'
			AND '23:59:59.9999999'  or CAST(timelistened AS TIME)  = '00:00:00'
	GROUP BY Username,musicname
 
 ) as sub

 where RANKE=1 
 order by c desc
 GO



 --------------- @TABLE  QUESTIONS ---------------

 ----- 24 Quais são as músicas mais ouvidas
 ----- 25 Quais são as músicas menos ouvidas
 ----- 26 Quantas vezes foi ouvida a musica Enter Sandman em 2023
 DECLARE @TimeHeard TABLE (
    ID INT identity(1,1) NOT NULL Primary key,
    Musicname NVARCHAR(100),
    Timelistened datetime2
);

insert into @TimeHeard
SELECT m.musicname, mh.timelistened from musichistory as mh
JOIN music as m on m.musicid=mh.musicid

--SELECT Musicname,COUNT(*) from @TimeHeard group by musicname order by  musicname asc--COUNT(*) DESC -- 24

--SELECT Musicname,COUNT(*) from @TimeHeard group by musicname order by COUNT(*) ASC -- 25


SELECT Musicname,COUNT(*) FROM @TimeHeard WHERE musicname LIKE 'Enter Sandman' AND 
DATEPART(YEAR,timelistened) ='2023'
GROUP BY musicname 
