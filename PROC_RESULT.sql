CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_RESULT`()
BEGIN
-- Stored procedure PROC_RESULT that includes all the calculations of the solution. --

-- Declare variables --
DECLARE V_CLASS SMALLINT(5) DEFAULT 0;
DECLARE V_USER SMALLINT(5) DEFAULT 0;
DECLARE V_PERIOD SMALLINT(5) DEFAULT 0;
DECLARE V_TEAM SMALLINT(5) DEFAULT 0;
DECLARE V_ROLE SMALLINT(5) DEFAULT 0;
DECLARE V_AVG_G DECIMAL(6,2) DEFAULT 0;
DECLARE V_AVG_P DECIMAL(6,2) DEFAULT 0;
DECLARE V_AVG_O DECIMAL(6,2) DEFAULT 0;
DECLARE V_L1 varchar(255) DEFAULT "";
DECLARE V_L2 varchar(255) DEFAULT "";
DECLARE V_L3 varchar(255) DEFAULT "";
DECLARE V_L4 varchar(255) DEFAULT "";
DECLARE V_L5 varchar(255) DEFAULT "";
DECLARE V_L6 varchar(255) DEFAULT "";
DECLARE V_L7 varchar(255) DEFAULT "";
DECLARE V_L8 varchar(255) DEFAULT "";
DECLARE V_L9 varchar(255) DEFAULT "";
DECLARE V_L10 varchar(255) DEFAULT "";
DECLARE V_L11 varchar(255) DEFAULT "";
DECLARE V_DONE INTEGER DEFAULT FALSE;

-- Declare cursor --
DECLARE C1 CURSOR FOR (
    SELECT C1.ID_CLASS,
	U1.ID_USER,
    P1.ID_PERIOD,
	E1.ID_TEAM,
	R1.ID_ROLE,
    F1.L1, F1.L2, F1.L3, F1.L4, F1.L5, F1.L6, F1.L7, F1.L8, F1.L9, F1.L10, F1.L11
	FROM FORM F1
	INNER JOIN PERIOD P1 ON STR_TO_DATE(substring(f1.MARK,1,9),'%m/%d/%Y') between P1.DATE_FROM AND P1.DATE_TO
    INNER JOIN CLASS C1 ON UPPER(C1.COD) = UPPER(F1.CLASS)
    INNER JOIN USER U1 ON UPPER(U1.SURNAME1)=UPPER(F1.SURNAME1) AND UPPER(U1.SURNAME2)=UPPER(F1.SURNAME2) AND UPPER (U1.NAME1)=UPPER(F1.NAME1) 
    INNER JOIN TEAM E1 ON E1.CODIGO=F1.NUM_GROUP
    INNER JOIN ROLE R1 ON F1.ROLE LIKE CONCAT('%',R1.NAME1,'%')
);
DECLARE CONTINUE HANDLER FOR NOT FOUND SET V_DONE = TRUE;

OPEN C1;

-- Scroll cursor records --
read_loop: LOOP

	FETCH C1 INTO V_CLASS, V_USER, V_PERIOD, V_TEAM, V_ROLE, V_L1, V_L2, V_L3, V_L4, V_L5, V_L6, V_L7, V_L8, V_L9, V_L10, V_L11;   
    
 	IF V_DONE THEN
    	LEAVE read_loop;
	END IF;
    
    -- Call function that returns the group score --
    SET V_AVG_G = GET_GROUP_P(V_PERIOD, V_CLASS, V_TEAM);
    
    -- Call procedure that calculates personal score --
    CALL P_PERSONAL(V_PERIOD, V_CLASS, V_TEAM, V_ROLE, @V_AVG_P);
    SET V_AVG_P = @V_AVG_P;
    
    -- Call function that returns score rest of group members --
    SET V_AVG_O = GET_OTHERS_P(V_PERIOD, V_CLASS, V_TEAM, V_ROLE);

	-- Insert records with calculated scores --
    INSERT INTO RESULT (`id_CLASS`, `id_USER`, `id_PERIOD`, `id_TEAM`, `id_ROLE`, `avg_g`, `avg_p`, `avg_o`, `L1`, `L2`, `L3`, `L4`, `L5`, `L6`, `L7`, `L8`, `L9`, `L10`, `L11`) 
    VALUES (V_CLASS, V_USER, V_PERIOD, V_TEAM, V_ROLE, IFNULL(V_AVG_G,0), IFNULL(V_AVG_P,0), IFNULL(V_AVG_O,0), V_L1, V_L2, V_L3, V_L4, V_L5, V_L6, V_L7, V_L8, V_L9, V_L10, V_L11)
    ON DUPLICATE KEY UPDATE
    `avg_g`=IFNULL(V_AVG_G,0), 
    `avg_p`=IFNULL(V_AVG_P,0), 
    `avg_o`=IFNULL(V_AVG_O,0), 
    `L1`=V_L1, 
    `L2`=V_L2, 
    `L3`=V_L3, 
    `L4`=V_L4, 
    `L5`=V_L5, 
    `L6`=V_L6, 
    `L7`=V_L7, 
    `L8`=V_L8, 
    `L9`=V_L9, 
    `L10`=V_L10, 
    `L11`=V_L11;	

END LOOP;

CLOSE C1;

END