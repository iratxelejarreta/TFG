CREATE DEFINER=`root`@`localhost` FUNCTION `GET_OTHERS_P`(`P_PERIOD` SMALLINT(5), `P_CLASS` SMALLINT(5), `P_GROUP` SMALLINT(5), `P_ROLE` SMALLINT(5)) RETURNS decimal(6,2)
BEGIN
	-- Function GET_OTHERS_P that calculates the results of the members of the group. --

	-- Declare variable --
	declare RESULT DECIMAL(6,2);

	-- Selection of scores associated with other type fields. --
	-- The fields to select depend on the role of each record. --
	-- The result is stored in the RESULT variable. --
    SELECT AVG(CASE 
		WHEN P_ROLE=1 THEN ((O1_1+O1_2+O1_3+O1_4+O1_5+O1_6+O1_7+O1_8+O1_9+O1_10+O1_11+O1_12)/4) 
        WHEN P_ROLE=2 THEN ((O2_1+O2_2+O2_3+O2_4+O2_5+O2_6+O2_7+O2_8+O2_9+O2_10+O2_11+O2_12)/4) 
        WHEN P_ROLE=3 THEN ((O3_1+O3_2+O3_3+O3_4+O3_5+O3_6+O3_7+O3_8+O3_9+O3_10+O3_11+O3_12)/4) 
		ELSE ((O4_1+O4_2+O4_3+O4_4+O4_5+O4_6+O4_7+O4_8+O4_9+O4_10+O4_11+O4_12)/4) 
		END) INTO RESULT 
    FROM FORM F
    INNER JOIN CLASS C ON UPPER(C.COD) = UPPER(F.CLASS) AND C.ID_CLASS=P_CLASS 
    INNER JOIN TEAM E ON E.COD=F.NUM_GROUP AND E.ID_TEAM=P_GROUP 
    WHERE GET_PERIOD(F.MARK)=P_PERIOD AND GET_ROLE(F.ROLE)<>P_ROLE;
   
	-- Return of the result --
	RETURN RESULT;
END