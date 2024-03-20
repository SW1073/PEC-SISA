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
            y(7 downto 0) & x(7 downto 0)   when '0'&x"1",  -- MOVHI
            y                               when '0'&x"2",  -- CMPLT
            y                               when '0'&x"3",  -- CMPLE
            y                               when '0'&x"4",  -- CMPEQ
            y                               when '0'&x"5",  -- COMPLTU
            y                               when '0'&x"6",  -- COMPLEU
            y                               when '0'&x"7",  -- ADDI
            y                               when '0'&x"8",  -- AND
            y                               when '0'&x"9",  -- OR
            y                               when '0'&x"a",  -- XOR
            y                               when '0'&x"b",  -- NOT
            x+y                             when '0'&x"c",  -- ADD
            y                               when '0'&x"d",  -- SUB
            y                               when '0'&x"e",  -- SHA
            y                               when '0'&x"f",  -- SHL
            y                               when '1'&x"0",  -- MUL
            y                               when '1'&x"1",  -- MULH
            y                               when '1'&x"2",  -- MULHU
            y                               when '1'&x"3",  -- DIV
            y                               when '1'&x"4",  -- DIVU
            y                               when others;    -- Not Implemented. Undefined Behaviour

END Structure;
