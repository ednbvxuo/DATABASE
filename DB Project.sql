CREATE DATABASE Telecom_Team_4;
GO

USE Telecom_Team_4;
GO

CREATE PROCEDURE createAllTables AS
BEGIN
    CREATE TABLE Customer_profile (
        nationalID INT PRIMARY KEY,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        email VARCHAR(50),
        address VARCHAR(50),
        date_of_birth DATE
    );

    CREATE TABLE Customer_Account (
        mobileNo CHAR(11) PRIMARY KEY,
        pass VARCHAR(50),
        balance DECIMAL(10,1),
        account_type VARCHAR(50) CHECK (account_type IN ('Post Paid', 'Prepaid', 'Pay_as_you_go')),
        start_date DATE,
        status VARCHAR(50) CHECK (status IN ('active', 'onhold')),
        point INT DEFAULT 0,
        nationalID INT,
        FOREIGN KEY (nationalID) REFERENCES Customer_profile(nationalID)
    );

    CREATE TABLE Service_Plan (
        planID INT IDENTITY(1,1) PRIMARY KEY,
        SMS_offered INT,
        minutes_offered INT,
        data_offered INT,
        name VARCHAR(50),
        price INT,
        description VARCHAR(50)
    );

    CREATE TABLE Subscription (
        mobileNo CHAR(11),
        planID INT,
        subscription_date DATE,
        status VARCHAR(50) CHECK (status IN ('active', 'onhold')),
        PRIMARY KEY (mobileNo, planID),
        FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo),
        FOREIGN KEY (planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Plan_Usage (
        usageID INT IDENTITY(1,1) PRIMARY KEY,
        start_date DATE,
        end_date DATE,
        data_consumption INT,
        minutes_used INT,
        SMS_sent INT,
        mobileNo CHAR(11),
        planID INT,
        FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo),
        FOREIGN KEY (planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Payment (
        paymentID INT IDENTITY(1,1) PRIMARY KEY,
        amount DECIMAL(10,1),
        date_of_payment DATE,
        payment_method VARCHAR(50) CHECK (payment_method IN ('cash', 'credit')),
        status VARCHAR(50) CHECK (status IN ('successful', 'pending', 'rejected')),
        mobileNo CHAR(11),
        FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo)
    );

    CREATE TABLE Process_Payment (
        paymentID INT,
        planID INT,
        remaining_balance DECIMAL(10, 2),
        extra_amount DECIMAL(10, 2),
        PRIMARY KEY (paymentID, planID),
        FOREIGN KEY (paymentID) REFERENCES Payment(paymentID),
        FOREIGN KEY (planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Wallet (
        walletID INT IDENTITY(1,1) PRIMARY KEY,
        current_balance DECIMAL(10,2),
        currency VARCHAR(50),
        last_modified_date DATE,
        nationalID INT,
        mobileNo CHAR(11),
        FOREIGN KEY (nationalID) REFERENCES Customer_profile(nationalID)
    );

    CREATE TABLE Transfer_money (
        walletID1 INT,
        walletID2 INT,
        transfer_id INT IDENTITY(1,1) PRIMARY KEY,
        amount DECIMAL(10,2),
        transfer_date DATE,
        FOREIGN KEY (walletID1) REFERENCES Wallet(walletID),
        FOREIGN KEY (walletID2) REFERENCES Wallet(walletID)
    );

    CREATE TABLE Benefits (
        benefitID INT IDENTITY(1,1) PRIMARY KEY,
        description VARCHAR(50),
        validity_date DATE,
        status VARCHAR(50) CHECK (status IN ('active', 'expired')),
        mobileNo CHAR(11),
        FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo)
    );

    CREATE TABLE Points_Group (
        pointID INT IDENTITY(1,1),
        benefitID INT,
        pointsAmount INT,
        PaymentID INT,
        PRIMARY KEY (pointID, benefitID),
        FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
        FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
    );

    CREATE TABLE Exclusive_Offer (
        offerID INT IDENTITY(1,1),
        benefitID INT,
        internet_offered INT,
        SMS_offered INT,
        minutes_offered INT,
        PRIMARY KEY (offerID, benefitID),
        FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID)
    );

    CREATE TABLE Cashback (
        CashbackID INT IDENTITY(1,1) PRIMARY KEY,
        benefitID INT,
        walletID INT,
        amount INT,
        credit_date DATE,
        FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
        FOREIGN KEY (walletID) REFERENCES Wallet(walletID)
    );

    CREATE TABLE Plan_Provides_Benefits (
        benefitID INT,
        planID INT,
        PRIMARY KEY (planID, benefitID),
        FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
        FOREIGN KEY (planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Shop (
        shopID INT IDENTITY(1,1) PRIMARY KEY,
        name VARCHAR(50),
        category VARCHAR(50)
    );

    CREATE TABLE Physical_Shop (
        shopID INT PRIMARY KEY,
        address VARCHAR(50),
        working_hours VARCHAR(50),
        FOREIGN KEY (shopID) REFERENCES Shop(shopID)
    );

    CREATE TABLE E_shop (
        shopID INT PRIMARY KEY,
        URL VARCHAR(50),
        rating INT,
        FOREIGN KEY (shopID) REFERENCES Shop(shopID)
    );

    CREATE TABLE Voucher (
        voucherID INT IDENTITY(1,1) PRIMARY KEY,
        value INT,
        expiry_date DATE,
        points INT,
        mobileNo CHAR(11),
        shopID INT,
        redeem_date DATE,
        FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo),
        FOREIGN KEY (shopID) REFERENCES Shop(shopID)
    );

    CREATE TABLE Technical_Support_Ticket (
        ticketID INT IDENTITY(1,1) PRIMARY KEY,
        mobileNo CHAR(11),
        Issue_description VARCHAR(50),
        priority_level INT,
        status VARCHAR(50) CHECK (status IN ('Open', 'In Progress', 'Resolved')),
        FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo)
    );
END;
GO

CREATE PROCEDURE dropAllTables AS
BEGIN
    DROP TABLE IF EXISTS Plan_Provides_Benefits;
    DROP TABLE IF EXISTS Cashback;
    DROP TABLE IF EXISTS Exclusive_Offer;
    DROP TABLE IF EXISTS Points_Group;
    DROP TABLE IF EXISTS Benefits;
    DROP TABLE IF EXISTS Transfer_money;
    DROP TABLE IF EXISTS Wallet;
    DROP TABLE IF EXISTS Process_Payment;
    DROP TABLE IF EXISTS Payment;
    DROP TABLE IF EXISTS Plan_Usage;
    DROP TABLE IF EXISTS Subscription;
    DROP TABLE IF EXISTS Service_Plan;
    DROP TABLE IF EXISTS Customer_Account;
    DROP TABLE IF EXISTS Customer_Profile;
    DROP TABLE IF EXISTS Shop;
    DROP TABLE IF EXISTS E_shop;
    DROP TABLE IF EXISTS Physical_Shop;
    DROP TABLE IF EXISTS Voucher;
    DROP TABLE IF EXISTS Technical_Support_Ticket;
END;
GO

CREATE VIEW allCustomerAccounts AS 
SELECT C.nationalID, C.first_name, C.last_name, C.email, C.address, C.date_of_birth,
       A.mobileNo, A.balance, A.account_type, A.start_date, A.status, A.point 
FROM Customer_profile C 
JOIN Customer_Account A ON C.nationalID = A.nationalID
WHERE A.status = 'active';
GO

CREATE VIEW allServicePlans AS 
SELECT * FROM Service_Plan;
GO

CREATE VIEW allBenefits AS 
SELECT * FROM Benefits WHERE status = 'active';
GO

CREATE VIEW AccountPayments AS 
SELECT P.paymentID, P.amount, P.date_of_payment, P.status, P.mobileNo, A.nationalID 
FROM Payment P 
JOIN Customer_Account A ON P.mobileNo = A.mobileNo;
GO

CREATE VIEW allShops AS
SELECT *
FROM Shop ;
GO

CREATE VIEW allResolvedTickets AS 
SELECT * FROM Technical_Support_Ticket WHERE status = 'Resolved';
GO

CREATE VIEW CustomerWallet AS 
SELECT W.walletID, W.current_balance, W.currency, W.last_modified_date,
       W.nationalID, W.mobileNo, N.first_name, N.last_name
FROM Wallet W 
JOIN Customer_Profile N ON W.nationalID = N.nationalID;
GO


Create procedure Account_Plan As Begin
select * from Customer_Account C join Subscription S
on C.mobileNo=S.mobileNo;
Go

--The functions part is the following one

CREATE FUNCTION CalculateRemainingBalance (@paymentAmount DECIMAL(10,1), @planID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @price INT;
    SELECT @price = price FROM Service_Plan WHERE planID = @planID;
    RETURN CASE WHEN @paymentAmount < @price THEN @price - @paymentAmount ELSE 0 END;
END;
GO

CREATE FUNCTION CalculateExtraAmount (@paymentAmount DECIMAL(10,1), @planID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @price INT;
    SELECT @price = price FROM Service_Plan WHERE planID = @planID;
    RETURN CASE WHEN @paymentAmount > @price THEN @paymentAmount - @price ELSE 0 END;
END;
GO







