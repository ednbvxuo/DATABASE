CREATE DATABASE Telecom_Team_4
use DATABASE Telecom_Team_4
create procedure createAllTables AS
Begin 
CREATE TABLE Customer_profile (nationalID INT PRIMARY KEY,first_name VARCHAR(50),last_name VARCHAR(50),email VARCHAR(50),address VARCHAR(50),date_of_birth DATE);
  
CREATE TABLE Customer_Account ( mobileNo CHAR(11) PRIMARY KEY,pass VARCHAR(50),balance DECIMAL(10,1),
account_type VARCHAR(50) CHECK (account_type IN ('Post Paid', 'Prepaid', 'Pay_as_you_go')),
start_date DATE,status VARCHAR(50) CHECK (status IN ('active', 'onhold')),point INT default 0, nationalID INT,
FOREIGN KEY (nationalID) REFERENCES Customer_profile(nationalID));
  
CREATE TABLE Service_Plan (
planID INT IDENTITY(1,1) PRIMARY KEY,SMS_offered INT,minutes_offered INT,data_offered INT, name VARCHAR(50),price INT,description VARCHAR(50));

CREATE TABLE Subscription ( mobileNo CHAR(11), planID INT,subscription_date DATE,status VARCHAR(50) CHECK (status IN ('active', 'onhold')),
PRIMARY KEY (mobileNo, planID),
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo),
FOREIGN KEY (planID) REFERENCES Service_Plan(planID));
  
CREATE TABLE Plan_Usage (usageID INT IDENTITY(1,1) PRIMARY KEY, start_date DATE,end_date DATE,data_consumption INT,minutes_used INT,SMS_sent INT,mobileNo CHAR(11),planID INT,
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo),
FOREIGN KEY (planID) REFERENCES Service_Plan(planID));
  
CREATE TABLE Payment (paymentID INT IDENTITY(1,1) PRIMARY KEY,amount DECIMAL(10,1),date_of_payment DATE,payment_method VARCHAR(50) CHECK (payment_method IN ('cash', 'credit')),
  status VARCHAR(50) CHECK (status IN ('successful', 'pending', 'rejected')),mobileNo CHAR(11),
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo));
  
CREATE TABLE Process_Payment (paymentID INT,planID INT,
 remaining_balance AS (
 CASE 
 WHEN amount < (SELECT price FROM Service_Plan WHERE planID = Process_Payment.planID) 
THEN (SELECT price FROM Service_Plan WHERE planID = Process_Payment.planID) - amount 
ELSE NULL 
 END ),
 extra_amount AS (
CASE 
WHEN amount > (SELECT price FROM Service_Plan WHERE planID = Process_Payment.planID) 
THEN amount - (SELECT price FROM Service_Plan WHERE planID = Process_Payment.planID) 
ELSE NULL 
END),
PRIMARY KEY (paymentID, planID),
FOREIGN KEY (paymentID) REFERENCES Payment(paymentID),
FOREIGN KEY (planID) REFERENCES Service_Plan(planID));
  
CREATE TABLE Wallet (walletID INT IDENTITY(1,1) PRIMARY KEY,current_balance DECIMAL(10,2),currency VARCHAR(50),last_modified_date DATE,nationalID INT,mobileNo CHAR(11),
FOREIGN KEY (nationalID) REFERENCES Customer_profile(nationalID) );
  
CREATE TABLE Transfer_money (walletID1 INT,walletID2 INT,transfer_id INT IDENTITY(1,1) PRIMARY KEY,amount DECIMAL(10,2),transfer_date DATE,
FOREIGN KEY (walletID1) REFERENCES Wallet(walletID),
FOREIGN KEY (walletID2) REFERENCES Wallet(walletID));
  
CREATE TABLE Benefits (benefitID INT IDENTITY(1,1) PRIMARY KEY,description VARCHAR(50),validity_date DATE,
status VARCHAR(50) CHECK (status IN ('active', 'expired')),mobileNo CHAR(11),
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo) );
  
 CREATE TABLE Points_Group (pointID INT IDENTITY(1,1),benefitID INT,pointsAmount INT,PaymentID INT,
PRIMARY KEY (pointID, benefitID),
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID));
  
CREATE TABLE Exclusive_Offer (
offerID INT,benefitID INT,internet_offered INT,SMS_offered INT,minutes_offered INT,
PRIMARY KEY (offerID, benefitID),
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID));
  
CREATE TABLE Cashback (CashbackID INT IDENTITY(1,1) PRIMARY KEY,benefitID INT,walletID INT,amount INT,credit_date DATE,
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
FOREIGN KEY (walletID) REFERENCES Wallet(walletID));
  
CREATE TABLE Plan_Provides_Benefits (benefitID INT,planID INT,
PRIMARY KEY (planID, benefitID),
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
FOREIGN KEY (planID) REFERENCES Service_Plan(planID));
  
CREATE TABLE Shop (shopID INT IDENTITY(1,1) PRIMARY KEY,name VARCHAR(50),category VARCHAR(50));
  
CREATE TABLE Physical_Shop (shopID INT PRIMARY KEY,address VARCHAR(50),working_hours VARCHAR(50),
FOREIGN KEY (shopID) REFERENCES Shop(shopID));
  
CREATE TABLE E_shop (shopID INT PRIMARY KEY,URL VARCHAR(50),rating INT,
FOREIGN KEY (shopID) REFERENCES Shop(shopID));
  
CREATE TABLE Voucher (voucherID INT IDENTITY(1,1) PRIMARY KEY,value INT,expiry_date DATE,points INT,mobileNo CHAR(11),shopID INT,redeem_date DATE,
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo),
FOREIGN KEY (shopID) REFERENCES Shop(shopID));
  
CREATE TABLE Technical_Support_Ticket (ticketID INT IDENTITY(1,1) PRIMARY KEY,mobileNo CHAR(11),Issue_description VARCHAR(50),priority_level INT,
  status VARCHAR(50) CHECK (status IN ('Open', 'In Progress', 'Resolved')),
FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo));

End

