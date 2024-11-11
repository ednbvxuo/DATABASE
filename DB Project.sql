CREATE DATABASE Telecom_Team_4
use DATABASE Telecom_Team_4
create procedure createAllTables AS
Begin 
Create table Customer_profile(
nationalID INT PRIMARY KEY,first_name VARCHAR(50),last_name VARCHAR(50),email VARCHAR(50),address VARCHAR(50),date_of_birth DATE)
