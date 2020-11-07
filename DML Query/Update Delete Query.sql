	USE RALaundry

	-- Mengupdate Nomor Telpon Vendor yang awalnya 628 menjadi 08
	UPDATE	MsVendor
	SET		VendorPhoneNumber = REPLACE(VendorPhoneNumber, '628' ,'08')

	-- Mengupdate Alamat Albert Theo
	UPDATE	MsCustomer
	SET		CustomerAddress = 'Sukabumi'
	WHERE	CustomerName LIKE 'Albert Theo'

	-- Mengupdate Salary Staff yang berkode ST010
	UPDATE MsStaff
	SET		StaffSalary = 3000000
	WHERE	StaffId LIKE 'ST010'

	-- Menambahkan Insert di Table Staff
	INSERT INTO MsStaff
	VALUES ( 'ST016' , 'Popo Fianto' , 'Samarinda' , 'Male' , 2250000 )

	-- Tambahan Insert untuk ditampilkan di Table Query
	INSERT INTO HeaderPurchase
	VALUES ('PU016' , 'ST016', 'VE007' , '2019/07/30' )

	INSERT INTO DetailPurchase
	VALUES ('PU016' , 'MA008' , 16 )

	INSERT INTO DetailPurchase
	VALUES ('PU016' , 'MA001' , 10 )

	--Delete Staff
	DELETE MsStaff
	WHERE StaffName LIKE 'Julian' AND StaffId LIKE 'ST015'