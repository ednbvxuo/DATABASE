Create DATABASE Telecom_Team_4;
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
DROP PROCEDURE IF EXISTS Unsubscribed_Plans;

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

DROP VIEW IF EXISTS allCustomerAccounts;
DROP VIEW IF EXISTS allServicePlans;
DROP VIEW IF EXISTS allBenefits;
DROP VIEW IF EXISTS AccountPayments;
DROP VIEW IF EXISTS allShops;
DROP VIEW IF EXISTS allResolvedTickets;
DROP VIEW IF EXISTS CustomerWallet;
DROP VIEW IF EXISTS E_shopVouchers;
DROP VIEW IF EXISTS PhysicalStoreVouchers;
DROP VIEW IF EXISTS Num_of_cashback;

End;go
    
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
   END; 
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
SELECT W.walletID, count(C.CashbackID) as 'Number of cashbacks'
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
          JOIN Subscription S ON B.mobileNo = S.mobileNo 
          WHERE S.mobileNo = @MobileNo AND S.planID = @PlanID);
Select * from Benefits
END;go
    
CREATE PROCEDURE
Account_Payment_Points @MobileNo CHAR(11) AS BEGIN
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
@MobileNo = P.mobileNo AND  S.subscription_date= @from_date 
GROUP BY P.mobileNo,P.planID);
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
JOIN Wallet W ON C.walletID = W.walletID JOIN Subscription S ON B.mobileNo = S.mobileNo 
WHERE C.walletID =  @WalletId AND S.planID = @planId
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
END
GO

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
    SELECT @final = SUM(P.pointsAmount)
    FROM Points_Group P
    JOIN Benefits B ON P.benefitID = B.benefitID
    WHERE B.mobileNo = @MobileNo;
    UPDATE Customer_Account
    SET point = @final
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

CREATE FUNCTION Consumption
(@Plan_name VARCHAR(50),@start_date DATE,@end_date DATE)
returns table as return(
SELECT 
sum(P.data_consumption) AS Data_Consumed,
sum(P.minutes_used) AS Minutes_Used,sum(P.SMS_sent) AS SMS_Sent
 FROM Plan_Usage P JOIN Subscription S ON P.planID = S.planID JOIN 
 Service_Plan SP ON S.planID = SP.planID WHERE 
        SP.name = @Plan_name
        AND P.start_date BETWEEN @start_date AND @end_date
    GROUP BY 
        SP.name
);
GO

CREATE PROCEDURE Unsubscribed_Plans @MobileNo CHAR(11) AS BEGIN
    select P.planID, P.name, P.price, P.description from Service_Plan P
    where P.planID NOT IN (select S.planID from Subscription S where S.mobileNo = @MobileNo);
END;Go

 CREATE FUNCTION Usage_Plan_CurrentMonth(
 @MobileNo char(11) )
 RETURNS TABLE 
 RETURN(
 SELECT SP.name , P.data_consumption , P.minutes_used , P.SMS_sent 
 FROM  Customer_Account C JOIN Subscription S ON C.mobileNo= S.mobileNo
 JOIN Service_Plan SP ON S.planID = SP.planID JOIN  Plan_Usage P ON  SP.planID = P.planID
 WHERE C.mobileNo = @MobileNo); 
 GO
 


-- page 10 jana's part-- 
go

create function Cashback_Wallet_Customer(@NationalID INT)
Returns Table AS Return (SELECT  C.CashbackID,C.walletID,C.amount,C.credit_date FROM Cashback C JOIN Wallet W
ON C.walletID = W.walletID JOIN 
Customer_Account CA ON W.mobileNo = CA.mobileNo
WHERE CA.NationalID = @NationalID);
GO


CREATE PROCEDURE Ticket_Account_Customer(@NationalID INT)
AS
BEGIN
SELECT COUNT(ticketID)
FROM Technical_Support_Ticket HELP
JOIN Customer_Account CA ON HELP.mobileNo = CA.mobileNo
WHERE CA.NationalID = @NationalID AND HELP.status <> 'Resolved';
END;
go 

CREATE PROCEDURE Account_Highest_Voucher(
    @MobileNo CHAR(11),
    @Voucher_id INT OUTPUT
)

