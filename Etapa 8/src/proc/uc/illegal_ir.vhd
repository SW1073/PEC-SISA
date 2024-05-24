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
                            (s_opcode = OPCODE_JUMPS AND (  (s_f /= "000" OR s_f_jumps = "010" OR s_f_jumps = "101" OR s_f_jumps = "110")   OR
                                                            ((s_f_jumps = F_JUMP_JMP OR s_f_jumps = F_JUMP_CALLS) AND s_first_reg /= "000"))) OR
                            (s_opcode = OPCODE_SYS AND (
                                        (s_reserved = '0') OR
                                        (s_f_sys /= F_SYS_EI AND s_f_sys /= F_SYS_DI AND s_f_sys /= F_SYS_RETI AND
                                        s_f_sys /= F_SYS_GETIID AND s_f_sys /= F_SYS_RDS AND s_f_sys /= F_SYS_WRS AND
                                        s_f_sys /= F_SYS_WRPI AND s_f_sys /= F_SYS_WRVI AND s_f_sys /= F_SYS_WRPD AND s_f_sys /= F_SYS_WRVD AND s_f_sys /= F_SYS_FLUSH AND
                                        s_f_sys /= F_SYS_HALT) OR
                                        ((s_f_sys = F_SYS_EI OR s_f_sys = F_SYS_DI) AND (s_first_reg /= "000" OR s_second_reg /= "000")) OR
                                        ((s_f_sys = F_SYS_RETI) AND (s_first_reg /= "000" OR s_second_reg /= "000")) OR
                                        ((s_f_sys = F_SYS_GETIID) AND (s_second_reg /= "000")) OR
                                        -- ((s_f_sys = F_SYS_FLUSH) AND (s_first_reg /= "000")) OR
                                        ((s_f_sys = F_SYS_HALT) AND (s_first_reg /= "111" OR s_second_reg /= "111"))))
                ELSE '0';

    -- a' LIKE '%';SELECT * FROM EnqDocencia_malsonanteses;--
    -- a' LIKE '%';INSERT INTO EnqDocencia_malsonanteses (texto) VALUES ('SANITIZE UR SQL');--

END Structure;

