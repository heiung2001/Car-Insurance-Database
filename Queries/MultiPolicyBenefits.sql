SELECT 
	x.pol1 AS PolicyID,
    x.cus1 AS CustomerID,
    x.pol2 AS PolicyID2,
    x.cus2 AS CustomerID2
FROM(
    SELECT
		P1.ID AS pol1,
        P1.CustomerID AS cus1,
        P1.PolicyStartDate,
        P1.PolicyEndDate,
        P2.CustomerID AS cus2,
        P2.ID AS pol2
    FROM policy AS P1, policy AS P2
    WHERE P1.ID < P2.ID
    AND P1.PolicyStartDate BETWEEN P2.PolicyStartDate AND P2.PolicyEndDate
    OR P1.PolicyEndDate BETWEEN P2.PolicyStartDate AND P2.PolicyEndDate
)AS X
WHERE pol1 <> pol2
AND cus1 = cus2
AND CURDATE() BETWEEN X.PolicyStartDate AND X.PolicyEndDate;