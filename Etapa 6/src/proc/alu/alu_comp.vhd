LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_alu.ALL;

ENTITY alu_comp IS
	PORT (
		x  : IN  std_logic_vector(15 DOWNTO 0);
		y  : IN  std_logic_vector(15 DOWNTO 0);
		op : IN  std_logic_vector(2 DOWNTO 0);
		w  : OUT std_logic_vector(15 DOWNTO 0));
END alu_comp;
ARCHITECTURE Structure OF alu_comp IS
	SIGNAL s_w : boolean;
BEGIN

	WITH op SELECT
		s_w <= signed(x) < signed(y)    WHEN F_CMP_LT,  -- CMPLT
               signed(x) <= signed(y)   WHEN F_CMP_LE,  -- CMPLE
               x = y                    WHEN F_CMP_EQ,  -- CMPEQ
               x < y                    WHEN F_CMP_LTU, -- COMPLTU
               x <= y                   WHEN F_CMP_LEU, -- COMPLEU
               x = y                    WHEN OTHERS;

	w <= x"0001" WHEN s_w = true ELSE x"0000";

END Structure;

