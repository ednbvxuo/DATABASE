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

Create procedure dropAllProceduresFunctionsViews as begin
DROP PROCEDURE IF EXISTS createAllTables;
DROP PROCEDURE IF EXISTS dropAllTables;
DROP PROCEDURE IF EXISTS clearAllTables;
DROP PROCEDURE IF EXISTS Account_Plan;
DROP PROCEDURE IF EXISTS Benefits_Account;
DROP PROCEDURE IF EXISTS Account_Payment_Points;
DROP PROCEDURE IF EXISTS Total_Points_Account;
DROP PROCEDURE IF EXISTS Ticket_Account_Customer;
DROP PROCEDURE IF EXISTS Account_Highest_Voucher;
DROP PROCEDURE IF EXISTS Top_Successful_Payments;
DROP PROCEDURE IF EXISTS Initiate_plan_payment;
DROP PROCEDURE IF EXISTS Payment_wallet_cashback;
DROP PROCEDURE IF EXISTS Initiate_balance_payment;
DROP PROCEDURE IF EXISTS Redeem_voucher_points;


DROP FUNCTION IF EXISTS Wallet_Cashback_Amount;
DROP FUNCTION IF EXISTS Wallet_Transfer_Amount;
DROP FUNCTION IF EXISTS Wallet_MobileNo;
DROP FUNCTION IF EXISTS AccountLoginValidation;
DROP FUNCTION IF EXISTS Remaining_plan_amount;
DROP FUNCTION IF EXISTS Extra_plan_amount;

--the previous part is for dropping the scalar functions then the next section is for table valued functions
--so nothing is missed
DROP FUNCTION IF EXISTS Account_Plan_date;
DROP FUNCTION IF EXISTS Account_Usage_Plan;
DROP FUNCTION IF EXISTS Account_SMS_Offers;
DROP FUNCTION IF EXISTS Consumption;
DROP FUNCTION IF EXISTS Usage_Plan_CurrentMonth;
DROP FUNCTION IF EXISTS Cashback_Wallet_Customer;
DROP FUNCTION IF EXISTS Subscribed_plans_5_Months;



End;Go
    
CREATE PROCEDURE clearAllTables AS
BEGIN
 TRUNCATE TABLE  Plan_Provides_Benefits;
   TRUNCATE TABLE  Cashback;
   TRUNCATE TABLE  Exclusive_Offer;
   TRUNCATE TABLE  Points_Group;
   TRUNCATE TABLE  Benefits;
   TRUNCATE TABLE  Transfer_money;
   TRUNCATE TABLE  Wallet;
   TRUNCATE TABLE  Process_Payment;
    TRUNCATE TABLE  Payment;
    TRUNCATE TABLE  Plan_Usage;
    TRUNCATE TABLE  Subscription;
    TRUNCATE TABLE  Service_Plan;
    TRUNCATE TABLE  Customer_Account;
   TRUNCATE TABLE  Customer_Profile;
    TRUNCATE TABLE  Shop;
    TRUNCATE TABLE  E_shop;
    TRUNCATE TABLE  Physical_Shop;
    TRUNCATE TABLE  Voucher;
   TRUNCATE TABLE  Technical_Support_Ticket;
   END 
   GO
-- is this correct?? JAN -- 


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

CREATE VIEW E_shopVouchers AS
SELECT S.shopID , S1.name , V.voucherID , V.value 
FROM E_shop S JOIN Shop S1 ON S.shopID = S1.shopID JOIN Voucher V 
ON S.shopID = V.shopID; 

GO

CREATE VIEW PhysicalStoreVouchers AS
SELECT S.shopID , S1.name , V.voucherID , V.value 
FROM Physical_Shop S JOIN Shop S1 ON S.shopID = S1.shopID JOIN Voucher V 
ON S.shopID = V.shopID; 

GO
CREATE VIEW Num_of_cashback AS 
SELECT W.walletID, count(C.CashbackID)
FROM Cashback C,Wallet W 
WHERE W.walletID = C.walletID
GROUP BY W.walletID
 

Go 
-- are these correcy views? i joined the shop so we could view the names also not sure bout the cashback one --

Create procedure Account_Plan As Begin
select * from Customer_Account C join Subscription S
on C.mobileNo=S.mobileNo;
End; Go

