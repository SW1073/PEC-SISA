LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE work.package_alu.all;

ENTITY alu_comp IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu_comp;


ARCHITECTURE Structure OF alu_comp IS
BEGIN

	-- Aqui iria la definicion del comportamiento de la ALU

    with op select w <=
            -- x < y       when F_CMP_LT,  -- CMPLT
            -- x <= y      when F_CMP_LE,  -- CMPLE
            -- x = y                       when F_CMP_EQ,  -- CMPEQ
            -- x < y                       when F_CMP_LTU,  -- COMPLTU
            -- x <= y                      when F_CMP_LEU,  -- COMPLEU
            "XXXXXXXXXXXXXXXX"              when others;

END Structure;
