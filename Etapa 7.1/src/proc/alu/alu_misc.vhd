LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_alu.ALL;

ENTITY alu_misc IS
	PORT (
		x  : IN  std_logic_vector(15 DOWNTO 0);
		y  : IN  std_logic_vector(15 DOWNTO 0);
		op : IN  std_logic_vector(2 DOWNTO 0);
		w  : OUT std_logic_vector(15 DOWNTO 0));
END alu_misc;

ARCHITECTURE Structure OF alu_misc IS
BEGIN

	WITH op SELECT
        w <= y                             WHEN F_MISC_MOVI,  -- MOVI
             y(7 DOWNTO 0) & x(7 DOWNTO 0) WHEN F_MISC_MOVHI, -- MOVHI
             "XXXXXXXXXXXXXXXX"            WHEN OTHERS;

END Structure;