CREATE PROCEDURE Benefits_Account @MobileNo CHAR(11), @PlanID INT AS BEGIN
DELETE FROM Benefits
WHERE mobileNo = @MobileNo
AND benefitID IN (
          SELECT B.benefitID
          FROM Benefits B
          JOIN Subscription S ON B.mobileNo = S.mobileNo AND B.planID = S.planID
          WHERE S.mobileNo = @MobileNo AND S.planID = @PlanID);
Select * from Benefits
END;GO
    
CREATE PROCEDURE Account_Payment_Points @MobileNo CHAR(11) AS BEGIN
SELECT P.mobileNo,COUNT(*) AS Count_Of_Accepted_Payments,SUM(G.pointsAmount) AS Total_Points
FROM  Payment P JOIN Points_Group G ON P.paymentID = G.paymentID
WHERE P.mobileNo = @MobileNo AND P.status = 'successful'
AND YEAR(P.date_of_payment) = YEAR(DATEADD(YEAR, -1, CURRENT_TIMESTAMP))
GROUP BY P.mobileNo;
END;GO





    
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

CREATE FUNCTION Account_Plan_date 
(@Subscription_Date date, @Plan_id int)
RETURNS TABLE 
AS
RETURN (
SELECT C.mobileNo, S.planID, S.name 
FROM Customer_Account C JOIN Subscription SC ON 
C.mobileNO = SC.mobileNO JOIN Service_Plan S ON S.planID = SC.planID
WHERE S.planID = @Plan_ID AND SC.subscription_date = @Subscription_Date)
GO

CREATE FUNCTION Account_Usage_Plan 
(@MobileNo char(11), @from_date date) 
RETURNS TABLE 
AS 
RETURN (
SELECT P.planID, SUM(P.data_consumption) AS total_data_consumed, 
SUM(P.minutes_used) AS total_minutes_used , SUM(P.SMS_sent) AS  total_SMS
FROM  Plan_Usage P JOIN Subscription S ON S.planID = P.planID AND S.mobileNo = P.mobileNo 
WHERE 
@MobileNo = P.mobileNo AND start_date= @from_date 
GROUP BY P.mobileNo);
GO 
-- do we need to join f al hirearhy-- 
CREATE FUNCTION Account_SMS_Offers 
(@MobileNo char(11)) 
RETURNS TABLE 
AS 
RETURN (
SELECT O.offerID, O.benefitID, O.SMS_offered
FROM Exclusive_Offer O JOIN Benefits B ON O.benefitID = B.benefitID 
WHERE B.mobileNo = @MobileNo);
GO 
--jan adjusted added sum--
CREATE FUNCTION Wallet_Cashback_Amount
( @WalletId int, @planId int)
RETURNS int 
AS BEGIN
DECLARE @Amount_of_cashback int 

SELECT @Amount_of_cashback = SUM(C.amount)
FROM Cashback C JOIN Benefits B ON C.benefitID = B.benefitID 
JOIN Wallet W ON C.walletID = W.walletID JOIN Subscription S ON B.planID = S.planID 
WHERE C.walletID =  @WalletId AND B.planID = @planId
RETURN @Amount_of_cashback 
END;
GO
--- ASK TA THIS METHOD M4 OK AWY---- 

CREATE FUNCTION Wallet_Transfer_Amount 
(@Wallet_id int, @start_date date, @end_date date)
RETURNS int 
AS BEGIN
DECLARE @Transaction_amount_average int 
-- jan adjusted f al select 5alyt variable b equal f l select + added the between--
SELECT @Transaction_amount_average = AVG(P.amount)
FROM Wallet W JOIN Payment P ON W.mobileNo = P.mobileNo 
WHERE W.walletID = @Wallet_id AND p.date_of_payment  BETWEEN  @start_date AND @end_date AND P.status = 'successful' 
RETURN  @Transaction_amount_average
END;
GO;

-- changed this function kolha jan adjusted--
CREATE FUNCTION Wallet_MobileNo
    (@MobileNo CHAR(11))
RETURNS BIT
AS
BEGIN
    DECLARE @x BIT;
    IF EXISTS (SELECT* FROM Wallet WHERE mobileNo = @MobileNo)
        SET @x = 1;
    ELSE
        SET @x = 0; 
    RETURN @x;
END;
GO


