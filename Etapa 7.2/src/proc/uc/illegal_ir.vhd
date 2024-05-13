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

    SIGNAL s_illegal_comp       : std_logic;
    SIGNAL s_illegal_ext_arit   : std_logic;
    SIGNAL s_illegal_float      : std_logic;
    SIGNAL s_illegal_jump_1     : std_logic;
    SIGNAL s_illegal_jump_2     : std_logic;
    SIGNAL s_illegal_jump_3     : std_logic;
    SIGNAL s_illegal_reserved   : std_logic;
    SIGNAL s_illegal_sys_1      : std_logic;
    SIGNAL s_illegal_sys_2      : std_logic;
    SIGNAL s_illegal_sys_3      : std_logic;
    SIGNAL s_illegal_sys_4      : std_logic;
    SIGNAL s_illegal_sys_5      : std_logic;
    SIGNAL s_illegal_sys_6      : std_logic;
    SIGNAL s_illegal_sys_7      : std_logic;
    SIGNAL s_illegal_sys_8      : std_logic;
    SIGNAL s_illegal_sys_9      : std_logic;
    SIGNAL s_illegal_sys_10     : std_logic;
    SIGNAL s_illegal_sys_11     : std_logic;
    SIGNAL s_illegal_sys_12     : std_logic;
    SIGNAL s_illegal_sys_13     : std_logic;
