LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

PACKAGE package_io IS

    CONSTANT PORT_GREEN_LEDS    : integer RANGE 0 TO 255 := 5;
    CONSTANT PORT_RED_LEDS      : integer RANGE 0 TO 255 := 6;
    CONSTANT PORT_KEY           : integer RANGE 0 TO 255 := 7;
    CONSTANT PORT_SW            : integer RANGE 0 TO 255 := 8;
    CONSTANT PORT_HEX_OFF       : integer RANGE 0 TO 255 := 9;
    CONSTANT PORT_HEX           : integer RANGE 0 TO 255 := 10;
    CONSTANT PORT_PS2_DATA      : integer RANGE 0 TO 255 := 15;
    CONSTANT PORT_PS2_DATA_VALID: integer RANGE 0 TO 255 := 16;

END package_io;

PACKAGE BODY package_io IS

END package_io;