AS
BEGIN
    SELECT TOP 1 @Voucher_id = v.voucherID
    FROM Voucher v
    JOIN Customer_Account a ON v.mobileNo = a.mobileNo
    WHERE a.MobileNo = @MobileNo
    ORDER BY v.value DESC;
END;
go

CREATE FUNCTION Remaining_plan_amount(
    @MobileNo CHAR(11),
    @plan_name VARCHAR(50))
RETURNS DECIMAL(10, 2) AS BEGIN
    DECLARE @RemainingAmount DECIMAL(10, 2);
    SELECT @RemainingAmount = p.plan_amount - SUM(p.payment_amount)
    FROM Payments p
    WHERE p.MobileNo = @MobileNo AND p.plan_name = @plan_name
    GROUP BY p.plan_amount;
    IF @RemainingAmount IS NULL
    BEGIN
    SET @RemainingAmount = 0;
    END
    RETURN @RemainingAmount;
END;
GO
-- page 11 and 12 ziad and ahmed--
CREATE FUNCTION Extra_plan_amount(@MobileNo CHAR(11),@plan_name VARCHAR(50))
RETURNS DECIMAL(10, 2) as begin
declare @Plan__Price decimal(10, 2);
declare @Total__Payments decimal(10, 2);
declare @ExtraAmount decimal(10, 2);
SELECT @Plan__Price = SP.price
FROM Service_Plan SP
JOIN Subscription S ON SP.planID = S.planID
WHERE S.mobileNo = @MobileNo AND SP.name = @plan_name;
SELECT @Total__Payments = SUM(P.amount)
FROM Payments P
JOIN Subscription S ON P.mobileNo = S.mobileNo
JOIN Service_Plan SP ON S.planID = SP.planID
WHERE S.mobileNo = @MobileNo AND SP.name = @plan_name;
IF @Total__Payments > @Plan__Price
SET @ExtraAmount = @Total__Payments - @Plan__Price;
ELSE
SET @ExtraAmount = 0;
RETURN @ExtraAmount;
END;
GO


CREATE PROCEDURE Top_Successful_Payments
    @MobileNo CHAR(11)
AS
BEGIN
    SELECT TOP 10 
        p.paymentID,
        p.amount,
        p.date_of_payment,
        p.payment_method,
        p.status,
        p.mobileNo
    FROM Customer_Account ca
    JOIN Payment p ON ca.mobileNo = p.mobileNo
    WHERE ca.mobileNo = @MobileNo
      AND p.status = 'successful'
    ORDER BY p.amount DESC;
END;


Go
CREATE FUNCTION Subscribed_plans_5_Months ( @MobileNo CHAR(11) )
RETURNS TABLE
AS
RETURN
(SELECT 
SP.planID,sp.name AS Plan_Name,sp.price AS Plan_Price,sp.SMS_offered,sp.minutes_offered,sp.data_offered,s.subscription_date,
s.status AS SubscriptionStatus
FROM 
Subscription s JOIN Service_Plan sp ON s.planID = sp.planID
WHERE s.mobileNo = @MobileNo AND s.subscription_date >= DATEADD(MONTH, -5, GETDATE()));
GO

CREATE PROCEDURE Payment_wallet_cashback
(
    @MobileNo CHAR(11), 
    @PaymentID INT, 
    @BenefitID INT 
)
AS
BEGIN
    DECLARE @CashbackAmount INT;
    SELECT @CashbackAmount = amount
    FROM Cashback
    WHERE benefitID = @BenefitID;

    DECLARE @WalletID INT;
    SELECT @WalletID = w.walletID
    FROM Wallet w
    INNER JOIN Customer_Account ca ON w.nationalID = ca.nationalID
    WHERE ca.mobileNo = @MobileNo;

    UPDATE Wallet
    SET current_balance = current_balance + @CashbackAmount,
        last_modified_date = GETDATE()
    WHERE walletID = @WalletID;

    UPDATE Cashback
    SET credit_date = GETDATE()
    WHERE benefitID = @BenefitID AND walletID = @WalletID;
END;
GO

