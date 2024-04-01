LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY alu IS
	PORT (
		x  : IN  std_logic_vector(15 DOWNTO 0);
		y  : IN  std_logic_vector(15 DOWNTO 0);
		op : IN  std_logic_vector(1 DOWNTO 0);
		w  : OUT std_logic_vector(15 DOWNTO 0));
END alu;
ARCHITECTURE Structure OF alu IS
BEGIN

	-- Aqui iria la definicion del comportamiento de la ALU

	WITH op SELECT 
        w <=    y                               WHEN "00",
		        y(7 DOWNTO 0) & x(7 DOWNTO 0)   WHEN "01",
		        x + y                           WHEN "10",
		        y                               WHEN OTHERS;

END Structure;

