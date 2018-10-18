CREATE DEFINER=`root`@`localhost` FUNCTION `GET_GROUP_P`(`P_PERIOD` SMALLINT(5), `P_CLASS` SMALLINT(5), `P_GROUP` SMALLINT(5)) RETURNS decimal(6,2)
BEGIN
	-- Function GET_GROUP_P that calculates the group results. --
	
	-- Declare variable --
	DECLARE RESULT DECIMAL(6,2);
    
	-- Selection of the scores associated with group type fields. --
    SELECT (AVG(F.G1) + AVG(F.G2) + AVG(F.G3) + AVG(F.G4)) / COUNT(*) INTO RESULT
	FROM FORM F
    INNER JOIN CLASS C ON UPPER(C.COD) = UPPER(F.CLASS) AND C.ID_CLASS=P_CLASS
    INNER JOIN TEAM E ON E.COD=F.NUM_GROUP AND E.ID_TEAM=P_GROUP
    WHERE P_PERIOD = GET_PERIOD(F.MARK);
   
	-- Return of the result --
	RETURN RESULT;
END