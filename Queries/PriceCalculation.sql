USE nguyenhieu;

SELECT DISTINCT
	PolicyID,
    BasePrice,
    Metric,
    ROUND(((Baseprice/100*metric)/100)*(`PaymentTypePercentageChange(%)`+100),2) as 'totalPrice($)'
FROM (
	SELECT DISTINCT 
		PolicyID,
		(x.VehicleValue / 100) * 25 AS BasePrice,
        (EngineClass + OccupationClass + AgeClass + VehicleModClass + MedicalConditionClass)+100 AS Metric,
        `PaymentTypePercentageChange(%)`
	FROM (
		SELECT
			policy.ID AS PolicyID,
            Fname,
            VehicleReg,
            VehicleValue,
            CASE
				WHEN EngineCC BETWEEN 1000 AND 1199 THEN 0
				WHEN EngineCC BETWEEN 1200 AND 1399 THEN 10
				WHEN EngineCC BETWEEN 1400 AND 1599 THEN 20
				WHEN EngineCC BETWEEN 1600 AND 1799 THEN 30
				WHEN EngineCC BETWEEN 1800 AND 1999 THEN 40
				WHEN EngineCC BETWEEN 2000 AND 2199 THEN 50
				WHEN EngineCC BETWEEN 2200 AND 2399 THEN 60
				WHEN EngineCC BETWEEN 2400 AND 2599 THEN 70
				WHEN EngineCC BETWEEN 2600 AND 2799 THEN 80
				WHEN EngineCC BETWEEN 2800 AND 2999 THEN 90
				WHEN EngineCC BETWEEN 3000 AND 3199 THEN 100
				WHEN EngineCC BETWEEN 3200 AND 3399 THEN 110
				WHEN EngineCC BETWEEN 3400 AND 3599 THEN 120
				WHEN EngineCC BETWEEN 3600 AND 3799 THEN 130
				WHEN EngineCC BETWEEN 3800 AND 3999 THEN 140
                ELSE 200
			END AS EngineClass,
            CASE
				WHEN FLOOR(DATEDIFF(PolicyStartDate, DOB) / 365) <= 16 THEN 30
				WHEN FLOOR(DATEDIFF(PolicyStartDate, DOB) / 365) BETWEEN 17 AND 19 THEN 30
				WHEN FLOOR(DATEDIFF(PolicyStartDate, DOB) / 365) BETWEEN 20 AND 25 THEN 20
				WHEN FLOOR(DATEDIFF(PolicyStartDate, DOB) / 365) BETWEEN 26 AND 29 THEN 10
				WHEN FLOOR(DATEDIFF(PolicyStartDate, DOB) / 365) BETWEEN 30 AND 35 THEN 0
				WHEN FLOOR(DATEDIFF(PolicyStartDate, DOB) / 365) BETWEEN 35 AND 39 THEN -10
				WHEN FLOOR(DATEDIFF(PolicyStartDate, DOB) / 365) BETWEEN 40 AND 49 THEN -20
				WHEN FLOOR(DATEDIFF(PolicyStartDate, DOB) / 365) BETWEEN 50 AND 59 THEN -30
				WHEN FLOOR(DATEDIFF(PolicyStartDate, DOB) / 365) BETWEEN 60 AND 90 THEN 20
                ELSE 0
            END AS AgeClass,
            Modifier  AS OccupationClass,
            CASE
				WHEN SUM(Points) > 1 THEN SUM(Points)
                ELSE 0
			END AS VehicleModClass,
            CASE
				WHEN MedicalCondition = 'No' THEN 0
				WHEN MedicalCondition = 'Yes' THEN 10
				ELSE 20
            END AS MedicalConditionClass,
            CASE
				WHEN PaymentType = 'Annual' THEN 0
				WHEN PaymentType = 'Monthly' THEN 20
				ELSE 10
			END AS 'PaymentTypePercentageChange(%)'
		FROM vehicle
			JOIN policy ON vehicle.Registration = policy.VehicleReg
			JOIN customer ON policy.CustomerID = customer.ID
			JOIN occupation ON customer.Occupation = occupation.ID
			LEFT JOIN mod_vehicle ON vehicle.Registration = mod_vehicle.Reg
			LEFT JOIN `mod` ON mod_vehicle.VehicleMod = `mod`.ID
		GROUP BY PolicyID
    ) AS X
) AS Y
WHERE PolicyID BETWEEN 10000 AND 20000;