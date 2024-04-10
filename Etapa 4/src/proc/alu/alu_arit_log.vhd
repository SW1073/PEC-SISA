LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_alu.ALL;

ENTITY alu_arit_log IS
	PORT (
		x  : IN  std_logic_vector(15 DOWNTO 0);
		y  : IN  std_logic_vector(15 DOWNTO 0);
		op : IN  std_logic_vector(2 DOWNTO 0);
		w  : OUT std_logic_vector(15 DOWNTO 0));
END alu_arit_log;
ARCHITECTURE Structure OF alu_arit_log IS
	SIGNAL s_shift_sha : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_shift_shl : std_logic_vector(15 DOWNTO 0);
    SIGNAL s_y : std_logic_vector(4 DOWNTO 0);
BEGIN

    s_y <= y(4 DOWNTO 0);

	s_shift_sha <= std_logic_vector(shift_left(signed(x), to_integer(signed(s_y)))) WHEN signed(s_y) >= 0
		ELSE std_logic_vector(shift_right(signed(x), to_integer(-signed(s_y))));

	s_shift_shl <= std_logic_vector(shift_left(unsigned(x), to_integer(signed(s_y))));

	WITH op SELECT
		w <= x AND y            WHEN F_ARIT_LOG_AND,    -- AND
             x OR y             WHEN F_ARIT_LOG_OR,     -- OR
             x XOR y            WHEN F_ARIT_LOG_XOR,    -- XOR
             NOT x              WHEN F_ARIT_LOG_NOT,    -- NOT
             x + y              WHEN F_ARIT_LOG_ADD,    -- ADD
             x - y              WHEN F_ARIT_LOG_SUB,    -- SUB
             s_shift_sha        WHEN F_ARIT_LOG_SHA,    -- SHA
             s_shift_shl        WHEN F_ARIT_LOG_SHL,    -- SHL
             "XXXXXXXXXXXXXXXX" WHEN OTHERS;

END Structure;