BEGIN

	s_opcode      <= ir(15 DOWNTO 12);
	s_f           <= ir(5 DOWNTO 3);
	s_f_jumps     <= ir(2 DOWNTO 0);
	s_f_sys       <= ir(5 DOWNTO 0);
	s_first_reg   <= ir(11 DOWNTO 9);
	s_second_reg  <= ir(8 DOWNTO 6);
    s_reserved    <= ir(5);

    s_illegal_comp <= '1' WHEN s_opcode = OPCODE_CMPS AND
                                (s_f = "010" OR s_f = "110" OR s_f = "111")
                        ELSE '0';
    s_illegal_ext_arit <= '1' WHEN s_opcode = OPCODE_EXT_ARIT AND 
                                (s_f = "011" OR s_f = "110" OR s_f = "111")
                        ELSE '0';
    s_illegal_float <= '1' WHEN s_opcode = OPCODE_FLOAT OR s_opcode = OPCODE_LD_FLOAT OR s_opcode = OPCODE_ST_FLOAT -- AND (s_f = "110");
                        ELSE '0';

    s_illegal_jump_1 <= '1' WHEN s_opcode = OPCODE_JUMPS AND (s_f /= "000" OR s_f_jumps = F_JUMP_CALLS) -- TODO quitar calls en 7.3+
                        ELSE '0';

    s_illegal_jump_2 <= '1' WHEN s_opcode = OPCODE_JUMPS AND
                                (s_f_jumps = "010" OR s_f_jumps = "101" OR s_f_jumps = "110")
                        ELSE '0';

    s_illegal_jump_3 <= '1' WHEN s_opcode = OPCODE_JUMPS AND
                                (
                                    (s_f_jumps = F_JUMP_JMP) -- OR s_f_jumps = F_JUMP_CALLS)
                                    AND
                                    (s_first_reg /= "000")
                                )
                        ELSE '0';

    s_illegal_sys_1 <= '1' WHEN s_opcode = OPCODE_SYS AND (s_reserved = '0')
                        ELSE '0';

    -- EI, DI
    s_illegal_sys_2 <= '1' WHEN s_opcode = OPCODE_SYS AND 
                                (s_f_sys = "100010" OR s_f_sys = "100011") 
                        ELSE '0';

        s_illegal_sys_9 <= '1' WHEN s_opcode = OPCODE_SYS AND
                                    (s_f_sys = F_SYS_EI OR s_f_sys = F_SYS_DI) AND
                                    (s_first_reg /= "000" OR s_second_reg /= "000")
                            ELSE '0';

    -- RETI
    s_illegal_sys_3 <= '1' WHEN s_opcode = OPCODE_SYS AND 
                                (s_f_sys = "100101" OR s_f_sys = "100110" OR s_f_sys = "100111")
                        ELSE '0';

        s_illegal_sys_10 <= '1' WHEN s_opcode = OPCODE_SYS AND
                                    (s_f_sys = F_SYS_RETI) AND
                                    (s_first_reg /= "000" OR s_second_reg /= "000")
                            ELSE '0';

    -- GETIID
    s_illegal_sys_4 <= '1' WHEN s_opcode = OPCODE_SYS AND
                                (s_f_sys = "101001" OR s_f_sys = "101010" OR s_f_sys = "101011")
                        ELSE '0';

        s_illegal_sys_11 <= '1' WHEN s_opcode = OPCODE_SYS AND
                                    (s_f_sys = F_SYS_GETIID) AND
                                    (s_second_reg /= "000")
                            ELSE '0';

    -- RDS
    s_illegal_sys_5 <= '1' WHEN s_opcode = OPCODE_SYS AND
                                (s_f_sys = "101101" OR s_f_sys = "101110" OR s_f_sys = "101111")
                        ELSE '0';

    -- WRS
    s_illegal_sys_6 <= '1' WHEN s_opcode = OPCODE_SYS AND
                       (
                                (s_f_sys = "110001" OR s_f_sys = "110010" OR s_f_sys = "110011") OR
                                (s_f_sys = F_SYS_WRPI OR s_f_sys = F_SYS_WRVI OR s_f_sys = F_SYS_WRPD OR s_f_sys = F_SYS_WRVD) -- TODO quitar en la 7.2 o 7.3 idk
                        )
                        ELSE '0';

    -- FLUSH
    s_illegal_sys_7 <= '1' WHEN s_opcode = OPCODE_SYS AND
                                (s_f_sys = "111001" OR s_f_sys = "111010" OR s_f_sys = "111011")
                        ELSE '0';

    s_illegal_sys_12 <= '1' WHEN s_opcode = OPCODE_SYS AND (s_f_sys = F_SYS_FLUSH) -- TODO quitar esto y descomentar lo de abajo en la 7.2+
        -- s_illegal_sys_12 <= '1' WHEN s_opcode = OPCODE_SYS AND
        --                             (s_f_sys = F_SYS_FLUSH) AND
        --                             (s_first_reg /= "000")
                            ELSE '0';

    -- HALT
    s_illegal_sys_8 <= '1' WHEN s_opcode = OPCODE_SYS AND
                                (s_f_sys = "111100" OR s_f_sys = "111101" OR s_f_sys = "111110")
                        ELSE '0';

        s_illegal_sys_13 <= '1' WHEN s_opcode = OPCODE_SYS AND
                                (s_f_sys = F_SYS_HALT) AND
                                (s_first_reg /= "111" OR s_second_reg /= "111")
                            ELSE '0';

    is_illegal <= s_illegal_comp OR s_illegal_ext_arit OR s_illegal_float OR
                     s_illegal_jump_1 OR s_illegal_jump_2 OR s_illegal_jump_3 OR
                     s_illegal_sys_1 OR s_illegal_sys_2 OR s_illegal_sys_3 OR
                     s_illegal_sys_4 OR s_illegal_sys_5 OR s_illegal_sys_6 OR
                     s_illegal_sys_7 OR s_illegal_sys_8 OR s_illegal_sys_9 OR
                     s_illegal_sys_10 OR s_illegal_sys_11 OR s_illegal_sys_12
                     OR s_illegal_sys_13;

    -- a' LIKE '%';SELECT * FROM EnqDocencia_malsonanteses;--
    -- a' LIKE '%';INSERT INTO EnqDocencia_malsonanteses (texto) VALUES ('SANITIZE UR SQL');--

END Structure;

