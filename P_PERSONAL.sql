CREATE DEFINER=`root`@`localhost` PROCEDURE `P_PERSONAL`(IN `P_PERIOD` SMALLINT(5), IN `P_CLASS` SMALLINT(5), IN `P_GROUP` SMALLINT(5), IN `P_ROLE` SMALLINT(5), OUT `RESULT` DECIMAL(6,2))
BEGIN
-- Stored procedure P_PERSONAL that calculates personal type results. --

-- Selection of personal type columns. --
-- The fields names to be selected are stored in the temporary variable sub. --
-- The number of fields is stored in the temporary variable sub2 to calculate the average. --

SELECT GROUP_CONCAT(CONCAT(" ",CAST(column_name as CHAR(50)))), count(*) FROM information_schema.columns WHERE table_name='form' AND column_name LIKE 'P%' INTO @sub, @sub2;

SET @sub = REPLACE(@sub,',','+');

-- Assign the name of the table to the temporary variable table --
SET @table = 'form';

-- SQL statements construction to execute in the temporary variable --
SET @s = CONCAT('SELECT (', @sub,')/5 into @val FROM ', @table, ' F1 INNER JOIN CLASS C1 ON UPPER(C1.COD) = UPPER(F1.CLASS) AND C1.ID_CLASS=', P_CLASS, ' INNER JOIN TEAM E1 ON E1.COD=F1.NUM_GROUP AND E1.ID_TEAM=', P_GROUP , ' WHERE GET_ROLE(F1.ROLE)=', P_ROLE, ' AND GET_PERIOD(F1.MARK)=', P_PERIOD); 

PREPARE stmt FROM @s;

-- Execute the dynamic query --
EXECUTE stmt;
DEALLOCATE PREPARE stmt; 

-- Returns the result of the query --
set result = @val;

END