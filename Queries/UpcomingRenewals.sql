USE nguyenhieu;

SELECT
	Title,
    FName AS 'First Name',
    LName AS 'Last Name',
    EmailAddress,
    TelephoneNumber,
    DATE_FORMAT(CURDATE(), '%d/%m/%Y') AS 'Today Date',
    DATE_FORMAT(PolicyEndDate, '%d/%m/%Y') AS 'Policy End Date',
    DATEDIFF(PolicyEndDate, CURDATE()) AS 'Days left',
	policy.ID AS PolicyID,
    VehicleReg
FROM customer
LEFT JOIN policy ON customer.ID = policy.CustomerID
WHERE PolicyEndDate BETWEEN CURDATE() AND DATE_ADD(NOW(), INTERVAL 30 DAY);