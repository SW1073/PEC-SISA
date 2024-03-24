LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE work.package_alu.all;

ENTITY alu_misc IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu_misc;


ARCHITECTURE Structure OF alu_misc IS
BEGIN

    with op select w <=
            y                               when F_MISC_MOVI,  -- MOVI
            y(7 downto 0) & x(7 downto 0)   when F_MISC_MOVHI,  -- MOVHI
            "XXXXXXXXXXXXXXXX"                               when others;

END Structure;
