LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY driver7Segmentos IS
	PORT (
		data            : IN  std_logic_vector(15 DOWNTO 0);
        hex0_off        : IN std_logic;
        hex1_off        : IN std_logic;
        hex2_off        : IN std_logic;
        hex3_off        : IN std_logic;
        hex0            : OUT std_logic_vector(6 DOWNTO 0);
        hex1            : OUT std_logic_vector(6 DOWNTO 0);
        hex2            : OUT std_logic_vector(6 DOWNTO 0);
        hex3            : OUT std_logic_vector(6 DOWNTO 0));
END driver7Segmentos;

ARCHITECTURE Structure OF driver7Segmentos IS

    COMPONENT decoder7Segmentos IS
	PORT (
		codigoCaracter  : IN  std_logic_vector(3 DOWNTO 0);
        esta_apagado    : IN std_logic;
		bitsCaracter    : OUT std_logic_vector(6 DOWNTO 0));
    END COMPONENT;

BEGIN

	decoder3 : decoder7Segmentos PORT MAP(
		codigoCaracter  => data(15 DOWNTO 12),
        esta_apagado    => hex3_off,
		bitsCaracter    => hex3
	);

	decoder2 : decoder7Segmentos PORT MAP(
		codigoCaracter => data(11 DOWNTO 8),
        esta_apagado    => hex2_off,
		bitsCaracter   => hex2
	);

	decoder1 : decoder7Segmentos PORT MAP(
		codigoCaracter => data(7 DOWNTO 4),
        esta_apagado    => hex1_off,
		bitsCaracter   => hex1
	);

	decoder0 : decoder7Segmentos PORT MAP(
		codigoCaracter => data(3 DOWNTO 0),
        esta_apagado    => hex0_off,
		bitsCaracter   => hex0
	);


END Structure;

