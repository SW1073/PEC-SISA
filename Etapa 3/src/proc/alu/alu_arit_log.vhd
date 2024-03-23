LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE work.package_alu.all;

ENTITY alu_arit_log IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu_arit_log ;


ARCHITECTURE Structure OF alu_arit_log IS
BEGIN

	-- Aqui iria la definicion del comportamiento de la ALU

    with op select w <=
            x and y							when F_ARIT_LOG_AND,  -- AND
            x or y							when F_ARIT_LOG_OR,  -- OR
            x xor y							when F_ARIT_LOG_XOR,  -- XOR
            not y							when F_ARIT_LOG_NOT,  -- NOT
            x+y                             when F_ARIT_LOG_ADD,  -- ADD
            x-y								when F_ARIT_LOG_SUB,  -- SUB
            y                               when F_ARIT_LOG_SHA,  -- SHA
            y                               when F_ARIT_LOG_SHL,  -- SHL
            "XXXXXXXXXXXXXXXX"              when others;

END Structure;
