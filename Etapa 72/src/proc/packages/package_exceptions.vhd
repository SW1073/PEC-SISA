LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

PACKAGE package_exceptions IS

    CONSTANT EX_ILLEGAL_INSTR   : std_logic_vector(3 DOWNTO 0) := "0000"; -- 0
    CONSTANT EX_BAD_ALIGNMENT   : std_logic_vector(3 DOWNTO 0) := "0001"; -- 1
    --
    --
    CONSTANT EX_DIV_BY_ZERO     : std_logic_vector(3 DOWNTO 0) := "0100"; -- 4
    --
    -- ...
    --
    CONSTANT EX_INTERRUPT_CODE  : std_logic_vector(3 DOWNTO 0) := "1111"; -- 15

END package_exceptions;

PACKAGE BODY package_exceptions IS

END package_exceptions;

