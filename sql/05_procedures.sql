-- =============================================================================
-- RestaurantDB - Stored procedures
-- =============================================================================

USE RestaurantDB;
GO

-- Revenue and order count for a single branch.
CREATE OR ALTER PROCEDURE dbo.usp_GetBranchRevenue
    @BranchId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Branch WHERE BranchId = @BranchId)
    BEGIN
        RAISERROR(N'Branch %d does not exist.', 16, 1, @BranchId);
        RETURN;
    END

    SELECT *
    FROM dbo.vw_BranchRevenue
    WHERE BranchId = @BranchId;
END
GO

-- Full order history for a customer, most recent first (by OrderId).
CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerOrderHistory
    @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Customer WHERE CustomerId = @CustomerId)
    BEGIN
        RAISERROR(N'Customer %d does not exist.', 16, 1, @CustomerId);
        RETURN;
    END

    SELECT
        o.OrderId,
        o.OrderPrice,
        rec.PaymentMethod,
        vs.RestaurantName,
        vs.ItemCount
    FROM dbo.Orders o
    JOIN dbo.OrderCustomer oc  ON oc.OrderId = o.OrderId
    JOIN dbo.Receipt rec       ON rec.ReceiptId = o.ReceiptId
    JOIN dbo.vw_OrderSummary vs ON vs.OrderId = o.OrderId
    WHERE oc.CustomerId = @CustomerId
    ORDER BY o.OrderId DESC;
END
GO

-- Top-N best selling items by quantity across all orders.
CREATE OR ALTER PROCEDURE dbo.usp_GetTopSellingItems
    @Top INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@Top)
        ri.ItemId,
        ri.Name,
        r.RestaurantName,
        SUM(oi.Quantity)                   AS UnitsSold,
        SUM(oi.Quantity * ri.Price)        AS Revenue
    FROM dbo.OrderItem oi
    JOIN dbo.RestaurantItem ri ON ri.ItemId = oi.ItemId
    JOIN dbo.Restaurant r      ON r.RestaurantId = ri.RestaurantId
    GROUP BY ri.ItemId, ri.Name, r.RestaurantName
    ORDER BY UnitsSold DESC;
END
GO

-- Registers a new customer and returns the generated row.
CREATE OR ALTER PROCEDURE dbo.usp_AddCustomer
    @CustomerId INT,
    @Name       VARCHAR(100),
    @Address    VARCHAR(255),
    @PhoneNo    BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.Customer WHERE CustomerId = @CustomerId)
    BEGIN
        RAISERROR(N'Customer %d already exists.', 16, 1, @CustomerId);
        RETURN;
    END

    INSERT INTO dbo.Customer (CustomerId, Name, Address, PhoneNo)
    VALUES (@CustomerId, @Name, @Address, @PhoneNo);

    SELECT * FROM dbo.Customer WHERE CustomerId = @CustomerId;
END
GO
