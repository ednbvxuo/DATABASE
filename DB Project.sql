CREATE DATABASE Telecom_Team_4
use DATABASE Telecom_Team_4
create procedure createAllTables AS
Begin 
CREATE TABLE Customer_profile (nationalID INT PRIMARY KEY,first_name VARCHAR(50),last_name VARCHAR(50),email VARCHAR(50),address VARCHAR(50),date_of_birth DATE) 
  
CREATE TABLE Customer_Account ( mobileNo CHAR(11) PRIMARY KEY,pass VARCHAR(50),balance DECIMAL(10,1),
account_type VARCHAR(50) CHECK (account_type IN ('Post Paid', 'Prepaid', 'Pay_as_you_go')),
start_date DATE,status VARCHAR(50) CHECK (status IN ('active', 'onhold')),point INT default 0, nationalID INT,
FOREIGN KEY (nationalID) REFERENCES Customer_profile(nationalID)) 
  
CREATE TABLE Service_Plan (
planID INT IDENTITY(1,1) PRIMARY KEY,SMS_offered INT,minutes_offered INT,data_offered INT, name VARCHAR(50),price INT,description VARCHAR(50)) 

CREATE TABLE Subscription ( mobileNo CHAR(11), planID INT,subscription_date DATE,status VARCHAR(50) CHECK (status IN ('active', 'onhold')),
PRIMARY KEY (mobileNo, planID),
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo),
FOREIGN KEY (planID) REFERENCES Service_Plan(planID)) 
  
CREATE TABLE Plan_Usage (usageID INT IDENTITY(1,1) PRIMARY KEY, start_date DATE,end_date DATE,data_consumption INT,minutes_used INT,SMS_sent INT,mobileNo CHAR(11),planID INT,
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo),
FOREIGN KEY (planID) REFERENCES Service_Plan(planID)) 
  
CREATE TABLE Payment (paymentID INT IDENTITY(1,1) PRIMARY KEY,amount DECIMAL(10,1),date_of_payment DATE,payment_method VARCHAR(50) CHECK (payment_method IN ('cash', 'credit')),
  status VARCHAR(50) CHECK (status IN ('successful', 'pending', 'rejected')),mobileNo CHAR(11),
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo)) 

CREATE FUNCTION CalculateRemainingBalance (@paymentAmount DECIMAL(10,1), @planID INT)
RETURNS DECIMAL(10, 2)
AS BEGIN
DECLARE @price INT 
SELECT @price = price FROM Service_Plan WHERE planID = @planID 
RETURN CASE WHEN @paymentAmount < @price THEN @price - @paymentAmount ELSE 0 END 
END 

CREATE FUNCTION CalculateExtraAmount (@paymentAmount DECIMAL(10,1), @planID INT)
RETURNS DECIMAL(10, 2)
AS BEGIN
DECLARE @price INT 
SELECT @price = price FROM Service_Plan WHERE planID = @planID 
RETURN CASE WHEN @paymentAmount > @price THEN @paymentAmount - @price ELSE 0 END 
END 

CREATE TABLE Process_Payment (paymentID INT,planID INT,
 remaining_balance DECIMAL(10, 2), extra_amount DECIMAL(10, 2), 
PRIMARY KEY (paymentID, planID),
FOREIGN KEY (paymentID) REFERENCES Payment(paymentID),
FOREIGN KEY (planID) REFERENCES Service_Plan(planID)) 
 
INSERT INTO Process_Payment (paymentID, planID, remaining_balance, extra_amount)
SELECT 
p.paymentID,
sp.planID,
CalculateRemainingBalance(p.amount, sp.planID),
CalculateExtraAmount(p.amount, sp.planID)
FROM Payment p
JOIN 
    Service_Plan sp ON p.mobileNo = (SELECT mobileNo FROM Subscription WHERE planID = sp.planID)
WHERE 
    p.status = 'successful' 
  
CREATE TABLE Wallet (walletID INT IDENTITY(1,1) PRIMARY KEY,current_balance DECIMAL(10,2),currency VARCHAR(50),last_modified_date DATE,nationalID INT,mobileNo CHAR(11),
FOREIGN KEY (nationalID) REFERENCES Customer_profile(nationalID) ) 
  
CREATE TABLE Transfer_money (walletID1 INT,walletID2 INT,transfer_id INT IDENTITY(1,1) PRIMARY KEY,amount DECIMAL(10,2),transfer_date DATE,
FOREIGN KEY (walletID1) REFERENCES Wallet(walletID),
FOREIGN KEY (walletID2) REFERENCES Wallet(walletID)) 
  
