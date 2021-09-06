EXPLAIN SELECT 
	PolicyID,
    FName,
    PolicyStartDate,
    YearsNCB
FROM part_Table
	JOIN policy ON part_table.PolicyID = policy.ID
WHERE EngineClass IN (10, 50, 80, 140);