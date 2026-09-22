-- =============================================================================
-- RestaurantDB - Sample analytical queries
-- A grab bag of queries that exercise joins, aggregation, window functions
-- and the ISA-hierarchy views. Meant to be run interactively, not as a batch
-- that feeds an application.
-- =============================================================================

USE RestaurantDB;
GO

-- 1. Revenue and order count per restaurant chain.
SELECT
    r.RestaurantName,
    COUNT(DISTINCT o.OrderId) AS OrderCount,
    SUM(o.OrderPrice)         AS TotalRevenue
FROM dbo.Restaurant r
JOIN dbo.Branch b       ON b.RestaurantId = r.RestaurantId
JOIN dbo.BranchOrder bo ON bo.BranchId = b.BranchId
JOIN dbo.Orders o       ON o.OrderId = bo.OrderId
GROUP BY r.RestaurantName
ORDER BY TotalRevenue DESC;
GO

-- 2. Top 5 best-selling menu items by quantity.
EXEC dbo.usp_GetTopSellingItems @Top = 5;
GO

-- 3. Average employee salary by role (Manager / Chef / Waiter).
SELECT Role, COUNT(*) AS Headcount, AVG(Salary) AS AvgSalary
FROM dbo.vw_EmployeeDirectory
GROUP BY Role
ORDER BY AvgSalary DESC;
GO

-- 4. Customers ranked by total amount spent.
SELECT
    cu.CustomerId,
    cu.Name,
    COUNT(o.OrderId)   AS OrderCount,
    SUM(o.OrderPrice)  AS TotalSpent,
    RANK() OVER (ORDER BY SUM(o.OrderPrice) DESC) AS SpendRank
FROM dbo.Customer cu
JOIN dbo.OrderCustomer oc ON oc.CustomerId = cu.CustomerId
JOIN dbo.Orders o         ON o.OrderId = oc.OrderId
GROUP BY cu.CustomerId, cu.Name
ORDER BY TotalSpent DESC;
GO

-- 5. Menu items that have never appeared in an order.
SELECT ri.ItemId, ri.Name, r.RestaurantName
FROM dbo.RestaurantItem ri
JOIN dbo.Restaurant r ON r.RestaurantId = ri.RestaurantId
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.OrderItem oi WHERE oi.ItemId = ri.ItemId
);
GO

-- 6. Branch performance leaderboard.
SELECT * FROM dbo.vw_BranchRevenue ORDER BY TotalRevenue DESC;
GO

-- 7. Employees who are also point of contact for a family member on file.
SELECT e.Name AS Employee, fm.FamilyMember AS Relation, fm.Name AS RelativeName
FROM dbo.Employee e
JOIN dbo.FamilyMember fm ON fm.EmployeeId = e.EmployeeId
ORDER BY e.Name;
GO

-- 8. Full order history for a given customer (parameterized procedure).
EXEC dbo.usp_GetCustomerOrderHistory @CustomerId = 1;
GO