CREATE PROCEDURE Initiate_plan_payment
(
    @MobileNo CHAR(11), 
    @Amount DECIMAL(10,1), 
    @Payment_Method VARCHAR(50), 
    @PlanID INT 
)
AS
BEGIN
  
    INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
    VALUES (@Amount, GETDATE(), @Payment_Method, 'Accepted', @MobileNo);

   
    UPDATE Subscription
    SET status = 'Active', subscription_date = GETDATE()
    WHERE mobileNo = @MobileNo AND planID = @PlanID;
END;
GO

CREATE PROCEDURE Initiate_balance_payment
(
    @MobileNo CHAR(11), 
    @Amount DECIMAL(10,1), 
    @Payment_Method VARCHAR(50) 
)
AS
BEGIN
    INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
    VALUES (@Amount, GETDATE(), @Payment_Method, 'Accepted', @MobileNo);

    DECLARE @WalletID INT;
    SELECT @WalletID = w.walletID
    FROM Wallet w
    INNER JOIN Customer_Account ca ON w.nationalID = ca.nationalID
    WHERE ca.mobileNo = @MobileNo;

    UPDATE Wallet
    SET current_balance = current_balance + @Amount,
        last_modified_date = GETDATE()
    WHERE walletID = @WalletID;
END;
GO

CREATE PROCEDURE Redeem_voucher_points
(
    @MobileNo CHAR(11), 
    @VoucherID INT 
)
AS
BEGIN
    DECLARE @VoucherPoints INT;
    SELECT @VoucherPoints = points
    FROM Voucher
    WHERE voucherID = @VoucherID AND mobileNo = @MobileNo;

    UPDATE Voucher
    SET redeem_date = GETDATE()
    WHERE voucherID = @VoucherID AND mobileNo = @MobileNo;

    UPDATE Customer_Account
    SET point = point - @VoucherPoints
    WHERE mobileNo = @MobileNo;
END;
GO



-- insertions part

--The data
insert into Customer_profile values ('Michael' , 'Scott' , 'mscott@hotmail.com' , 'whatever' , '8/12/1976')
insert into Customer_profile values ('Pamela' , 'Beesly' , 'pbeesly@hotmail.com' , 'meh' , '8/7/1976')
insert into Customer_profile values ('Esraa' , 'Ahmed' , 'esraa@hotmail.com' , 'meh' , '8/7/2004')
insert into Customer_Account values ('01234567899' , 'bbbbbb' , 277800.22, 'Post Paid' , '1/2/2014' , 'active' , 750 , 1)
insert into Customer_Account values ('0123476' , 'abcd' , 2500.22, 'Prepaid' , '1/3/2014' , 'active' , 750 , 2)
insert into Customer_Account values ('01010749807' , 'abcd' , 5000, 'Post Paid' , '1/3/2024' , 'active' , 400 , 3)

insert into Service_Plan values (150 , 340 , 600 , 'Express' , 67 , 'Very Quick')
insert into Service_Plan values (300 , 65 , 950 , 'wehsha awy' , 70 , 'super slow')
insert into Service_Plan values (310 , 95 , 1950 , 'meh' , 90 , 'medium')

insert into Subscription values ('01234567899' , 1 , '3/4/2022' , 'active')
insert into Subscription values ('0123476' , 2 , '3/4/2023' , 'active')

insert into Plan_Provides_Benefits values(7 , 1)
insert into Plan_Provides_Benefits values(10, 1)

insert into Plan_Provides_Benefits values (7 , 2)
insert into Plan_Provides_Benefits values (10 , 2)
insert into Plan_Provides_Benefits values (7 , 3)

insert into Benefits values ('gamda' , '3/5/2023' , 'active' , '01234567899')
insert into Benefits values ('mesh awy' , '3/4/2023' , 'active' , '0123476')
insert into Benefits values('hehe', '2/8/2023','active','01010749807')

insert into Payment values (1233.44 , '4/5/2024' , 'cash' , 'successful' , '01234567899')
insert into Payment values (2000.55 , '4/2/2024' , 'cash' , 'successful' , '01234567899')
insert into Payment values (12000.44 , '1/5/2024' , 'cash' , 'pending' , '0123476')
insert into Payment values (1233.44 , '4/5/2024' , 'cash' , 'rejected' , '01234567899')
insert into Payment values(300.11,'5/5/2024', 'cash', 'successful','01010749807')

