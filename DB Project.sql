CREATE DATABASE Telecom_Team_4
use DATABASE Telecom_Team_4
create procedure createAllTables AS
Begin 
Create table Customer_profile (nationalID int primary key, first_name  Varchar(50), last_name  Varchar(50), email 
Varchar(50), address  Varchar(50), date_of_birth  date )
  
Create table  Customer_Account( (mobileNo  char(11) primary key, pass varchar(50),balance  decimal(10,1),
account_type  Varchar(50), start_date date, status  Varchar(50), point  int, nationalID  int,
FOREIGN KEY (nationalID) REFERENCES Customer_Profile(nationalID))
  
Create table Service_Plan (planID int primary key, SMS_offered  int, minutes_offered  int, data_offered  int, name 
Varchar(50), price int, description  Varchar(50))
  
Create table Subscription (mobileNo  char(11) primary key, planID int primary key, subscription_date  date, status  Varchar(50),
FOREIGN KEY (mobileNo_) references Customer_Account(mobileNo),
FOREIGN KEY (planID) references Service Plan(planID))

Create table Plan_Usage (usageID int primary key, start_date  date, end_date  date, data_consumption  int,
minutes_used  int, SMS_sent  int, mobileNo  char(11), planID  int,
Foreign key Plan_Usage(mobileNo) references Customer_Account.mobileNo,
Foreign key Plan_Usage(planID) references Service_Plan(planID))
  
Create table Payment (paymentID int primary key, amount  decimal (10,1), date_of_payment  date, payment_method 
Varchar(50), status  Varchar(50), mobileNo  char(11),
Foreign Key Payment(mobileNo) references Customer_Account(mobileNo))
  
Create table Process_Payment (paymentID int primary key, planID  int, remaining_balance, extra_amount,
Foreign Key Process_Payment(paymentID) references Payment(paymentID),
Foreign Key Process_Payment(planID) references Service_Plan(planID),
Foreign Key Process_Payment(remaining_balance) as Service_Plan(price) - Payment(amount) if ( Payment(amount) <Service_Plan(price)),
Foreign Key Process_Payment(additional_amounts) as Payment(amount)- Service_Plan(price) if ( Payment(amount) >Service_Plan(price)))
  
Create table  Wallet (walletID int primary key, current_balance  decimal(10,2), currency Varchar(50), last_modified_date 
date, nationalID  int, mobileNo  char(11),
Foreign Key Wallet(nationalID) references Customer_profile(nationalID))

Create table Transfer_money (walletID1 int primary key, walletID2 int primary key, transfer_id int primary key, amount  decimal (10,2),
transfer_date date,
Foreign Key Transfer_money(walletID1) references Wallet(walletID),
Foreign key Transfer_money(walletID2) references Wallet(walletID))
  
Create table Benefits (benefitID int primary key, description  Varchar(50), validity_date  date, status  Varchar(50),
mobileNo  char(11),
Foreign Key Benefits(mobileNo) references Customer_Account(mobileNo))
  
Create table Points Group (pointID int primary key, benefitID int primary key, pointsAmount  int, PaymentID  int,
Foreign Key Points_Group(benefitID) references Benefits(benefitID),
Foreign Key Points_Group(PaymentID) references Payment(PaymentID))
  
Create table Exclusive Offer (offerID int primary key, benefitID int primary key, internet_offered  int, SMS_offered  int,
minutes_offered  int,
Foreign Key  Exclusive_Offer(benefitID) references Benefits(benefitID))
  
Create table Cashback (CashbackID int primary key, benefitID int primary key, walletID  int, amount  int, credit_date date,
Foreign Key Cashback.benefitID references Benefits.benefitID,
Foreign Key Cashback(walletID) references Wallet(walletID))
  
Create table Plan_Provides_Benefits (benefitID int primary key, planID  int primary key,
Foreign Key Plan_Provides_Benefits(benefitID) references Benefits(benefitID),
Foreign Key Plan_Provides_Benefits(planID) references Service Plan(planID))
  
Create table Shop (shopID int primary key, name  varchar(50), category  varchar(50))
  
Create table Physical Shop (shopID int primary key, address varchar(50), working_hours  varchar(50),
Foreign Key Physical_Shop(shopID) references Shop(shopID))
  
Create table E-shop (shopID int primary key, URL  varchar(50), rating  int,
Foreign Key E-shop(shopID) references Shop(shopID))
  
Create table Voucher (voucherID int primary key, value  int, expiry_date  date, points  int, mobileNo  char(11), shopID int,
redeem_date  date,
Foreign Key Voucher(mobileNo) references Customer_Account(mobileNo),
Foreign Key Voucher(shopID) references Shop(shopID))
  
Create table Technical_Support_Ticket (ticketID int primary key, mobileNo  char(11) primary key, Issue_description  Varchar(50),
priority_level int, status  Varchar(50),
Foreign Key Technical_Support_Ticket(mobileNo) references Customer_Account(mobileNo))

