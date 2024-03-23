LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY op_immed IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END op_immed;


ARCHITECTURE Structure OF op_immed IS
BEGIN

	-- Aqui iria la definicion del comportamiento de la ALU

    with op select w <=
            x and y							when "000",  -- AND
            x or y							when "001",  -- OR
            y xor y							when "010",  -- XOR
            not y							when "011",  -- NOT
            x+y                             when "100",  -- ADD
            x-y								when "101",  -- SUB
            y                               when "110",  -- SHA
            y                               when "111",  -- SHL
            y                               when others;

END Structure;
