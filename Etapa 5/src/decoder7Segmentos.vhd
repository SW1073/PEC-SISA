LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoder7Segmentos IS
	PORT (
		codigoCaracter  : IN  std_logic_vector(3 DOWNTO 0);
        esta_apagado    : IN std_logic;
		bitsCaracter    : OUT std_logic_vector(6 DOWNTO 0));
END decoder7Segmentos;

ARCHITECTURE Structure OF decoder7Segmentos IS
    SIGNAL s_bitsCaracter   : std_logic_vector(6 DOWNTO 0);
BEGIN

	WITH codigoCaracter SELECT
		s_bitsCaracter <= "1000000" WHEN "0000", -- 0
                        "1111001" WHEN "0001", -- 1
                        "0100100" WHEN "0010", -- 2
                        "0110000" WHEN "0011", -- 3
                        "0011001" WHEN "0100", -- 4
                        "0010010" WHEN "0101", -- 5
                        "0000010" WHEN "0110", -- 6
                        "1111000" WHEN "0111", -- 7
                        "0000000" WHEN "1000", -- 8
                        "0011000" WHEN "1001", -- 9
                        "0001000" WHEN "1010", -- a
                        "0000011" WHEN "1011", -- b
                        "1000110" WHEN "1100", -- c
                        "0100001" WHEN "1101", -- d
                        "0000110" WHEN "1110", -- e
                        "0001110" WHEN "1111", -- f
                        "1111111" WHEN OTHERS; -- Apagat when others

    bitsCaracter <= "1111111" WHEN esta_apagado = '1' ELSE s_bitsCaracter;

END Structure;

