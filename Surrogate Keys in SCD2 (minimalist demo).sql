-- Create DimCustomer Table
CREATE TABLE dbo.DimCustomer (
    CustomerSK   INT IDENTITY(1,1) PRIMARY KEY,   -- Surrogate Key
    CustomerBK   VARCHAR(50)      NOT NULL,       -- Business Key (original ID)
    CustomerName VARCHAR(100)     NOT NULL,
    City         VARCHAR(50)      NOT NULL,       -- Current row of historisation start date
    StartDate    DATE             NOT NULL,
    EndDate      DATE             NULL,           -- NULL = current row of historisation end date
    IsCurrent    BIT              NOT NULL
);



-- Manual insert into DimCustomer
INSERT INTO dbo.DimCustomer
  (CustomerBK, CustomerName, City, StartDate, EndDate, IsCurrent)
VALUES
  ('C001','Alice Lee','Montreal','2025-10-01',NULL,1),
  ('C002','Bob Roy'  ,'Quebec'  ,'2025-10-01',NULL,1);

SELECT * FROM dbo.DimCustomer;

-- Attribute change example ; Alice Leaves Montreal
UPDATE dbo.DimCustomer
SET   EndDate   = '2025-10-05',
      IsCurrent = 0
WHERE CustomerBK = 'C001' AND IsCurrent = 1;

SELECT * FROM dbo.DimCustomer;

-- New change record : Alice moves to Toronto
INSERT INTO dbo.DimCustomer
  (CustomerBK, CustomerName, City, StartDate, EndDate, IsCurrent)
VALUES
  ('C001','Alice Lee','Toronto','2025-10-06',NULL,1);

SELECT * FROM dbo.DimCustomer;

-- Creating FactSales table
CREATE TABLE dbo.FactSales (
    SaleDate   DATE,
    CustomerSK INT NOT NULL,
    Amount     DECIMAL(12,2)
);

SELECT * FROM dbo.FactSales;

-- Insert with considering the dates when choosing Surrogate Key
INSERT INTO dbo.FactSales (SaleDate, CustomerSK, Amount) VALUES
  ('2025-10-03', 1, 120.00),   -- Alice in Montréal
  ('2025-10-04', 2,  75.00),   -- Bob in Québec
  ('2025-10-07', 3, 210.00),   -- Alice now in Toronto
  ('2025-10-09', 2,  60.00);   -- Bob again

SELECT * FROM dbo.FactSales;



-- To report each sale with the attributes that were true on the day of the sale, you simply join on the surrogate key
SELECT
	d.CustomerBK,
	d.CustomerSK,
    f.SaleDate,
    d.CustomerName,
    d.City,
    f.Amount
FROM dbo.FactSales AS f
LEFT JOIN dbo.DimCustomer AS d
  ON f.CustomerSK = d.CustomerSK
ORDER BY f.SaleDate;


