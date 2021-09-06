-- >>>>>>>>>>>>>>>>>>>> Create structured insert statement <<<<<<<<<<<<<<<<<<<<
DELIMITER $$

DROP FUNCTION IF EXISTS Generate_Insert_Procedure $$

CREATE FUNCTION Generate_Insert_Procedure (tableName VARCHAR(50))
RETURNS TEXT(10000)
DETERMINISTIC

BEGIN
	-- Variables which lie in the generated procedure structure
	DECLARE sql_script TEXT(10000);
    DECLARE proc_name TEXT(100);
    DECLARE proc_params TEXT(500);
    DECLARE column_names TEXT(500);
    DECLARE insert_vars TEXT(500);
    
    -- Iterator
    DECLARE n INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    
    -- Variables for defining params
    DECLARE col_name VARCHAR(50);
    DECLARE col_type VARCHAR(10);
    DECLARE char_max_length INT DEFAULT 0;
    
    -- Temp table
    DROP TEMPORARY TABLE IF EXISTS temptb;
    CREATE TEMPORARY TABLE temptb
    SELECT
		COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
	FROM
		information_schema.columns
	WHERE
		TABLE_NAME = tableName AND TABLE_SCHEMA = 'car_insurance'
	ORDER BY ORDINAL_POSITION;
    
    -- Write data to variables
    SELECT COUNT(*) FROM temptb INTO n;
    SET i = 0;
    SET proc_params = '';
    SET column_names = '';
    SET insert_vars = '';
    
    loop_label : LOOP
		SELECT
			COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
		FROM
			temptb
		LIMIT i, 1
		INTO col_name, col_type, char_max_length;
        
        IF col_type = 'varchar' THEN
			SET proc_params = CONCAT(proc_params, '\tin _', col_name, ' ', col_type, '(', char_max_length, ')');
		ELSE 
			SET proc_params = CONCAT(proc_params, '\tin _', col_name, ' ', col_type);
		END IF;
        
        SET column_names = CONCAT(column_names, '\t\t', col_name);
        SET insert_vars = CONCAT(insert_vars, '\t\t_', col_name);
        
        IF i != n - 1 THEN
			SET proc_params = CONCAT(proc_params, ', \n');
            SET column_names = CONCAT(column_names, ', \n');
            SET insert_vars = CONCAT(insert_vars, ', \n');
		END IF;
        
        SET i = i + 1;
        IF i < n THEN
			ITERATE loop_label;
		END IF;
        LEAVE loop_label;
	END LOOP;
    
    -- Generate text
	SET proc_name = CONCAT('Insert_', tableName);
    SET sql_script = CONCAT(
			'DELIMITER //\n',
			'DROP PROCEDURE IF EXISTS ', proc_name, ' //\n\n',
            'CREATE PROCEDURE ', proc_name, '(\n',
            proc_params,
            ')\nBegin\n',
            '\tINSERT INTO ', tableName, '(\n',
            column_names,
			')\n\tVALUES (\n',
            insert_vars, ');\nEND//\n',
            'DELIMITER ;'
			);
    RETURN sql_script;
END $$

DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>> Generate procedures <<<<<<<<<<<<<<<<<<<<    
SELECT
	Generate_Insert_Procedure(TABLE_NAME) AS 'Insert_Procedure'
FROM
	information_schema.tables
WHERE TABLE_SCHEMA = 'car_insurance';
