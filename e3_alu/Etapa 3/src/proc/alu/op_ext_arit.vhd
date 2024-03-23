LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY op_ext_arit IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END op_ext_arit;


ARCHITECTURE Structure OF op_ext_arit IS
BEGIN

	-- Aqui iria la definicion del comportamiento de la ALU

    with op select w <=
            y                               when "000",  -- MUL
            y                               when "001",  -- MULH
            y                               when "010",  -- MULHU
            y                               when "100",  -- DIV
            y                               when "101",  -- DIVU
			y								when others;

END Structure;
