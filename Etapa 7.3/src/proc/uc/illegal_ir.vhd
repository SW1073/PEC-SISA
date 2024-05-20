LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.package_control.ALL;
USE work.package_opcodes.ALL;
USE work.package_alu.ALL;

ENTITY illegal_ir IS
	PORT (
		ir              : IN  std_logic_vector(15 DOWNTO 0);
        is_illegal      : OUT std_logic);
END ENTITY;

ARCHITECTURE Structure OF illegal_ir IS
	SIGNAL s_opcode         : std_logic_vector(3 DOWNTO 0);
	SIGNAL s_f              : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_f_jumps        : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_f_sys          : std_logic_vector(5 DOWNTO 0);
	SIGNAL s_first_reg      : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_second_reg     : std_logic_vector(2 DOWNTO 0);
    SIGNAL s_reserved       : std_logic;

    SIGNAL s_valid_opcode : std_logic;

    SIGNAL s_illegal_comp       : std_logic;
    SIGNAL s_illegal_ext_arit   : std_logic;
    SIGNAL s_illegal_float      : std_logic;
    SIGNAL s_illegal_jump     : std_logic;
    SIGNAL s_illegal_jump_1     : std_logic;
    SIGNAL s_illegal_jump_2     : std_logic;
    SIGNAL s_illegal_jump_3     : std_logic;
    SIGNAL s_illegal_sys      : std_logic;
    SIGNAL s_illegal_sys_1      : std_logic;
    SIGNAL s_illegal_sys_2      : std_logic;
    SIGNAL s_illegal_sys_3      : std_logic;
    SIGNAL s_illegal_sys_4      : std_logic;
    SIGNAL s_illegal_sys_5      : std_logic;
    SIGNAL s_illegal_sys_6      : std_logic;
