LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

PACKAGE package_exceptions IS

    CONSTANT EX_ILLEGAL_INSTR   : std_logic_vector(3 DOWNTO 0) := "0000"; -- 0
    CONSTANT EX_BAD_ALIGNMENT   : std_logic_vector(3 DOWNTO 0) := "0001"; -- 1
    -- 2 floating point
    -- 3 floating point
    CONSTANT EX_DIV_BY_ZERO     : std_logic_vector(3 DOWNTO 0) := "0100"; -- 4
    -- 5 no existe lol
    CONSTANT EX_MISS_ITLB       : std_logic_vector(3 DOWNTO 0) := "0110"; -- 6
    CONSTANT EX_MISS_DTLB       : std_logic_vector(3 DOWNTO 0) := "0111"; -- 7
    CONSTANT EX_INVALID_ITLB    : std_logic_vector(3 DOWNTO 0) := "1000"; -- 8
    CONSTANT EX_INVALID_DTLB    : std_logic_vector(3 DOWNTO 0) := "1001"; -- 9
    CONSTANT EX_PROTECTED_ITLB  : std_logic_vector(3 DOWNTO 0) := "1010"; -- 10
    CONSTANT EX_PROTECTED_DTLB  : std_logic_vector(3 DOWNTO 0) := "1011"; -- 11
    CONSTANT EX_READONLY_DTLB   : std_logic_vector(3 DOWNTO 0) := "1100"; -- 12
    CONSTANT EX_PROTECTED_IR    : std_logic_vector(3 DOWNTO 0) := "1101"; -- 13
    CONSTANT EX_CALLS           : std_logic_vector(3 DOWNTO 0) := "1110"; -- 14
    CONSTANT EX_INTERRUPT_CODE  : std_logic_vector(3 DOWNTO 0) := "1111"; -- 15

END package_exceptions;

PACKAGE BODY package_exceptions IS

END package_exceptions;