CREATE TABLE Benefits (benefitID INT IDENTITY(1,1) PRIMARY KEY,description VARCHAR(50),validity_date DATE,
status VARCHAR(50) CHECK (status IN ('active', 'expired')),mobileNo CHAR(11),
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo) ) 
  
 CREATE TABLE Points_Group (pointID INT IDENTITY(1,1),benefitID INT,pointsAmount INT,PaymentID INT,
PRIMARY KEY (pointID, benefitID),
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)) 
  
CREATE TABLE Exclusive_Offer (
offerID INT,benefitID INT,internet_offered INT,SMS_offered INT,minutes_offered INT,
PRIMARY KEY (offerID, benefitID),
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID)) 
  
CREATE TABLE Cashback (CashbackID INT IDENTITY(1,1) PRIMARY KEY,benefitID INT,walletID INT,amount INT,credit_date DATE,
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
FOREIGN KEY (walletID) REFERENCES Wallet(walletID)) 
  
CREATE TABLE Plan_Provides_Benefits (benefitID INT,planID INT,
PRIMARY KEY (planID, benefitID),
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
FOREIGN KEY (planID) REFERENCES Service_Plan(planID)) 
  
CREATE TABLE Shop (shopID INT IDENTITY(1,1) PRIMARY KEY,name VARCHAR(50),category VARCHAR(50)) 
  
CREATE TABLE Physical_Shop (shopID INT PRIMARY KEY,address VARCHAR(50),working_hours VARCHAR(50),
FOREIGN KEY (shopID) REFERENCES Shop(shopID)) 
  
CREATE TABLE E_shop (shopID INT PRIMARY KEY,URL VARCHAR(50),rating INT,
FOREIGN KEY (shopID) REFERENCES Shop(shopID)) 
  
CREATE TABLE Voucher (voucherID INT IDENTITY(1,1) PRIMARY KEY,value INT,expiry_date DATE,points INT,mobileNo CHAR(11),shopID INT,redeem_date DATE,
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo),
FOREIGN KEY (shopID) REFERENCES Shop(shopID)) 
  
CREATE TABLE Technical_Support_Ticket (ticketID INT IDENTITY(1,1) PRIMARY KEY,mobileNo CHAR(11),Issue_description VARCHAR(50),priority_level INT,
  status VARCHAR(50) CHECK (status IN ('Open', 'In Progress', 'Resolved')),
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo)) 
End

-- I STILL HAVEN'T INCORPRATED THE 10% CASH BACK YET OTHERWISE ALL IS GOOD
  
CREATE PROCEDURE dropAllTables AS
BEGIN
Drop Table If Exists Plan_Provides_Benefits 
Drop Table If Exists Cashback 
Drop Table If Exists Exclusive_Offer 
Drop Table If Exists Points_Group 
Drop Table If Exists Benefits 
Drop Table If Exists Transfer_money 
Drop Table If Exists Wallet 
Drop Table If Exists Process_Payment 
Drop Table If Exists Payment 
Drop Table If Exists Plan_Usage 
Drop Table If Exists Subscription 
Drop Table If Exists Service_Plan 
Drop Table If Exists Customer_Account 
Drop Table If Exists Customer_Profile 
Drop Table If Exists Shop 
Drop Table If Exists E-shop 
Drop Table If Exists Physical_Shop
Drop Table If Exists Voucher 
Drop Table If Exists Technical_Support_Ticket 
End

-- I skipped section d till we do the views,functions... first so we know exactly what to drop first
  
Create Procedure TruncateAllTables as begin
ALTER TABLE Process_Payment NOCHECK CONSTRAINT ALL
ALTER TABLE Subscription NOCHECK CONSTRAINT ALL
TRUNCATE TABLE Process_Payment;
TRUNCATE TABLE Subscription;
TRUNCATE TABLE Plan_Usage;
TRUNCATE TABLE Payment;
TRUNCATE TABLE Wallet;
TRUNCATE TABLE Transfer_money;
TRUNCATE TABLE Benefits;
TRUNCATE TABLE Points_Group;
TRUNCATE TABLE Exclusive_Offer;
TRUNCATE TABLE Cashback;
TRUNCATE TABLE Plan_Provides_Benefits;
TRUNCATE TABLE Voucher;
TRUNCATE TABLE Technical_Support_Ticket;
TRUNCATE TABLE Customer_Account;
TRUNCATE TABLE Customer_profile;
TRUNCATE TABLE Service_Plan;
TRUNCATE TABLE Shop;
TRUNCATE TABLE Physical_Shop;
TRUNCATE TABLE E_shop;
ALTER TABLE Process_Payment CHECK CONSTRAINT ALL
ALTER TABLE Subscription CHECK CONSTRAINT ALL
End


