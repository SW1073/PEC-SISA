LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
USE ieee.std_logic_unsigned.ALL; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER

ENTITY controladores_IO IS
    PORT (
        boot       : IN  STD_LOGIC;
        CLOCK_50   : IN  STD_LOGIC;
        addr_io    : IN  STD_LOGIC_VECTOR(7  DOWNTO 0);
        wr_io      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        rd_io      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        wr_out     : IN  STD_LOGIC;
        rd_in      : IN  STD_LOGIC;
        led_verdes : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        led_rojos  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END controladores_IO;

ARCHITECTURE Structure OF controladores_IO IS
    TYPE Mat IS ARRAY (255 DOWNTO 0) OF std_logic_vector(15 DOWNTO 0);
    SIGNAL registers : Mat := (OTHERS => (OTHERS => '0'));
BEGIN

PROCESS (CLOCK_50) IS
    BEGIN
        IF rising_edge(CLOCK_50) THEN
            IF wr_out = '1' THEN
                registers(conv_integer(addr_io)) <= wr_io;
            END IF;
        END IF;
    END PROCESS;

    -- Read con enable
    rd_io <= registers(conv_integer(addr_io)) WHEN rd_in = '1' ELSE x"0000";

    led_verdes <= registers(5)(7 downto 0);
    led_rojos <= registers(6)(7 downto 0);

END Structure;