insert into Points_Group values (7 , 1233.44 , 1)
insert into Points_Group values (7,  5000.44 , 2)


INSERT INTO Technical_Support_Ticket values('01234567899', 'BLABLABLA' , 1,'Open')
INSERT INTO Technical_Support_Ticket values('01234567899', 'BLABLABLA' , 2,'In Progress')
INSERT INTO Technical_Support_Ticket values('01234567899', 'BLABLABLA' , 2,'Resolved')
INSERT INTO Technical_Support_Ticket values('0123476', 'BLALA' , 1, 'Resolved')

INSERT INTO Process_Payment values(1,1,55.2,33.2)
INSERT INTO Process_Payment values(2,2,11.2,0.2)
INSERT INTO Process_Payment values(3,1,55.2,33.2)
INSERT INTO Process_Payment values(4,1,10.2,65.2)

INSERT INTO Wallet values(500.2,'dollar','11/5/2024',1,'01234567899')
INSERT INTO Wallet values(600,'dollar','11/9/2024',1,'0123476')
INSERT INTO Wallet values(2000,'dollar','12/8/2023',3,'01010749807')


-- Insert into Customer_Profile
INSERT INTO Customer_Profile (first_name, last_name, email, address, date_of_birth)
VALUES 
('John', 'Doe', 'john.doe@example.com', '123 Main St', '1990-01-01');
INSERT INTO Customer_profile VALUES 
('Esra', 'Ahmed', 'john.doe@example.com', 'new cairo', '2004-01-01');

-- Insert into Customer_Account
INSERT INTO Customer_Account (mobileNo, pass, balance, account_type, start_date, status, point, nationalID)
VALUES
('01234567890', 'password123', 1000.0, 'Prepaid', '2024-01-01', 'Active', 100, 1);
insert into Customer_Account values ('1234','pass22',500.0, 'Post paid' , '2024-02-02', 'Active', 200, 2)

-- Insert into Wallet
INSERT INTO Wallet (current_balance, currency, last_modified_date, nationalID, mobileNo)
VALUES
(500.0, 'USD', '2024-11-01', 1, '01234567890');
insert into wallet values(0,'Dollar','2024-05-01',2,'1234')

-- Insert into Service_Plan
INSERT INTO Service_Plan (SMS_offered, minutes_offered, data_offered, name, price, description)
VALUES
(100, 200, 5000, 'Basic Plan', 50, 'Affordable basic service plan');
insert into Service_Plan values(100,200,1000,'Basic Plan2',20,'hehe')

-- Insert into Payment
INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
VALUES
(100.0, '2024-11-10', 'credit', 'successful', '01234567890');
insert into payment values (200.0,'2024-04-01','credit','successful','1234')
insert into payment values(300.0,'2024-04-08','cash','successful','1234')

-- Insert into Process_Payment
INSERT INTO Process_Payment (paymentID, planID, remaining_balance, extra_amount)
VALUES
(1, 1, 0.0, 50.0);
insert into Process_Payment values(2,2,20.1,30.1)
insert into Process_Payment values(3,2,20,10)

-- Insert into Benefits
INSERT INTO Benefits (description, validity_date, status, mobileNo)
VALUES
('Cashback Benefit', '2024-12-31', 'Active', '01234567890');
insert into Benefits values('hehe','2024-12-31','Active','1234')

-- Insert into Cashback
INSERT INTO Cashback (benefitID, walletID, amount, credit_date)
VALUES
(1, 1, 10.0, '2024-11-10');

-- Insert into Technical_Support_Ticket
INSERT INTO Technical_Support_Ticket (mobileNo, Issue_description, priority_level, status)
VALUES
('1234', 'Unable to recharge wallet', 1, 'Open'),
('01234567890', 'Incorrect cashback credited', 2, 'In Progress'),
('01234567890', 'Account locked due to failed logins', 3, 'Resolved'),
('1234', 'Unable to access subscription details', 1, 'Open'),
('1234', 'Request for plan upgrade', 2, 'Resolved');