-- same changed de kollha--
CREATE PROCEDURE Total_Points_Account
    @MobileNo CHAR(11)
AS
BEGIN
    DECLARE @final INT;
    SELECT @final = SUM(P.amount)
    FROM Points_Group P
    JOIN Benefits B ON P.benefitID = B.benefitID
    WHERE B.mobileNo = @MobileNo;
    UPDATE Customer_Account
    SET amount = @final
    WHERE mobileNo = @MobileNo;
END;
GO

-- page 9-- 
CREATE FUNCTION AccountLoginValidation(
@MobileNo char(11), @password varchar(50))
RETURNS BIT 
AS
BEGIN
DECLARE @Success BIT; 
  IF EXISTS (
        SELECT *
        FROM  Customer_Account C 
        WHERE C.mobileNo = @MobileNo AND C.pass = @Password
    )
    BEGIN
        SET @Success = 1;
    END
    ELSE
    BEGIN
        SET @Success = 0; 
    END

    RETURN @Success;
END;
GO

CREATE FUNCTION Consumption (
 
 @Plan_name varchar(50), @start_date date,
 @end_date date)
 RETURNS TABLE
 AS
 RETURN (
 SELECT P.usageID , P.data_consumption , P.minutes_used , P.SMS_sent 
 FROM Plan_Usage P JOIN Service_Plan SP ON P.planID = SP.planID
 WHERE SP.name =  @Plan_name AND P.start_date = @start_date AND P.end_date =  @end_date
 GROUP BY P.usageID ) ; 
 GO 

 CREATE FUNCTION Usage_Plan_CurrentMonth(
 @MobileNo char(11) )
 RETURNS TABLE 
 RETURN(
 SELECT SP.name , P.data_consumption , P.minutes_used , P.SMS_sent 
 FROM  Customer_Account C JOIN Subscription S ON C.mobileNo= S.mobileNo
 JOIN Service_Plan SP ON S.planID = SP.planID JOIN  Plan_Usage ON  SP.planID = P.planID
 WHERE C.mobileNo = @MobileNo); 
 GO
 


-- page 10 jana's part-- 
go

CREATE FUNCTION Cashback_Wallet_Customer(
    @NationalID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT c.transaction_id, c.cashback_amount, c.date
    FROM Wallet w
    JOIN CashbackTransactions c ON w.wallet_id = c.wallet_id
    WHERE w.NationalID = @NationalID
);

go

CREATE PROCEDURE Ticket_Account_Customer(
    @NationalID INT,
    @TicketCount INT OUTPUT
)
AS
BEGIN
    SELECT @TicketCount = COUNT(*)
    FROM Accounts a
    JOIN Tickets t ON a.account_id = t.account_id
    WHERE a.NationalID = @NationalID AND t.status <> 'Resolved';
END;
go 

CREATE PROCEDURE Account_Highest_Voucher(
    @MobileNo CHAR(11),
    @VoucherID INT OUTPUT
)

AS
BEGIN
    SELECT TOP 1 @VoucherID = v.voucher_id
    FROM Vouchers v
    JOIN Accounts a ON v.account_id = a.account_id
    WHERE a.MobileNo = @MobileNo
    ORDER BY v.value DESC;
END;
go

CREATE FUNCTION Remaining_plan_amount(
    @MobileNo CHAR(11),
    @plan_name VARCHAR(50)
)
RETURNS REAL
AS
BEGIN
    DECLARE @RemainingAmount REAL;

    SELECT @RemainingAmount = p.plan_amount - SUM(p.payment_amount)
    FROM Payments p
    WHERE p.MobileNo = @MobileNo AND p.plan_name = @plan_name
    GROUP BY p.plan_amount;

    RETURN ISNULL(@RemainingAmount, 0);
END;
go

-- page 11 and 12 ziad and ahmed--
CREATE FUNCTION Extra_plan_amount (
    @MobileNo char(11),
    @plan_name varchar(50)
)
RETURNS decimal(10, 2)
AS
BEGIN
    DECLARE @ExtraAmount decimal(10, 2);

    SELECT @ExtraAmount = P.Transaction_amount - SP.Price
    FROM Payment P
    JOIN Customer_Account CA ON P.Payment_ID = CA.Payment_ID
    JOIN Subscribed_to ST ON CA.Mobile_number = ST.Mobile_number
    JOIN Service_Plan SP ON ST.Plan_ID = SP.Plan_ID
    WHERE CA.Mobile_number = @MobileNo
      AND SP.Name = @plan_name;

    RETURN @ExtraAmount;
