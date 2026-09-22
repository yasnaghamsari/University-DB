-- =============================================================================
-- RestaurantDB - Sample data
--
-- Note: the OrderCustomer sample rows in the original project referenced
-- CustomerId values (101-110) that did not exist in the Customer table.
-- Here every OrderCustomer row points at a real CustomerId, and OrderItem
-- rows (a table that did not previously exist) show which items made up
-- each order.
-- =============================================================================

USE RestaurantDB;
GO

-- Restaurant
INSERT INTO dbo.Restaurant (RestaurantId, RestaurantName) VALUES
    (100,  N'McDonald'),
    (200,  N'KFC'),
    (300,  N'Barouj'),
    (400,  N'Shamshiri'),
    (500,  N'AkbarJooje'),
    (600,  N'Subway'),
    (700,  N'Burger King'),
    (800,  N'Shila'),
    (900,  N'Starbucks'),
    (1000, N'Pizza Hut');
GO

-- Branch
INSERT INTO dbo.Branch (BranchId, BranchAddress, RestaurantId) VALUES
    (1000, N'707 Chestnut Ave, Hilltop',      1000),
    (1200, N'123 Main St, City Center',       100),
    (2000, N'456 Oak Rd, Downtown',           200),
    (3000, N'789 Pine Ave, North Side',       300),
    (4000, N'101 Maple Dr, East Village',     400),
    (5000, N'202 Birch Ln, West End',         500),
    (6000, N'303 Cedar Blvd, Riverfront',     600),
    (7000, N'404 Elm St, Central Park',       700),
    (8000, N'505 Willow Way, Lakeside',       800),
    (9000, N'606 Redwood St, South Shore',    900);
GO

-- Employee
INSERT INTO dbo.Employee (EmployeeId, Name, BDate, Salary, Age, BranchId) VALUES
    (1,  N'Ali Soleimani',       '1990-05-12', 4500.00, 34, 1200),
    (2,  N'Yasna Ghamsari',      '1985-08-22', 5500.00, 39, 2000),
    (3,  N'Sima Noori',          '1992-02-10', 4800.00, 32, 3000),
    (4,  N'Reza Mohammadi',      '1980-03-25', 6200.00, 44, 4000),
    (5,  N'Maryam Karimi',       '1995-12-15', 4100.00, 29, 5000),
    (6,  N'Hossein Jafari',      '1993-11-07', 5300.00, 31, 6000),
    (7,  N'Sara Tavakkol',       '1990-07-18', 4600.00, 34, 7000),
    (8,  N'Amir Hossein Rahimi', '1988-01-29', 5900.00, 36, 8000),
    (9,  N'Niloofar Rezaei',     '1994-10-30', 4700.00, 30, 9000),
    (10, N'Fazel Khademi',       '1987-09-04', 6000.00, 37, 1000),
    (11, N'Nima Ahmadpour',      '1987-05-15', 4900.00, 37, 1200),
    (12, N'Parisa Kiani',        '1992-11-25', 4100.00, 32, 2000),
    (13, N'Sina Hashemi',        '1990-02-10', 5300.00, 34, 3000),
    (14, N'Shirin Rezaei',       '1984-08-30', 6200.00, 40, 4000),
    (15, N'Kian Tavassoli',      '1995-03-22', 4700.00, 29, 5000),
    (16, N'Elham Ghorbani',      '1993-06-18', 5500.00, 31, 6000),
    (17, N'Saeed Mahdavi',       '1989-12-05', 4900.00, 35, 7000),
    (18, N'Haniyeh Rezaei',      '1986-04-12', 6000.00, 38, 8000),
    (19, N'Mehrdad Esmaeili',    '1991-10-20', 4600.00, 33, 9000),
    (20, N'Fariba Shahbazi',     '1988-07-07', 5200.00, 39, 1000);
GO

-- Manager (EmployeeId 1-10)
INSERT INTO dbo.Manager (EmployeeId, BusinessSkills) VALUES
    (1,  N'Leadership'),
    (2,  N'Project Management'),
    (3,  N'Team Building'),
    (4,  N'Financial Planning'),
    (5,  N'Customer Relationship'),
    (6,  N'Operations Management'),
    (7,  N'Human Resources'),
    (8,  N'Public Speaking'),
    (9,  N'Innovation'),
    (10, N'Data Analysis');
GO

-- Waiter (EmployeeId 11,12,13,15,19)
INSERT INTO dbo.Waiter (EmployeeId, SocialSkills) VALUES
    (11, N'Excellent communication'),
    (12, N'Customer-focused'),
    (13, N'Stress management'),
    (15, N'Multitasking'),
    (19, N'Team-oriented');
GO

-- Chef (EmployeeId 14,16,17,18,20)
INSERT INTO dbo.Chef (EmployeeId, Speed) VALUES
    (14, N'Quick'),
    (16, N'Very quick'),
    (17, N'Quick'),
    (18, N'Very quick'),
    (20, N'Slow');
GO

-- FamilyMember
INSERT INTO dbo.FamilyMember (EmployeeId, FamilyMember, Name) VALUES
    (11, N'Father', N'Ali Ahmadpour'),
    (12, N'Mother', N'Zahra Kiani'),
    (13, N'Father', N'Mohammad Hashemi'),
    (14, N'Mother', N'Fatemeh Rezaei'),
    (15, N'Father', N'Ahmad Tavassoli'),
    (16, N'Mother', N'Ladan Ghorbani'),
    (17, N'Father', N'Reza Mahdavi');
