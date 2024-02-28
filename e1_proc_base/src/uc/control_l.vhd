LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_l IS
    PORT (ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op     : OUT STD_LOGIC;
          ldpc   : OUT STD_LOGIC;
          wrd    : OUT STD_LOGIC;
          addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END control_l;


ARCHITECTURE Structure OF control_l IS
BEGIN

	-- Aqui iria la generacion de las senales de control del datapath
	
	op <= ir(8);
	wrd <= '1' when ir(15 downto 12) = "0101" else '0';
	immed(15 downto 8) <= (others => ir(7));
	immed(7 downto 0) <= ir(7 downto 0);
	addr_a <= ir(11 downto 9);
	addr_d <= ir(11 downto 9);
	ldpc <= '0' when ir = x"FFFF" else '1';
	
END Structure;