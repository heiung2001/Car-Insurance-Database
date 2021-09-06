USE clone_car_insurance;

DELIMITER $$

-- clone table from another database --
DROP PROCEDURE IF EXISTS copy_table_from_schema$$
CREATE PROCEDURE copy_table_from_schema (IN tableName VARCHAR(50), IN fromSchema VARCHAR(255))
BEGIN
	DECLARE sourceTable VARCHAR(255);
    SET sourceTable = CONCAT(fromSchema, '.', tableName);
    
    SET @sql_script = CONCAT('DROP TABLE IF EXISTS ', tableName);
    PREPARE statement FROM @sql_script;
    EXECUTE statement;
    
    SET @sql_script = CONCAT('CREATE TABLE ', tableName, ' LIKE ', sourceTable, ';');
    PREPARE statement FROM @sql_script;
    EXECUTE statement;

	SET @sql_script = CONCAT('INSERT ', tableName,
								'\nSELECT * FROM ', sourceTable, ';');
	PREPARE statement FROM @sql_script;
    EXECUTE statement;

	DEALLOCATE PREPARE statement;
END$$

DROP PROCEDURE IF EXISTS copy_all_from_schema$$
CREATE PROCEDURE copy_all_from_schema (IN fromSchema VARCHAR(255))
BEGIN
	DECLARE n INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE tableName VARCHAR(255);
    
    DROP TEMPORARY TABLE IF EXISTS temptb;
    CREATE TEMPORARY TABLE temptb
    SELECT
		TABLE_NAME
	FROM
		information_schema.tables
	WHERE
		TABLE_SCHEMA = fromSchema;
	
    SELECT COUNT(*)
    FROM temptb
    INTO n;
    
    SET i = 0;
    loop_label : LOOP
		SELECT
			TABLE_NAME
		FROM temptb LIMIT i, 1
        INTO tableName;
        
        CALL copy_table_from_schema(tableName, fromSchema);
        
        SET i = i + 1;
        IF i < n THEN 
			ITERATE loop_label;
		ELSE LEAVE loop_label;
        END IF;
    END LOOP;
END$$

DELIMITER ;

--  CALL clone_car_insurance.copy_all_from_schema('car_insurance');  -- 