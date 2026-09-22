-- =============================================================================
-- RestaurantDB - Database creation
-- Target: Microsoft SQL Server 2019+
-- =============================================================================

IF DB_ID(N'RestaurantDB') IS NULL
BEGIN
    CREATE DATABASE RestaurantDB;
END
GO

ALTER DATABASE RestaurantDB SET COMPATIBILITY_LEVEL = 150;
GO

USE RestaurantDB;
GO
