LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_signed.all;
USE work.package_alu.all;

ENTITY alu_ext_arit IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu_ext_arit;


ARCHITECTURE Structure OF alu_ext_arit IS
    signal s_w_mul : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal s_w_div : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    with op select
    s_w_mul <=          std_logic_vector(signed(x) * signed(y))         when F_EXT_ARIT_MUL,
                        std_logic_vector(signed(x) * signed(y))         when F_EXT_ARIT_MULH,
                        std_logic_vector(unsigned(x) * unsigned(y))     when F_EXT_ARIT_MULHU,
                        "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"     when others;

    with op select
    s_w_div <=          std_logic_vector(signed(x) / signed(y))         when F_EXT_ARIT_DIV,
                        std_logic_vector(unsigned(x) / unsigned(y))     when F_EXT_ARIT_DIVU,
                        std_logic_vector(unsigned(x) /unsigned(y))      when others;

    w <=    s_w_mul(31 downto 16)    when op = F_EXT_ARIT_MULH OR op = F_EXT_ARIT_MULHU ELSE
            s_w_mul(15 downto 0)     when op = F_EXT_ARIT_MUL
            ELSE s_w_div;

END Structure;