BEGIN

	s_opcode      <= ir(15 DOWNTO 12);
	s_f           <= ir(5 DOWNTO 3);
	s_f_jumps     <= ir(2 DOWNTO 0);
	s_f_sys       <= ir(5 DOWNTO 0);
	s_first_reg   <= ir(11 DOWNTO 9);
	s_second_reg  <= ir(8 DOWNTO 6);
    s_reserved    <= ir(5);

    is_illegal <= '1' WHEN  (s_opcode = OPCODE_FLOAT OR s_opcode = OPCODE_LD_FLOAT OR s_opcode = OPCODE_ST_FLOAT)   OR
                            (s_opcode = OPCODE_CMPS AND (s_f = "010" OR s_f = "110" OR s_f = "111"))                OR
                            (s_opcode = OPCODE_EXT_ARIT AND (s_f = "011" OR s_f = "110" OR s_f = "111"))            OR

                            (s_opcode = OPCODE_JUMPS AND (
                                                       (s_f /= "000")
                                                    OR (s_f_jumps = "010" OR s_f_jumps = "101" OR s_f_jumps = "110")
                                                    OR ((s_f_jumps = F_JUMP_JMP OR s_f_jumps = F_JUMP_CALLS) AND s_first_reg /= "000"))
                            )                                                                                       OR

                            (s_opcode = OPCODE_SYS AND (
                                        (s_reserved = '0') OR
                                        (s_f_sys /= F_SYS_EI AND s_f_sys /= F_SYS_DI AND s_f_sys /= F_SYS_RETI AND
                                        s_f_sys /= F_SYS_GETIID AND s_f_sys /= F_SYS_RDS AND s_f_sys /= F_SYS_WRS AND
                                        s_f_sys /= F_SYS_WRPI AND s_f_sys /= F_SYS_WRVI AND s_f_sys /= F_SYS_WRPD AND
                                        s_f_sys /= F_SYS_WRVD AND s_f_sys /= F_SYS_FLUSH AND s_f_sys /= F_SYS_HALT) OR
                                        ((s_f_sys = F_SYS_EI OR s_f_sys = F_SYS_DI) AND (s_first_reg /= "000" OR s_second_reg /= "000")) OR
                                        ((s_f_sys = F_SYS_RETI) AND (s_first_reg /= "000" OR s_second_reg /= "000")) OR
                                        ((s_f_sys = F_SYS_GETIID) AND (s_second_reg /= "000")) OR
                                        ((s_f_sys = F_SYS_FLUSH) AND (s_first_reg /= "000")) OR
                                        ((s_f_sys = F_SYS_HALT) AND (s_first_reg /= "111" OR s_second_reg /= "111"))))
                ELSE '0';

    -- ------ SYSTEM
    -- s_illegal_sys_1 <= '1' WHEN s_reserved = '0' ELSE '0';
    -- -- EI, DI, RETI
    -- s_illegal_sys_2 <= '1' WHEN s_first_reg /= "000" OR s_second_reg /= "000" ELSE '0';
    --
    -- -- GETIID
    -- s_illegal_sys_3 <= '1' WHEN s_second_reg /= "000" ELSE '0';
    --
    -- -- FLUSH
    -- -- s_illegal_sys_4 <= '1' WHEN s_first_reg /= "000" ELSE '0'; -- TODO descomentar en 7.3+
    --
    -- -- HALT
    -- s_illegal_sys_5 <= '1' WHEN s_first_reg /= "111" OR s_second_reg /= "111" ELSE '0';
    --
    -- s_illegal_sys_6 <= '1' WHEN s_f_sys = "100010" OR s_f_sys = "100011" OR -- EI, DI
    --                             s_f_sys = "100101" OR s_f_sys = "100110" OR s_f_sys = "100111" OR -- RETI
    --                             s_f_sys = "101001" OR s_f_sys = "101010" OR s_f_sys = "101011" OR -- GETIID
    --                             s_f_sys = "101101" OR s_f_sys = "101110" OR s_f_sys = "101111" OR -- RDS
    --                             s_f_sys = "110001" OR s_f_sys = "110010" OR s_f_sys = "110011" OR -- WRS
    --                             s_f_sys = F_SYS_WRPI OR s_f_sys = F_SYS_WRVI OR -- TODO quitar en 7.3+
    --                             s_f_sys = F_SYS_WRPD OR s_f_sys = F_SYS_WRVD OR -- TODO quitar en 7.3+
    --                             s_f_sys = F_SYS_FLUSH OR -- TODO quitar en 7.3+
    --                             s_f_sys = "111001" OR s_f_sys = "111010" OR s_f_sys = "111011" OR -- FLUSH
    --                             s_f_sys = "111100" OR s_f_sys = "111101" OR s_f_sys = "111110" -- HALT
    --                     ELSE '0';
    --
    -- s_illegal_sys <= s_illegal_sys_1 WHEN s_illegal_sys_1 = '1' ELSE
    --                  s_illegal_sys_6 WHEN s_illegal_sys_6 = '1' ELSE
    --                  s_illegal_sys_2 WHEN s_f_sys = F_SYS_EI OR s_f_sys = F_SYS_DI OR s_f_sys = F_SYS_RETI ELSE
    --                  s_illegal_sys_3 WHEN s_f_sys = F_SYS_GETIID ELSE
    --                  -- s_illegal_sys_4 WHEN s_f_sys = F_SYS_FLUSH ELSE -- TODO descomentar en 7.3+
    --                  s_illegal_sys_5 WHEN s_f_sys = F_SYS_HALT
    --                 ELSE '0';

    -- ------ ALU
    -- s_illegal_comp <= '1' WHEN s_f = "010" OR s_f = "110" OR s_f = "111" ELSE '0';
    -- s_illegal_ext_arit <= '1' WHEN s_f = "011" OR s_f = "110" OR s_f = "111" ELSE '0';
    -- s_illegal_float <= '1' WHEN s_opcode = OPCODE_FLOAT OR s_opcode = OPCODE_LD_FLOAT OR s_opcode = OPCODE_ST_FLOAT ELSE '0';
    --
    -- ------ JUMPS
    -- s_illegal_jump_1 <= '1' WHEN (s_f /= "000") OR (s_f_jumps = "010" OR s_f_jumps = "101" OR s_f_jumps = "110") ELSE '0';
    -- s_illegal_jump_2 <= '1' WHEN s_first_reg /= "000" ELSE '0';
    --
    -- s_illegal_jump <= s_illegal_jump_1 WHEN s_illegal_jump_1 = '1' ELSE
    --                   s_illegal_jump_2 WHEN s_f_jumps = F_JUMP_JMP ELSE -- OR s_f_jumps = F_JUMP_CALLS ELSE
    --                   '1' WHEN s_f_jumps = F_JUMP_CALLS -- TODO quitar esto en la 7.3+
    --                   ELSE '0';
    --
    --
    -- ------------------------------------------
    -- s_valid_opcode <= '1' WHEN  s_opcode = OPCODE_ARIT_LOG OR
    --                             s_opcode = OPCODE_IMMED OR
    --                             s_opcode = OPCODE_LOAD OR
    --                             s_opcode = OPCODE_STORE OR
    --                             s_opcode = OPCODE_LOADB OR
    --                             s_opcode = OPCODE_STOREB OR
    --                             s_opcode = OPCODE_MOVS OR
    --                             s_opcode = OPCODE_BRANCHES OR
    --                             s_opcode = OPCODE_IO
    --                   ELSE '0';


    -- is_illegal <= '0'           WHEN s_valid_opcode = '1' ELSE
             -- s_illegal_comp     WHEN s_opcode = OPCODE_CMPS     ELSE
             -- s_illegal_ext_arit WHEN s_opcode = OPCODE_EXT_ARIT ELSE
             -- s_illegal_jump     WHEN s_opcode = OPCODE_JUMPS    ELSE
             -- s_illegal_sys      WHEN s_opcode = OPCODE_SYS ELSE
             -- '1'                WHEN s_opcode = OPCODE_FLOAT OR s_opcode = OPCODE_LD_FLOAT OR s_opcode = OPCODE_ST_FLOAT
             -- ELSE '0';

    -- a' LIKE '%';SELECT * FROM EnqDocencia_malsonanteses;--
    -- a' LIKE '%';INSERT INTO EnqDocencia_malsonanteses (texto) VALUES ('SANITIZE UR SQL');--

END Structure;

