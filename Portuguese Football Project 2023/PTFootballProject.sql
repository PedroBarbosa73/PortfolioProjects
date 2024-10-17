USE FUTEBOL

SELECT *
FROM Futebol$
WHERE HomeTeam ='Benfica'

SELECT *
FROM TEAMS

--CREATING VIEW FOR THE TEAMS

CREATE VIEW TEAMS AS

    SELECT HomeTeam AS Team
    FROM Futebol$
    UNION
    SELECT AwayTeam AS Team
    FROM Futebol$


SELECT [Date],HomeTeam,AwayTeam,FTHG,FTAG
FROM Futebol$
WHERE HomeTeam = 'BENFICA' 

--HOW MANY HOME MATCHES BENFICA/Porto/ Sporting/ BRAGA WON 


SELECT HomeTeam,
       NULLIF(COUNT(CASE WHEN HomeTeam = 'Benfica' AND FTR = 'H' THEN 1 END),0) AS BenficaHomeWins,
       NULLIF(COUNT(CASE WHEN HomeTeam = 'Porto' AND FTR = 'H' THEN 1 END),0) AS PortoHomeWins,
	   NULLIF(COUNT(CASE WHEN HomeTeam = 'Sp Lisbon' AND FTR = 'H' THEN 1 END),0) AS SportingHomeWins,
	   NULLIF(COUNT(CASE WHEN HomeTeam = 'Sp Braga' AND FTR = 'H' THEN 1 END),0) AS BragaHomeWins
FROM Futebol$
WHERE HomeTeam IN ('Benfica', 'Porto','Sp Lisbon','Sp Braga')
GROUP BY HomeTeam;

-- How MANY AWAY MATCHES THEY HAD

SELECT AwayTeam,
       NULLIF(COUNT(CASE WHEN AwayTeam = 'Benfica' AND FTR = 'A' THEN 1 END),0) AS BenficaAwayWins,
       NULLIF(COUNT(CASE WHEN AwayTeam = 'Porto' AND FTR = 'A' THEN 1 END),0) AS PortoAwayWins,
	   NULLIF(COUNT(CASE WHEN AwayTeam = 'Sp Lisbon' AND FTR = 'A' THEN 1 END),0) AS SportingAwayWins,
	   NULLIF(COUNT(CASE WHEN AwayTeam = 'Sp Braga' AND FTR = 'A' THEN 1 END),0) AS BragaAwayWins
FROM Futebol$
WHERE AwayTeam IN ('Benfica', 'Porto','Sp Lisbon','Sp Braga')
GROUP BY AwayTeam;

-- Both away and home wins for each team in the league

SELECT 
    Team,
    SUM(CASE WHEN HomeTeam = Team AND FTR = 'H' THEN 1 ELSE 0 END) AS HomeWins,
    SUM(CASE WHEN AwayTeam = Team AND FTR = 'A' THEN 1 ELSE 0 END) AS AwayWins

FROM TEAMS
LEFT JOIN Futebol$ AS F
    ON Teams.Team = F.HomeTeam OR Teams.Team = F.AwayTeam
GROUP BY 
    Team
ORDER BY 
    HomeWins DESC


-- TEAMS WITH MOST FOULS AND CARDS


	SELECT 
    T.Team,
    SUM(CASE WHEN F.HomeTeam = T.Team THEN HF ELSE AF END) AS 'TOTAL FOULS',
    SUM(CASE WHEN F.HomeTeam = T.Team THEN HY ELSE AY END) AS 'TOTAL YELLOWS',
    SUM(CASE WHEN F.HomeTeam = T.Team THEN HR ELSE AR END) AS 'TOTAL REDS'
FROM 
    TEAMS AS T
LEFT JOIN 
    Futebol$ AS F
    ON T.Team = F.HomeTeam OR T.Team = F.AwayTeam
GROUP BY 
    T.Team
ORDER BY 
    [TOTAL FOULS] DESC;



