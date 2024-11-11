CREATE DATABASE Telecom_Team_4
use DATABASE Telecom_Team_4
create procedure createAllTables AS
Begin 
Create table Customer_profile (nationalID int primary key, first_name Varchar(50), last_name Varchar(50), email 
Varchar(50), address Varchar(50), date_of_birth date )
  
Create table  Customer_Account( mobileNo char(11) primary key, pass varchar(50),balance decimal(10,1),
account_type Varchar(50), start_date date, status  Varchar(50), point  int, nationalID  int,
FOREIGN KEY (nationalID) REFERENCES Customer_Profile(nationalID))
  
Create table Service_Plan (planID int Identity (1,1) primary key, SMS_offered  int, minutes_offered  int, data_offered  int, name 
Varchar(50), price int, description  Varchar(50))
  
Create table Subscription (mobileNo  char(11), planID int identity (1,1), subscription_date  date, status  Varchar(50),
FOREIGN KEY (mobileNo) references Customer_Account(mobileNo),
PRIMARY KEY (mobileNo, planID),
FOREIGN KEY (planID) references Service Plan(planID))

Create table Plan_Usage (usageID int identity (1,1) primary key, start_date  date, end_date  date, data_consumption  int,
minutes_used  int, SMS_sent  int, mobileNo  char(11), planID  int,
Foreign key (mobileNo) references Customer_Account(mobileNo),
Foreign key (planID) references Service_Plan(planID))
  
Create table Payment (paymentID int identity (1,1) primary key , amount  decimal (10,1), date_of_payment  date, payment_method 
Varchar(50), status  Varchar(50), mobileNo  char(11),
Foreign Key (mobileNo) references Customer_Account(mobileNo))
  
Create table Process_Payment (paymentID int identity (1,1) primary key, planID  int, remaining_balance DECIMAL(10, 2), extra_amount DECIMAL(10, 2),
Foreign Key (paymentID) references Payment(paymentID),
Foreign Key (planID) references Service_Plan(planID),
remaining_balance AS (CASE WHEN amount < (SELECT price FROM Service_Plan WHERE planID = Process_Payment.planID) 
                               THEN (SELECT price FROM Service_Plan WHERE planID = Process_Payment.planID) - amount 
                               ELSE NULL END),
    extra_amount AS (CASE WHEN amount > (SELECT price FROM Service_Plan WHERE planID = Process_Payment.planID) 
                          THEN amount - (SELECT price FROM Service_Plan WHERE planID = Process_Payment.planID) 
                          ELSE NULL END),)
  
Create table  Wallet (walletID int identity (1,1) primary key, current_balance  decimal(10,2), currency Varchar(50), last_modified_date 
date, nationalID  int, mobileNo  char(11),
Foreign Key (nationalID) references Customer_profile(nationalID))

Create table Transfer_money (walletID1 int identity(1,1) , walletID2 int identity(1,1)  , transfer_id int identity(1,1) , amount  decimal (10,2),
transfer_date date,
Primary key(walletID1 , walletID2 , transfer_id) 
Foreign Key (walletID1) references Wallet(walletID),
Foreign key (walletID2) references Wallet(walletID))
  
Create table Benefits (benefitID int identity(1,1)  primary key, description  Varchar(50), validity_date  date, status  Varchar(50),
mobileNo  char(11),
Foreign Key (mobileNo) references Customer_Account(mobileNo))
  
Create table Points Group (pointID int identity(1,1) , benefitID int , pointsAmount  int, PaymentID  int,
primary key (pointID , benefitID )
Foreign Key (benefitID) references Benefits(benefitID),
Foreign Key (PaymentID) references Payment(PaymentID))
  
Create table Exclusive Offer (offerID int , benefitID int , internet_offered  int, SMS_offered  int,
minutes_offered  int,
primary key(offerID , benefitID)
Foreign Key  (benefitID) references Benefits(benefitID))
  
Create table Cashback (CashbackID int identity(1,1), benefitID int identity(1,1), walletID  int  identity(1,1), amount  int, credit_date date,
primary key(CashbackID int , benefitID int)
Foreign Key (benefitID) references Benefits(benefitID),
Foreign Key Cashback(walletID) references Wallet(walletID))
  
Create table Plan_Provides_Benefits (benefitID int identity(1,1) , planID int identity(1,1),
primary key(planID , benefitID)
Foreign Key (benefitID) references Benefits(benefitID),
Foreign Key (planID) references Service Plan(planID))
  
Create table Shop (shopID int identity(1,1) primary key, name  varchar(50), category  varchar(50))
  
Create table Physical_Shop (shopID int identity(1,1) primary key, address varchar(50), working_hours  varchar(50),
Foreign Key (shopID) references Shop(shopID))
  
Create table E-shop (shopID int primary key, URL  varchar(50), rating  int,
Foreign Key (shopID) references Shop(shopID))
  
Create table Voucher (voucherID int identity(1,1) primary key, value  int, expiry_date  date, points  int, mobileNo  char(11), shopID int,
redeem_date  date,
Foreign Key (mobileNo) references Customer_Account(mobileNo),
Foreign Key (shopID) references Shop(shopID))
  
Create table Technical_Support_Ticket (ticketID int identity(1,1) primary key , mobileNo  char(11) primary key, Issue_description  Varchar(50),
priority_level int, status  Varchar(50),
Foreign Key (mobileNo) references Customer_Account(mobileNo))
End

