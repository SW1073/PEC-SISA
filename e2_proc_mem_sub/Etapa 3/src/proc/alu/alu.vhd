LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY alu IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu;


ARCHITECTURE Structure OF alu IS
BEGIN

	-- Aqui iria la definicion del comportamiento de la ALU

    with op select w <=
            y                               when '0'&x"0",  -- MOVI
            y(7 downto 0) & x(7 downto 0)   when '0'&x"2",  -- MOVHI
            x+y                             when '0'&x"3",  -- ADD
            y                               when '0'&x"4",  -- 
            y                               when '0'&x"5",
            y                               when '0'&x"6",
            y                               when '0'&x"7",
            y                               when '0'&x"8",
            y                               when '0'&x"9",
            y                               when '0'&x"a",
            y                               when '0'&x"b",
            y                               when '0'&x"c",
            y                               when '0'&x"d",
            y                               when '0'&x"e",
            y                               when '0'&x"f",
            y                               when others;    -- Undefined Behaviour

END Structure;
