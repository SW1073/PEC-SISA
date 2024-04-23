LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_signed.ALL;
USE work.package_alu.ALL;

ENTITY alu_ext_arit IS
	PORT (
		x  : IN  std_logic_vector(15 DOWNTO 0);
		y  : IN  std_logic_vector(15 DOWNTO 0);
		op : IN  std_logic_vector(2 DOWNTO 0);
		w  : OUT std_logic_vector(15 DOWNTO 0));
END alu_ext_arit;

ARCHITECTURE Structure OF alu_ext_arit IS
	SIGNAL s_w_mul : std_logic_vector(31 DOWNTO 0);
	SIGNAL s_w_div : std_logic_vector(15 DOWNTO 0);
BEGIN

	WITH op SELECT
		s_w_mul <= std_logic_vector(signed(x) * signed(y))     WHEN F_EXT_ARIT_MUL,
                   std_logic_vector(signed(x) * signed(y))     WHEN F_EXT_ARIT_MULH,
                   std_logic_vector(unsigned(x) * unsigned(y)) WHEN F_EXT_ARIT_MULHU,
                   "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"          WHEN OTHERS;

	WITH op SELECT
		s_w_div <= std_logic_vector(signed(x) / signed(y))     WHEN F_EXT_ARIT_DIV,
                   std_logic_vector(unsigned(x) / unsigned(y)) WHEN F_EXT_ARIT_DIVU,
                   std_logic_vector(unsigned(x) / unsigned(y)) WHEN OTHERS;

	w <= s_w_mul(31 DOWNTO 16) WHEN op = F_EXT_ARIT_MULH OR op = F_EXT_ARIT_MULHU ELSE
         s_w_mul(15 DOWNTO 0) WHEN op = F_EXT_ARIT_MUL ELSE
         s_w_div;

END Structure;

