LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY op_movs IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END op_movs;


ARCHITECTURE Structure OF op_movs IS
BEGIN

	-- Aqui iria la definicion del comportamiento de la ALU

    with op select w <=
            y                               when "000",  -- MOVI
            y(7 downto 0) & x(7 downto 0)   when "001",  -- MOVHI
            y                               when others;

END Structure;
