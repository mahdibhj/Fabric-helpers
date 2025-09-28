
-- Activate CDC on DB
USE AdventureWorks2022
GO
EXEC sys.sp_cdc_enable_db;
GO


-- Check if CDC is active
SELECT is_cdc_enabled, name 
FROM sys.databases 
WHERE name = 'AdventureWorks2022';


-- Activate CDC on table
EXEC sys.sp_cdc_enable_table
    @source_schema = N'Sales',
    @source_name   = N'SalesOrderDetail',
    @role_name     = NULL;  
 

-- Update table
BEGIN TRAN;         
 
UPDATE Sales.SalesOrderDetail
SET    OrderQty     = 100,         
       ModifiedDate = SYSUTCDATETIME()  
WHERE  SalesOrderID       = 43659
  AND  SalesOrderDetailID = 1;
 
COMMIT;    


-- Check saved updates
DECLARE @from_lsn binary(10), @to_lsn binary(10);
SET @from_lsn = sys.fn_cdc_get_min_lsn('Sales_SalesOrderDetail');
SET @to_lsn   = sys.fn_cdc_get_max_lsn();
SELECT *
FROM cdc.fn_cdc_get_all_changes_Sales_SalesOrderDetail(@from_lsn, @to_lsn, 'all');



-- Disable on table
EXEC sys.sp_cdc_disable_table
    @source_schema = N'Sales',
    @source_name   = N'SalesOrderDetail',
    @capture_instance = 'Sales_SalesOrderDetail';



-- Disable CDC in database
EXEC sys.sp_cdc_disable_db;
