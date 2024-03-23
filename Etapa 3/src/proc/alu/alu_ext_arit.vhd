LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE work.package_alu.all;

ENTITY alu_ext_arit IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu_ext_arit;


ARCHITECTURE Structure OF alu_ext_arit IS
BEGIN

	-- Aqui iria la definicion del comportamiento de la ALU

    with op select w <=
            -- std_logic_vector(signed(x) * signed(y))           when F_EXT_ARIT_MUL,  -- MUL
            y                                                           when F_EXT_ARIT_MULH,  -- MULH
            y                                                           when F_EXT_ARIT_MULHU,  -- MULHU
            -- std_logic_vector(signed(x) / signed(y))                     when F_EXT_ARIT_DIV,  -- DIV
            y                                                       when F_EXT_ARIT_DIVU,  -- DIVU
            "XXXXXXXXXXXXXXXX"                                          when others;

END Structure;
