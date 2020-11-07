USE RALaundry

--1
SELECT	hs.CustomerId
		,CustomerName
		,[TotalServicePrice] = SUM(ServicePrice)
FROM	MsCustomer c
JOIN	HeaderService hs
ON		c.CustomerId = hs.CustomerId
JOIN	DetailService ds
ON		ds.ServiceId = hs.ServiceId
WHERE	DATENAME(MONTH, ServiceDate) LIKE 'July'
AND		CustomerGender LIKE 'Male'
GROUP BY hs.CustomerId, CustomerName


--2
SELECT	StaffName
		,PurchaseDate
		,[TotalTransaction] = COUNT(dp.PurchaseId)
FROM	MsStaff s, HeaderPurchase hp, DetailPurchase dp
WHERE	s.StaffId = hp.StaffId
AND		hp.PurchaseId = dp.PurchaseId
AND		StaffName LIKE '%o%'
GROUP BY StaffName, PurchaseDate
HAVING	COUNT(dp.PurchaseId) > 1

--3
SELECT	VendorName
		,PurchaseDate = CONVERT(VARCHAR, PurchaseDate, 0)
		,[TotalTransaction] = COUNT(dp.PurchaseId)
		,[TotalPurchasePrice] = SUM(MaterialQuantity*MaterialPrice)
FROM	MsVendor v
JOIN	HeaderPurchase hp
ON		v.VendorId = hp.VendorId
JOIN	DetailPurchase dp
ON		dp.PurchaseId = hp.PurchaseId
JOIN	MsMaterial m
ON		m.MaterialId = dp.MaterialId
GROUP BY VendorName, PurchaseDate
HAVING	VendorName LIKE 'PT. %'
AND		DATEPART(DAY, PurchaseDate) % 2 != 0

--4
SELECT	StaffName
		,MaterialName
		,[TotalTransaction] = COUNT(dp.PurchaseId)
		,[TotalQuantity] = CAST( SUM(MaterialQuantity) AS VARCHAR ) + ' pcs'
FROM	MsStaff s
JOIN	HeaderPurchase hp
ON		s.StaffId = hp.StaffId
JOIN	DetailPurchase dp
ON		dp.PurchaseId = hp.PurchaseId
JOIN	MsMaterial m
ON		m.MaterialId = dp.MaterialId
WHERE	DATENAME(MONTH, PurchaseDate) LIKE 'July'
GROUP BY StaffName, MaterialName
HAVING	SUM(MaterialQuantity) > 9


--5
SELECT	MaterialId = REPLACE(dp.MaterialId, 'MA', 'Material ' )
		,MaterialName = UPPER(MaterialName)
		,PurchaseDate
		,MaterialQuantity
FROM	MsMaterial m
		,HeaderPurchase hp
		,DetailPurchase dp
		,(	SELECT	[AVG_Quantity] = AVG(MaterialQuantity) FROM DetailPurchase ) x --Alias Subquery
WHERE	m.MaterialId = dp.MaterialId
AND		hp.PurchaseId = dp.PurchaseId
GROUP BY dp.MaterialId, MaterialName, PurchaseDate, MaterialQuantity
ORDER BY MaterialId ASC


--6 MENGGUNAKAN ALIAS
SELECT	StaffName
		,CustomerName
		,ServiceDate = CONVERT(VARCHAR, ServiceDate, 106)
FROM	MsStaff s
		,HeaderService hs
		,MsCustomer c
		, (	SELECT	[AVG StaffSalary] = AVG(StaffSalary)
			FROM	MsStaff
		  ) x --Alias Subquery
WHERE	s.StaffId = hs.StaffId
AND		c.CustomerId = hs.CustomerId
AND		StaffSalary > [AVG StaffSalary]
--6 MENGGUNAKAN SUBQUERY
SELECT	StaffName
		,CustomerName
		,ServiceDate = CONVERT(VARCHAR, ServiceDate, 106)
FROM	MsStaff s
JOIN	HeaderService hs
ON		s.StaffId = hs.StaffId
JOIN	MsCustomer c
ON		c.CustomerId = hs.CustomerId
WHERE	StaffSalary > ( SELECT AVG(StaffSalary) FROM MsStaff )




--7 MENGGUNAKAN ALIAS
SELECT	ClothesName
		,[TotalTransaction] = CAST( COUNT(ds.ServiceId) AS VARCHAR ) + ' transaction'
		,[ServiceType] = SUBSTRING(ServiceType , 1,1) 
FROM	MsClothes cl
		,HeaderService hs
		,DetailService ds
		,(	SELECT [AVG_ServicePrice] = AVG(ServicePrice) FROM DetailService ) x -- Alias Subquery
WHERE	ds.ClothesId = cl.ClothesId
AND		hs.ServiceId = ds.ServiceId
AND		ServicePrice < x.AVG_ServicePrice
AND		ClothesType LIKE 'Cotton'
GROUP BY ClothesName, ServiceType

--8 MENGGUNAKAN ALIAS SUBQUERY
SELECT	StaffName
		,[StaffFirstName] = SUBSTRING(StaffName, 1,1)
		,VendorName
		,[VendorPhoneNumber] = '+' + CAST ( REPLACE(VendorPhoneNumber, '08' , '628') AS varchar )
		,[TotalTransaction] = COUNT(dp.PurchaseId)
FROM	MsStaff s
		,MsVendor v
		,HeaderPurchase hp
		,DetailPurchase dp
		,(	SELECT	[AVG_Material] = AVG(MaterialQuantity) FROM DetailPurchase ) x -- ALias
WHERE	s.StaffId = hp.StaffId
AND		v.VendorId = hp.VendorId
AND		dp.PurchaseId = hp.PurchaseId
AND		MaterialQuantity > x.AVG_Material
AND		StaffName LIKE '% %'
GROUP BY StaffName, VendorName, VendorPhoneNumber

--9
CREATE VIEW [ViewMaterialPurchase] AS
SELECT	MaterialName
		,MaterialPrice = 'Rp. ' + CAST( MaterialPrice AS VARCHAR ) + ',-'
		,[TotalTransaction] = COUNT(dp.PurchaseId)
		,[TotalPrice] = SUM(MaterialQuantity*MaterialPrice)
FROM	MsMaterial m
		,HeaderPurchase hp
		,DetailPurchase dp
WHERE	m.MaterialId = dp.MaterialId
AND		dp.PurchaseId = hp.PurchaseId
AND		MaterialType LIKE 'Supplies'
GROUP BY MaterialName, MaterialPrice
HAVING	COUNT(dp.PurchaseId) > 2

SELECT * FROM ViewMaterialPurchase

--10
CREATE VIEW [ViewMaleCustomerTransaction] AS
SELECT	hs.CustomerId -- CustomerName di Project ada 2
		,CustomerName
		,[TotalTransaction] = COUNT(ds.ServiceId)
		,[TotalPrice] = SUM(ServicePrice)
FROM	MsCustomer c
		,HeaderService hs
		,DetailService ds
		,MsClothes cl
WHERE	c.CustomerId = hs.CustomerId
AND		hs.ServiceId = ds.ServiceId
AND		ds.ClothesId = cl.ClothesId
AND		CustomerGender LIKE 'Male'
AND		ClothesType IN ('Wool','Linen')
GROUP BY hs.CustomerId, CustomerName

SELECT * FROM ViewMaleCustomerTransaction