LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY driver7Segmentos IS
	PORT (
		data            : IN  std_logic_vector(15 DOWNTO 0);
        hex0_on         : IN std_logic;
        hex1_on         : IN std_logic;
        hex2_on         : IN std_logic;
        hex3_on         : IN std_logic;
        hex0            : OUT std_logic_vector(6 DOWNTO 0);
        hex1            : OUT std_logic_vector(6 DOWNTO 0);
        hex2            : OUT std_logic_vector(6 DOWNTO 0);
        hex3            : OUT std_logic_vector(6 DOWNTO 0));
END driver7Segmentos;

ARCHITECTURE Structure OF driver7Segmentos IS

    COMPONENT decoder7Segmentos IS
	PORT (
		codigoCaracter  : IN  std_logic_vector(3 DOWNTO 0);
        encendido       : IN std_logic;
		bitsCaracter    : OUT std_logic_vector(6 DOWNTO 0));
    END COMPONENT;

BEGIN

	decoder3 : decoder7Segmentos PORT MAP(
		codigoCaracter  => data(15 DOWNTO 12),
        encendido       => hex3_on,
		bitsCaracter    => hex3
	);

	decoder2 : decoder7Segmentos PORT MAP(
		codigoCaracter  => data(11 DOWNTO 8),
        encendido       => hex2_on,
		bitsCaracter    => hex2
	);

	decoder1 : decoder7Segmentos PORT MAP(
		codigoCaracter  => data(7 DOWNTO 4),
        encendido       => hex1_on,
		bitsCaracter    => hex1
	);

	decoder0 : decoder7Segmentos PORT MAP(
		codigoCaracter  => data(3 DOWNTO 0),
        encendido       => hex0_on,
		bitsCaracter    => hex0
	);


END Structure;

