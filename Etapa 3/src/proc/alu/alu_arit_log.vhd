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
    signal s_shift_sha : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal s_shift_shl : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    s_shift_sha <= std_logic_vector(shift_left(signed(x), to_integer(signed(y)))) when signed(y) >= 0
                   else std_logic_vector(shift_right(signed(x), to_integer(signed(y))));

    s_shift_shl <= std_logic_vector(shift_left(unsigned(x), to_integer(signed(y))));

    with op select 
    w <=    x and y							when F_ARIT_LOG_AND,  -- AND
            x or y							when F_ARIT_LOG_OR,  -- OR
            x xor y							when F_ARIT_LOG_XOR,  -- XOR
            not x							when F_ARIT_LOG_NOT,  -- NOT
            x+y                             when F_ARIT_LOG_ADD,  -- ADD
            x-y								when F_ARIT_LOG_SUB,  -- SUB
            s_shift_sha                     when F_ARIT_LOG_SHA,  -- SHA
            s_shift_shl                     when F_ARIT_LOG_SHL,  -- SHL
            "XXXXXXXXXXXXXXXX"              when others;

END Structure;