END;
Go
CREATE PROCEDURE Top_Successful_Payments (
    @MobileNo char(11)
)
AS
BEGIN
    SELECT TOP 10 P.Payment_ID, P.Transaction_amount, P.Date_of_payment
    FROM Payment P
    JOIN Customer_Account CA ON P.Payment_ID = CA.Payment_ID
    WHERE CA.Mobile_number = @MobileNo
      AND P.Payment_status = 'successful'
    ORDER BY P.Transaction_amount DESC;
END;
Go
CREATE FUNCTION Subscribed_plans_5_Months (
    @MobileNo char(11)
)
RETURNS TABLE
AS
RETURN (
    SELECT SP.Plan_ID, SP.Name, SP.Description, SP.Price
    FROM Subscribed_to ST
    JOIN Service_Plan SP ON ST.Plan_ID = SP.Plan_ID
    WHERE ST.Mobile_number = @MobileNo
      AND ST.Start_date >= DATEADD(MONTH, -5, GETDATE())
);
Go
CREATE PROCEDURE Initiate_plan_payment (
    @MobileNo char(11),
    @amount decimal(10, 1),
    @payment_method varchar(50),
    @plan_id int
)
AS
BEGIN
    DECLARE @PaymentID int;
    INSERT INTO Payment (Transaction_amount, Payment_status, Date_of_payment)
    VALUES (@amount, 'successful', GETDATE());
    SET @PaymentID = SCOPE_IDENTITY();
    UPDATE Customer_Account
    SET Payment_ID = @PaymentID
    WHERE Mobile_number = @MobileNo;
    UPDATE Subscribed_to
    SET Status = 'active'
    WHERE Mobile_number = @MobileNo
      AND Plan_ID = @plan_id;
END;
Go
CREATE PROCEDURE Payment_wallet_cashback (
    @MobileNo char(11),
    @payment_id int,
    @benefit_id int
)
AS
BEGIN
    DECLARE @CashbackAmount decimal(10, 2);
    DECLARE @WalletID int;
    SELECT @CashbackAmount = 0.1 * Transaction_amount
    FROM Payment
    WHERE Payment_ID = @payment_id;
    SELECT @WalletID = Wallet_ID
    FROM Wallet
    WHERE Mobile_number = @MobileNo;
    UPDATE Wallet
    SET Current_balance = Current_balance + @CashbackAmount
    WHERE Wallet_ID = @WalletID;

    INSERT INTO Cashback (Benefit_ID, ID, Amount, Credit_date)
    VALUES (@benefit_id, @WalletID, @CashbackAmount, GETDATE());
END;
Go
CREATE PROCEDURE Initiate_balance_payment (
    @MobileNo char(11),
    @amount decimal(10, 1),
    @payment_method varchar(50)
)
AS
BEGIN
    DECLARE @PaymentID int;
    INSERT INTO Payment (Transaction_amount, Payment_status, Date_of_payment)
    VALUES (@amount, 'successful', GETDATE());
    SET @PaymentID = SCOPE_IDENTITY();
    UPDATE Wallet
    SET Current_balance = Current_balance + @amount
    WHERE Mobile_number = @MobileNo;
    INSERT INTO Payment_Method (Payment_Method, Payment_ID)
    VALUES (@payment_method, @PaymentID);
END;
Go
CREATE PROCEDURE Redeem_voucher_points (
    @MobileNo char(11),
    @voucher_id int
)
AS
BEGIN
    DECLARE @PointsRequired int;
    DECLARE @CurrentPoints int;

    SELECT @PointsRequired = Points_Required
    FROM Voucher
    WHERE Voucher_ID = @voucher_id;

    SELECT @CurrentPoints = Points_Earned_From_Transaction
    FROM Customer_Account
    WHERE Mobile_number = @MobileNo;

    IF @CurrentPoints >= @PointsRequired
    BEGIN
        UPDATE Customer_Account
        SET Points_Earned_From_Transaction = @CurrentPoints - @PointsRequired
        WHERE Mobile_number = @MobileNo;

        PRINT 'Voucher redeemed successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Insufficient points to redeem the voucher.';
    END;
END;

