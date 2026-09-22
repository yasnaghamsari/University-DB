-- =============================================================================
-- RestaurantDB - Views
-- =============================================================================

USE RestaurantDB;
GO

-- Every employee with their role and role-specific attribute, resolved from
-- the Manager / Chef / Waiter ISA sub-types.
CREATE OR ALTER VIEW dbo.vw_EmployeeDirectory
AS
    SELECT
        e.EmployeeId,
        e.Name,
        e.BDate,
        e.Salary,
        e.Age,
        b.BranchId,
        b.BranchAddress,
        r.RestaurantName,
        CASE
            WHEN m.EmployeeId IS NOT NULL THEN N'Manager'
            WHEN c.EmployeeId IS NOT NULL THEN N'Chef'
            WHEN w.EmployeeId IS NOT NULL THEN N'Waiter'
            ELSE N'Unassigned'
        END AS Role,
        COALESCE(m.BusinessSkills, c.Speed, w.SocialSkills) AS RoleAttribute
    FROM dbo.Employee e
    JOIN dbo.Branch b       ON b.BranchId = e.BranchId
    JOIN dbo.Restaurant r   ON r.RestaurantId = b.RestaurantId
    LEFT JOIN dbo.Manager m ON m.EmployeeId = e.EmployeeId
    LEFT JOIN dbo.Chef c    ON c.EmployeeId = e.EmployeeId
    LEFT JOIN dbo.Waiter w  ON w.EmployeeId = e.EmployeeId;
GO

-- Every menu item with its resolved Food/Beverage sub-type label.
CREATE OR ALTER VIEW dbo.vw_MenuItem
AS
    SELECT
        ri.ItemId,
        ri.Name,
        ri.Price,
        ri.RestaurantId,
        r.RestaurantName,
        CASE
            WHEN f.ItemId IS NOT NULL THEN N'Food'
            WHEN bv.ItemId IS NOT NULL THEN N'Beverage'
            ELSE N'Other'
        END AS ItemKind,
        COALESCE(f.Category, bv.Type) AS SubCategory
    FROM dbo.RestaurantItem ri
    JOIN dbo.Restaurant r    ON r.RestaurantId = ri.RestaurantId
    LEFT JOIN dbo.Food f     ON f.ItemId = ri.ItemId
    LEFT JOIN dbo.Beverage bv ON bv.ItemId = ri.ItemId;
GO

-- One row per order: branch, restaurant, customers, receipt and line-item count.
CREATE OR ALTER VIEW dbo.vw_OrderSummary
AS
    SELECT
        o.OrderId,
        o.OrderPrice,
        rec.ReceiptId,
        rec.PaymentMethod,
        rec.TotalPrice,
        b.BranchId,
        r.RestaurantId,
        r.RestaurantName,
        STRING_AGG(CAST(cu.Name AS NVARCHAR(MAX)), N', ') AS Customers,
        (SELECT SUM(oi.Quantity) FROM dbo.OrderItem oi WHERE oi.OrderId = o.OrderId) AS ItemCount
    FROM dbo.Orders o
    JOIN dbo.Receipt rec        ON rec.ReceiptId = o.ReceiptId
    JOIN dbo.BranchOrder bo     ON bo.OrderId = o.OrderId
    JOIN dbo.Branch b           ON b.BranchId = bo.BranchId
    JOIN dbo.Restaurant r       ON r.RestaurantId = b.RestaurantId
    LEFT JOIN dbo.OrderCustomer oc ON oc.OrderId = o.OrderId
    LEFT JOIN dbo.Customer cu      ON cu.CustomerId = oc.CustomerId
    GROUP BY o.OrderId, o.OrderPrice, rec.ReceiptId, rec.PaymentMethod, rec.TotalPrice,
             b.BranchId, r.RestaurantId, r.RestaurantName;
GO

-- Revenue and order volume per branch.
CREATE OR ALTER VIEW dbo.vw_BranchRevenue
AS
    SELECT
        b.BranchId,
        b.BranchAddress,
        r.RestaurantId,
        r.RestaurantName,
        COUNT(o.OrderId)           AS OrderCount,
        SUM(o.OrderPrice)          AS TotalRevenue,
        AVG(o.OrderPrice)          AS AverageOrderValue
    FROM dbo.Branch b
    JOIN dbo.Restaurant r   ON r.RestaurantId = b.RestaurantId
    LEFT JOIN dbo.BranchOrder bo ON bo.BranchId = b.BranchId
    LEFT JOIN dbo.Orders o       ON o.OrderId = bo.OrderId
    GROUP BY b.BranchId, b.BranchAddress, r.RestaurantId, r.RestaurantName;
GO
