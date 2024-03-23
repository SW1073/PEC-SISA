LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY driver7Segmentos IS
	PORT( codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END driver7Segmentos;

ARCHITECTURE Structure OF driver7Segmentos IS
BEGIN

	bitsCaracter <= "1000000" when (codigoCaracter = "0000") else -- 0
                    "1111001" when (codigoCaracter = "0001") else -- 1
                    "0100100" when (codigoCaracter = "0010") else -- 2
                    "0110000" when (codigoCaracter = "0011") else -- 3
                    "0011001" when (codigoCaracter = "0100") else -- 4
                    "0010010" when (codigoCaracter = "0101") else -- 5
                    "0000010" when (codigoCaracter = "0110") else -- 6
                    "1111000" when (codigoCaracter = "0111") else -- 7
	                "0000000" when (codigoCaracter = "1000") else -- 8
                    "0011000" when (codigoCaracter = "1001") else -- 9
                    "0001000" when (codigoCaracter = "1010") else -- a
                    "0000011" when (codigoCaracter = "1011") else -- b
                    "1000110" when (codigoCaracter = "1100") else -- c
                    "0100001" when (codigoCaracter = "1101") else -- d
                    "0000110" when (codigoCaracter = "1110") else -- e
                    "0001110" when (codigoCaracter = "1111");     -- f

END Structure;
