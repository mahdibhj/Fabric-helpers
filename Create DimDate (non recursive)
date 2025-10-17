-- Fabric Data WH doesn't support recursive tables, this code allows you to generate a dates dimension table directly by executing it as SQL Query

DECLARE @startdate DATE = '2000-01-01';
DECLARE @enddate   DATE = '2050-12-31';
 
DROP TABLE IF EXISTS dbo.DimDate;
CREATE TABLE dbo.DimDate
(
    DateKey INT NOT NULL,
    [Date] DATE NOT NULL,
    [Year] SMALLINT NOT NULL,
    MonthNumber INT NOT NULL,
    MonthName VARCHAR(20) NOT NULL, 
    QuarterNumber INT NOT NULL,
    QuarterName CHAR(2) NOT NULL,
    DayOfMonth INT NOT NULL,
    DayOfWeekNum INT NOT NULL, 
    DayOfWeekName VARCHAR(20) NOT NULL,
    WeekOfYear INT NOT NULL,
    IsWeekend BIT NOT NULL,
    LastDayOfMonth DATE NOT NULL
);
 
INSERT INTO dbo.DimDate
SELECT
    CAST(CONVERT(CHAR(8), d, 112) AS INT) AS DateKey,
    d AS [Date],
    YEAR(d) AS [Year],
    MONTH(d) AS MonthNumber,
    DATENAME(month, d) AS MonthName,
    DATEPART(quarter, d) AS QuarterNumber,
    CONCAT('Q', DATEPART(quarter, d)) AS QuarterName,
    DAY(d) AS DayOfMonth,
    DATEPART(weekday, d) AS DayOfWeekNum,
    DATENAME(weekday, d) AS DayOfWeekName,
    DATEPART(iso_week, d) AS WeekOfYear,
    CASE 
        WHEN (DATEDIFF(DAY, '2000-01-02', d) % 7) IN (5,6) THEN 1 ELSE 0 
    END AS IsWeekend,
    EOMONTH(d) AS LastDayOfMonth
FROM (
    SELECT DATEADD(DAY, ones.v + tens.v * 10 + hundreds.v * 100 + thousands.v * 1000 + ten_thousands.v * 10000, @startdate) AS d
    FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS ones(v)
    CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS tens(v)
    CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS hundreds(v)
    CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS thousands(v)
    CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS ten_thousands(v)
) AS T
WHERE d BETWEEN @startdate AND @enddate;
 
 
 
SELECT * FROM DimDate ORDER BY Date ASC ;
