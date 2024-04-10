LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

PACKAGE package_opcodes IS

	CONSTANT OPCODE_ARIT_LOG : std_logic_vector(3 DOWNTO 0) := "0000";
	CONSTANT OPCODE_CMPS     : std_logic_vector(3 DOWNTO 0) := "0001";
	CONSTANT OPCODE_IMMED    : std_logic_vector(3 DOWNTO 0) := "0010";
	CONSTANT OPCODE_EXT_ARIT : std_logic_vector(3 DOWNTO 0) := "1000";
	CONSTANT OPCODE_LOAD     : std_logic_vector(3 DOWNTO 0) := "0011";
	CONSTANT OPCODE_STORE    : std_logic_vector(3 DOWNTO 0) := "0100";
	CONSTANT OPCODE_LOADB    : std_logic_vector(3 DOWNTO 0) := "1101";
	CONSTANT OPCODE_STOREB   : std_logic_vector(3 DOWNTO 0) := "1110";
	CONSTANT OPCODE_MOVS     : std_logic_vector(3 DOWNTO 0) := "0101";
	CONSTANT OPCODE_BRANCHES : std_logic_vector(3 DOWNTO 0) := "0110";
	CONSTANT OPCODE_JUMPS    : std_logic_vector(3 DOWNTO 0) := "1010";

END package_opcodes;

PACKAGE BODY package_opcodes IS

END package_opcodes;

