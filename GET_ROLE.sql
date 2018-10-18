CREATE DEFINER=`root`@`localhost` FUNCTION `GET_ROLE`(`P_ROLE` VARCHAR(45)) RETURNS int(2)
BEGIN
	-- GET_ROLE function that returns the role of a record. --

	-- Declare variable --
	DECLARE ROLE INT(2);
	
	-- Selection of the corresponding role code. --
    SELECT ID_ROLE INTO ROLE
    FROM ROLE
    WHERE P_ROLE LIKE CONCAT('%',NAME1,'%'); 
	
	-- Return of the result --
	RETURN ROLE;
END