GO

-- Customer
INSERT INTO dbo.Customer (CustomerId, Name, Address, PhoneNo) VALUES
    (1,  N'Ali Rezaei',           N'No. 12, Vali Asr Street, Tehran, Iran',       9123456789),
    (2,  N'Mahnaz Farahani',      N'Apt. 5, Kianabad Blvd., Shiraz, Iran',        9139876543),
    (3,  N'Sara Tavakkol',        N'Building 4, Golestan St., Isfahan, Iran',     9121112233),
    (4,  N'Amir Hossein Rahimi',  N'No. 7, Imam Reza Ave., Mashhad, Iran',        9141234567),
    (5,  N'Niloofar Rezaei',      N'Block C, Kerman St., Kerman, Iran',           9152345678),
    (6,  N'Reza Mohammadi',       N'Villa 9, Azadi Square, Tehran, Iran',         9163456789),
    (7,  N'Fazel Khademi',        N'No. 22, Chaharbagh St., Shiraz, Iran',        9174567890),
    (8,  N'Maryam Karimi',        N'Apartment 23, Imam Ali Blvd., Tabriz, Iran',  9185678901),
    (9,  N'Hossein Jafari',       N'Unit 10, Qom St., Qom, Iran',                 9196789012),
    (10, N'Sima Noori',           N'House No. 56, Shariati St., Ahvaz, Iran',     9207890123);
GO

-- RestaurantItem
INSERT INTO dbo.RestaurantItem (ItemId, Name, Price, RestaurantId) VALUES
    (1,  N'Pizza',        8.99,  100),
    (2,  N'Spaghetti',    12.50, 200),
    (3,  N'Pasta',        6.99,  500),
    (4,  N'Kebab',        9.75,  400),
    (5,  N'Coca',         7.49,  700),
    (6,  N'Fanta',        15.99, 300),
    (7,  N'Beef',         18.50, 900),
    (8,  N'Jooje',        5.99,  400),
    (9,  N'GhormeSabzi',  3.49,  500),
    (10, N'Doogh',        4.99,  600);
GO

-- Food (ItemId 1,2,3 = FastFood; 4,7,8,9 = Irani)
INSERT INTO dbo.Food (ItemId, Category) VALUES
    (1, N'FastFood'),
    (2, N'FastFood'),
    (3, N'FastFood'),
    (4, N'Irani'),
    (7, N'Irani'),
    (8, N'Irani'),
    (9, N'Irani');
GO

-- Beverage (ItemId 5,6,10 = Cold)
INSERT INTO dbo.Beverage (ItemId, Type) VALUES
    (5,  N'Cold'),
    (6,  N'Cold'),
    (10, N'Cold');
GO

-- Receipt
INSERT INTO dbo.Receipt (ReceiptId, PaymentMethod, TotalPrice) VALUES
    (1,  N'Credit Card', 120.50),
    (2,  N'Cash',        80.00),
    (3,  N'Debit Card',  150.75),
    (4,  N'Credit Card', 200.00),
    (5,  N'Cash',        55.30),
    (6,  N'Debit Card',  99.90),
    (7,  N'Credit Card', 120.00),
    (8,  N'Cash',        300.50),
    (9,  N'Debit Card',  45.25),
    (10, N'Credit Card', 220.60);
GO

-- Orders
INSERT INTO dbo.Orders (OrderId, OrderPrice, ReceiptId) VALUES
    (1,  50.00,  1),
    (2,  30.00,  2),
    (3,  75.00,  3),
    (4,  100.00, 4),
    (5,  45.00,  5),
    (6,  65.00,  6),
    (7,  80.00,  7),
    (8,  150.00, 8),
    (9,  40.00,  9),
    (10, 90.00,  10);
GO

-- OrderItem: which menu items (and how many) made up each order
INSERT INTO dbo.OrderItem (OrderId, ItemId, Quantity) VALUES
    (1,  1, 2),   -- 2x Pizza
    (1,  5, 1),   -- 1x Coca
    (2,  2, 1),   -- 1x Spaghetti
    (3,  6, 2),   -- 2x Fanta
    (3,  4, 1),   -- 1x Kebab
    (4,  4, 2),   -- 2x Kebab
    (4,  8, 2),   -- 2x Jooje
    (5,  3, 1),   -- 1x Pasta
    (5,  9, 2),   -- 2x GhormeSabzi
    (6,  10, 3),  -- 3x Doogh
    (7,  5, 2),   -- 2x Coca
    (8,  7, 3),   -- 3x Beef
    (8,  6, 1),   -- 1x Fanta
    (9,  9, 1),   -- 1x GhormeSabzi
    (10, 1, 1),   -- 1x Pizza
    (10, 2, 1);   -- 1x Spaghetti
GO

-- BranchOrder
INSERT INTO dbo.BranchOrder (BranchId, OrderId) VALUES
    (1000, 10),
    (1200, 1),
    (2000, 2),
    (3000, 3),
    (4000, 4),
    (5000, 5),
    (6000, 6),
    (7000, 7),
    (8000, 8),
    (9000, 9);
GO

-- OrderCustomer (fixed to reference real CustomerId values)
INSERT INTO dbo.OrderCustomer (OrderId, CustomerId) VALUES
    (1,  1),
    (2,  2),
    (3,  3),
    (4,  4),
    (5,  5),
    (6,  6),
    (7,  7),
    (8,  8),
    (9,  9),
    (10, 10);
GO
