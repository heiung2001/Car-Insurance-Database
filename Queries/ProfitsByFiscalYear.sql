USE nguyenhieu;

SELECT
	sales.FinancialYear,
	sales.Gross,
    CASE
		WHEN expenses.expense IS NULL THEN 0
        ELSE expenses.expense
	END AS AmountSpentOnClaims,
    CASE
		WHEN sales.gross - expenses.expense IS NULL THEN sales.gross
        ELSE sales.gross - expenses.expense
	END AS 'Profit/Loss ($)'
FROM (
	SELECT
		CASE
			WHEN MONTH(policy.PolicyStartDate) >= 6
				THEN concat(YEAR(policy.PolicyStartDate), ' to ', YEAR(policy.PolicyStartDate) + 1)
			ELSE concat(YEAR(policy.PolicyStartDate) - 1, ' to ', YEAR(policy.PolicyStartDate))
		END AS FinancialYear,
        SUM(policy.Price) AS Gross
	FROM policy
	GROUP BY FinancialYear
) AS sales
LEFT JOIN (
	SELECT 
		CASE
			WHEN MONTH(claim.DatePaid) >= 6
				THEN CONCAT(YEAR(claim.DatePaid), ' to ',YEAR(claim.DatePaid) + 1)
			ELSE CONCAT(YEAR(claim.DatePaid)-1,' to ', YEAR(claim.DatePaid))
		END AS FinancialYear,
        SUM(claim.AmountPaidOut) AS expense
	FROM claim
    GROUP BY FinancialYear
    HAVING FinancialYear IS NOT NULL
) AS expenses ON expenses.FinancialYear = sales.FinancialYear;