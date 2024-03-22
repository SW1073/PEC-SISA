LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY op_comp IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END op_comp;


ARCHITECTURE Structure OF op_comp IS
BEGIN

	-- Aqui iria la definicion del comportamiento de la ALU

    with op select w <=
            y                               when "000",  -- CMPLT
            y                               when "001",  -- CMPLE
            y                               when "011",  -- CMPEQ
            y                               when "100",  -- COMPLTU
            y                               when "101",  -- COMPLEU
			y								when others;

END Structure;
