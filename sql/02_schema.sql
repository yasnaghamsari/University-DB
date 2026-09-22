-- =============================================================================
-- RestaurantDB - Schema definition
--
-- Design notes / improvements over the original coursework version:
--   * Added dbo.OrderItem as a proper associative table between Orders and
--     RestaurantItem (with Quantity). The original model let an Order carry
--     a total price with no record of which items were actually ordered.
--   * Added the missing foreign keys on dbo.OrderCustomer (it previously had
--     no referential integrity to Orders or Customer at all).
--   * Added CHECK constraints for prices/quantities and indexes on every
--     foreign key column that isn't already covered by a primary key.
--   * ISA hierarchies (Employee -> Manager/Chef/Waiter, RestaurantItem ->
--     Food/Beverage) are modeled as one-to-one "sub-type" tables sharing the
--     parent's primary key, cascading on delete.
-- =============================================================================

USE RestaurantDB;
GO

-- -----------------------------------------------------------------------------
-- Restaurant / Branch
-- -----------------------------------------------------------------------------
CREATE TABLE dbo.Restaurant
(
    RestaurantId    INT             NOT NULL,
    RestaurantName  VARCHAR(100)    NOT NULL,
    CONSTRAINT pk_Restaurant PRIMARY KEY CLUSTERED (RestaurantId)
);
GO

