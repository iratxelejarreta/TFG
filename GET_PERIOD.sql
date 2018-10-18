CREATE DEFINER=`root`@`localhost` FUNCTION `GET_PERIOD`(P_MARK varchar(30)) RETURNS int(2)
BEGIN
	-- Function GET_PERIOD that calculates the period from a record date. --
	
	-- Declare variable --
	DECLARE PERIOD INT(2);
    
	-- Selection of the period corresponding to the brand --
	SELECT ID_PERIOD INTO PERIOD
    FROM period
    WHERE STR_TO_DATE(substring(P_MARK,1,9),'%m/%d/%Y') between DATE_FROM AND DATE_TO; 

	-- Return of the result --
	RETURN PERIOD;
END