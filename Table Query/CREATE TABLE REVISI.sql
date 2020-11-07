CREATE DATABASE RALaundry

USE RALaundry


--Create Table Customer
CREATE TABLE MsCustomer
(
	CustomerId VARCHAR(6) PRIMARY KEY
	CHECK ( CustomerId LIKE 'CU[0-9][0-9][0-9]' )
	,CustomerName VARCHAR(255) NOT NULL
	,CustomerAddress VARCHAR(255) NOT NULL
	,CustomerGender VARCHAR(255) NOT NULL
	CHECK ( CustomerGender LIKE 'Female' OR CustomerGender LIKE 'Male' )
	,CustomerDOB DATE
)

-- Create Table Staff
CREATE TABLE MsStaff
(
	StaffId VARCHAR(6) PRIMARY KEY
	CHECK ( StaffId LIKE 'ST[0-9][0-9][0-9]' )
	,StaffName VARCHAR(255) NOT NULL
	,StaffAddress VARCHAR (255) NOT NULL
	,StaffGender VARCHAR(10) NOT NULL
	CHECK ( StaffGender LIKE 'Female' OR StaffGender LIKE 'Male' )
	,StaffSalary INT
	CHECK ( StaffSalary BETWEEN 1500000 AND 3000000 )
)


-- Create Table Material
CREATE TABLE MsMaterial
(
	MaterialId VARCHAR(6) PRIMARY KEY
	CHECK ( MaterialId LIKE 'MA[0-9][0-9][0-9]' )
	,MaterialName VARCHAR(255) NOT NULL
	,MaterialType VARCHAR(10) NOT NULL
	CHECK ( MaterialType LIKE 'Equipment' OR MaterialType LIKE 'Supplies' )
	,MaterialPrice INT NOT NULL
)

-- Create Table Vendor
CREATE TABLE MsVendor
(
	VendorId VARCHAR(6) PRIMARY KEY
	CHECK ( VendorId LIKE 'VE[0-9][0-9][0-9]' )
	,VendorName VARCHAR(255) NOT NULL
	,VendorAddress VARCHAR(255) NOT NULL
	,VendorPhoneNumber VARCHAR(255) NOT NULL
)

-- Create Table Clothes
CREATE TABLE MsClothes
(
	ClothesId VARCHAR(6) PRIMARY KEY
	CHECK ( ClothesId LIKE 'CL[0-9][0-9][0-9]' )
	,ClothesName VARCHAR(255) NOT NULL
	,ClothesType VARCHAR(255)  NOT NULL
	CHECK ( ClothesType IN ('Cotton','Linen','Viscose','Polyester','Wool') )
)

-- Create Table Service Transaction ( Header Service, Detail Service )
CREATE TABLE HeaderService
(
	ServiceId VARCHAR(6) PRIMARY KEY
	CHECK ( ServiceId LIKE 'SR[0-9][0-9][0-9]' )
	,CustomerId VARCHAR(6) FOREIGN KEY ( CustomerId ) REFERENCES MsCustomer ( CustomerId )
	ON UPDATE CASCADE ON DELETE CASCADE
	,StaffId VARCHAR(6) FOREIGN KEY ( StaffId ) REFERENCES MsStaff ( StaffId )
	ON UPDATE CASCADE ON DELETE CASCADE
	,ServiceType VARCHAR(255) NOT NULL
	CHECK ( ServiceType IN ('Laundry Service','Ironing Service','Dry Cleaning Service') )
	,ServiceDate DATE NOT NULL
	CHECK ( YEAR(ServiceDate) LIKE YEAR(GETDATE()) )
)


CREATE TABLE DetailService
(
	ServiceId VARCHAR(6) FOREIGN KEY ( ServiceId ) REFERENCES HeaderService ( ServiceId )
	ON UPDATE CASCADE ON DELETE CASCADE
	,ClothesId VARCHAR(6) FOREIGN KEY ( ClothesId ) REFERENCES MsClothes ( ClothesId )
	ON UPDATE CASCADE ON DELETE CASCADE
	,ServicePrice INT NOT NULL
)

-- Create Table Purchase Transaction ( Header Purchase, Detail Purchase )
CREATE TABLE HeaderPurchase
(
	PurchaseId VARCHAR(6) PRIMARY KEY
	,StaffId VARCHAR(6) FOREIGN KEY ( StaffId ) REFERENCES MsStaff ( StaffId )
	ON UPDATE CASCADE ON DELETE CASCADE
	,VendorId VARCHAR(6) FOREIGN KEY ( VendorId ) REFERENCES MsVendor ( VendorId )
	ON UPDATE CASCADE ON DELETE CASCADE
	,PurchaseDate DATE NOT NULL
	CHECK ( YEAR(PurchaseDate) LIKE YEAR(GETDATE()) )
)

CREATE TABLE DetailPurchase
(
	PurchaseId VARCHAR(6) FOREIGN KEY ( PurchaseId ) REFERENCES HeaderPurchase ( PurchaseId )
	ON UPDATE CASCADE ON DELETE CASCADE
	,MaterialId VARCHAR(6) FOREIGN KEY ( MaterialId ) REFERENCES MsMaterial ( MaterialId )
	ON UPDATE CASCADE ON DELETE CASCADE
	,MaterialQuantity INT
)