CREATE TABLE dbo.Branch
(
    BranchId        INT             NOT NULL,
    BranchAddress   VARCHAR(255)    NOT NULL,
    RestaurantId    INT             NOT NULL,
    CONSTRAINT pk_Branch PRIMARY KEY CLUSTERED (BranchId),
    CONSTRAINT fk_Branch_Restaurant FOREIGN KEY (RestaurantId)
        REFERENCES dbo.Restaurant (RestaurantId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

CREATE INDEX ix_Branch_RestaurantId ON dbo.Branch (RestaurantId);
GO

-- -----------------------------------------------------------------------------
-- Employee and its ISA sub-types (Manager / Chef / Waiter)
-- -----------------------------------------------------------------------------
CREATE TABLE dbo.Employee
(
    EmployeeId  INT             NOT NULL,
    Name        VARCHAR(100)    NOT NULL,
    BDate       DATE            NULL,
    Salary      DECIMAL(10, 2)  NOT NULL,
    Age         INT             NOT NULL,
    BranchId    INT             NOT NULL,
    CONSTRAINT pk_Employee PRIMARY KEY CLUSTERED (EmployeeId),
    CONSTRAINT fk_Employee_Branch FOREIGN KEY (BranchId)
        REFERENCES dbo.Branch (BranchId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_Employee_Age CHECK (Age > 0),
    CONSTRAINT ck_Employee_Salary CHECK (Salary > 0)
);
GO

CREATE INDEX ix_Employee_BranchId ON dbo.Employee (BranchId);
GO

CREATE TABLE dbo.Manager
(
    EmployeeId      INT             NOT NULL,
    BusinessSkills  VARCHAR(255)    NULL,
    CONSTRAINT pk_Manager PRIMARY KEY CLUSTERED (EmployeeId),
    CONSTRAINT fk_Manager_Employee FOREIGN KEY (EmployeeId)
        REFERENCES dbo.Employee (EmployeeId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Chef
(
    EmployeeId  INT             NOT NULL,
    Speed       VARCHAR(255)    NULL,
    CONSTRAINT pk_Chef PRIMARY KEY CLUSTERED (EmployeeId),
    CONSTRAINT fk_Chef_Employee FOREIGN KEY (EmployeeId)
        REFERENCES dbo.Employee (EmployeeId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Waiter
(
    EmployeeId      INT             NOT NULL,
    SocialSkills    VARCHAR(255)    NULL,
    CONSTRAINT pk_Waiter PRIMARY KEY CLUSTERED (EmployeeId),
    CONSTRAINT fk_Waiter_Employee FOREIGN KEY (EmployeeId)
        REFERENCES dbo.Employee (EmployeeId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

CREATE TABLE dbo.FamilyMember
(
    EmployeeId      INT             NOT NULL,
    FamilyMember    VARCHAR(100)    NOT NULL,  -- relation, e.g. Father / Mother
    Name            VARCHAR(100)    NOT NULL,
    CONSTRAINT pk_FamilyMember PRIMARY KEY CLUSTERED (EmployeeId, FamilyMember),
    CONSTRAINT fk_FamilyMember_Employee FOREIGN KEY (EmployeeId)
        REFERENCES dbo.Employee (EmployeeId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- -----------------------------------------------------------------------------
-- Customer
-- -----------------------------------------------------------------------------
CREATE TABLE dbo.Customer
(
    CustomerId  INT             NOT NULL,
    Name        VARCHAR(100)    NULL,
    Address     VARCHAR(255)    NULL,
    PhoneNo     BIGINT          NULL,
    CONSTRAINT pk_Customer PRIMARY KEY CLUSTERED (CustomerId)
);
GO

-- -----------------------------------------------------------------------------
-- RestaurantItem and its ISA sub-types (Food / Beverage)
-- -----------------------------------------------------------------------------
CREATE TABLE dbo.RestaurantItem
(
    ItemId          INT             NOT NULL,
    Name            VARCHAR(100)    NOT NULL,
    Price           DECIMAL(10, 2)  NOT NULL,
    RestaurantId    INT             NOT NULL,
    CONSTRAINT pk_RestaurantItem PRIMARY KEY CLUSTERED (ItemId),
    CONSTRAINT fk_RestaurantItem_Restaurant FOREIGN KEY (RestaurantId)
        REFERENCES dbo.Restaurant (RestaurantId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_RestaurantItem_Price CHECK (Price > 0)
);
GO

CREATE INDEX ix_RestaurantItem_RestaurantId ON dbo.RestaurantItem (RestaurantId);
GO

CREATE TABLE dbo.Food
(
    ItemId      INT             NOT NULL,
    Category    VARCHAR(100)    NOT NULL,
    CONSTRAINT pk_Food PRIMARY KEY CLUSTERED (ItemId),
    CONSTRAINT fk_Food_RestaurantItem FOREIGN KEY (ItemId)
        REFERENCES dbo.RestaurantItem (ItemId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Beverage
(
    ItemId  INT             NOT NULL,
    Type    VARCHAR(100)    NOT NULL,
    CONSTRAINT pk_Beverage PRIMARY KEY CLUSTERED (ItemId),
    CONSTRAINT fk_Beverage_RestaurantItem FOREIGN KEY (ItemId)
        REFERENCES dbo.RestaurantItem (ItemId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- -----------------------------------------------------------------------------
-- Receipt / Orders / OrderItem
-- -----------------------------------------------------------------------------
CREATE TABLE dbo.Receipt
(
    ReceiptId       INT             NOT NULL,
    PaymentMethod   VARCHAR(50)     NULL,
    TotalPrice      DECIMAL(10, 2)  NULL,
    CONSTRAINT pk_Receipt PRIMARY KEY CLUSTERED (ReceiptId),
    CONSTRAINT ck_Receipt_TotalPrice CHECK (TotalPrice IS NULL OR TotalPrice >= 0)
);
GO

CREATE TABLE dbo.Orders
(
    OrderId     INT             NOT NULL,
    OrderPrice  DECIMAL(10, 2)  NOT NULL,
    ReceiptId   INT             NOT NULL,
    CONSTRAINT pk_Orders PRIMARY KEY CLUSTERED (OrderId),
    CONSTRAINT fk_Order_Receipt FOREIGN KEY (ReceiptId)
        REFERENCES dbo.Receipt (ReceiptId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_Orders_OrderPrice CHECK (OrderPrice >= 0)
);
GO

CREATE INDEX ix_Orders_ReceiptId ON dbo.Orders (ReceiptId);
GO

-- Associative table: which items (and how many) were part of an order.
-- This did not exist in the original design.
CREATE TABLE dbo.OrderItem
(
    OrderId     INT             NOT NULL,
    ItemId      INT             NOT NULL,
    Quantity    INT             NOT NULL CONSTRAINT df_OrderItem_Quantity DEFAULT (1),
    CONSTRAINT pk_OrderItem PRIMARY KEY CLUSTERED (OrderId, ItemId),
    CONSTRAINT fk_OrderItem_Order FOREIGN KEY (OrderId)
        REFERENCES dbo.Orders (OrderId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_OrderItem_RestaurantItem FOREIGN KEY (ItemId)
        REFERENCES dbo.RestaurantItem (ItemId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    CONSTRAINT ck_OrderItem_Quantity CHECK (Quantity > 0)
);
GO

CREATE INDEX ix_OrderItem_ItemId ON dbo.OrderItem (ItemId);
GO

-- -----------------------------------------------------------------------------
-- Junctions: which branch placed an order, which customer(s) placed an order
-- -----------------------------------------------------------------------------
CREATE TABLE dbo.BranchOrder
(
    BranchId    INT NOT NULL,
    OrderId     INT NOT NULL,
    CONSTRAINT pk_BranchOrder PRIMARY KEY CLUSTERED (BranchId, OrderId),
    CONSTRAINT fk_BranchOrder_Branch FOREIGN KEY (BranchId)
        REFERENCES dbo.Branch (BranchId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_BranchOrder_Order FOREIGN KEY (OrderId)
        REFERENCES dbo.Orders (OrderId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

CREATE INDEX ix_BranchOrder_OrderId ON dbo.BranchOrder (OrderId);
GO

CREATE TABLE dbo.OrderCustomer
(
    OrderId     INT NOT NULL,
    CustomerId  INT NOT NULL,
    CONSTRAINT pk_OrderCustomer PRIMARY KEY CLUSTERED (OrderId, CustomerId),
    CONSTRAINT fk_OrderCustomer_Order FOREIGN KEY (OrderId)
        REFERENCES dbo.Orders (OrderId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_OrderCustomer_Customer FOREIGN KEY (CustomerId)
        REFERENCES dbo.Customer (CustomerId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

CREATE INDEX ix_OrderCustomer_CustomerId ON dbo.OrderCustomer (CustomerId);
GO
