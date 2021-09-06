USE nguyenhieu;
SELECT
	CustomerID,
    Title,
    FName AS FirstName,
    LName AS LastName,
    EmailAddress,
    TelephoneNumber,
    VehicleReg,
    HouseNumber,
    PostCode,
    Price AS 'Price($)'
From customer
LEFT JOIN policy ON customer.ID = policy.CustomerID
LEFT JOIN address ON customer.AddressID = address.ID
WHERE CURDATE() BETWEEN PolicyStartDate AND PolicyEndDate
AND AddressID IN (
	SELECT customer.AddressID
	FROM customer
	GROUP BY AddressID
	HAVING COUNT(AddressID) > 1
)
ORDER BY CustomerID;