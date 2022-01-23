USE CorsoSQL

GO

CREATE TABLE Esperimenti(
IdEsperimento int NOT NULL PRIMARY KEY,
Data date NULL,
Operatore varchar(250) NULL,
Valore decimal(18, 6) NULL,
Molecola varchar(250) NULL,
)

GO

--Versione 1
CREATE VIEW dbo.ReportEsperimenti AS
WITH DatiPostMaggio AS (
	SELECT Operatore, AVG(Valore) AS ValoreMedio 
	FROM Esperimenti
	WHERE Data > '2020-05-01'
	GROUP BY Operatore),
	DatiPreMaggio AS (
	SELECT Operatore, AVG(Valore) AS ValoreMedio 
	FROM Esperimenti
	WHERE Data <= '2020-05-01'
	GROUP BY Operatore)
SELECT DatiPostMaggio.Operatore,
	DatiPostMaggio.ValoreMedio AS AVGPost,
	DatiPreMaggio.ValoreMedio AS AVGPre,
	(DatiPostMaggio.ValoreMedio -
	DatiPreMaggio.ValoreMedio) / abs(DatiPreMaggio.ValoreMedio) AS DiffPerc
FROM  DatiPostMaggio
INNER JOIN DatiPreMaggio
	ON DatiPostMaggio.Operatore = DatiPreMaggio.Operatore;


--Versione 2
CREATE VIEW dbo.ReportEsperimenti AS
WITH CTE AS (
	SELECT Operatore,
	AVG(CASE WHEN Data < '2019-05-01' THEN Valore ELSE NULL END) AS ValorePre,
	AVG(CASE WHEN Data >= '2019-05-01' THEN Valore ELSE NULL END) AS ValorePost
	FROM    Esperimenti
	WHERE Molecola LIKE 'AB%'
	GROUP BY  Operatore)
SELECT Operatore,
	ValorePre,
	ValorePost,
	(ValorePost - ValorePre) / abs(ValorePre) AS DiffPerc
FROM   CTE;

/* Prove di esecuzione

Exec dbo.CaricaEsperimenti
GO
SELECT * FROM ReportEsperimenti

*/