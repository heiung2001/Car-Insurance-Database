-- thêm chính sách mới
USE test;

START TRANSACTION;

SELECT
	@AddID := MAX(ID) + 1
FROM address;
SELECT
	@OccID := MAX(ID) + 1
FROM occupation;
SELECT
	@CusID := MAX(ID) + 1
FROM customer;
SELECT
	@PolID := MAX(ID) + 1
FROM policy;


INSERT INTO
	address(ID, PostCode, HouseNumber)
VALUES
	(@AddID, 10000, 5);

INSERT INTO
	occupation(ID, OccupationDescription, Modifier)
VALUES
	(@OccID, 'student', 20);

INSERT INTO
	customer(ID, Title, FName, LName, DOB, Homeowner, Dependants, MaritalStatus, Occupation, ClaimsIn5Years, TimeInUKSince, AddressID, LicenceType, LicenceLocation, LicenceNumber, AdditionalQualification, MedicalCondition, UnspentMotoringConvictions, TelephoneNumber, EmailAddress)
VALUES
	(@CusID, 'Mr.', 'Hieu', 'Nguyen', '2001-02-12', 0, 0, 'single', @OccID, 0, CURDATE(), @AddID, 'Full', 'VN', 001201006959, 'None', 'No', 0, 0382128612, 'hieu.working2001@gmail.com');
        
INSERT INTO 
	policy(ID, CustomerID, VehicleReg, VehicleUsage, EstimatedMileage, PolicyStartDate, PolicyEndDate, CoverType, PaymentType, Excess, YearsNCB, OvernightStorage, Price)
VALUES 
		(@PolID, @CusID, 'aa31qcn', 'SocialOnly', 6000, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'FullyComprehensive', 'Monthly', 1000, 5, 'DriveWay', 3457);

COMMIT;