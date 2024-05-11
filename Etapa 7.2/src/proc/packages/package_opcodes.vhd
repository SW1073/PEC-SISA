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
    CONSTANT OPCODE_IO       : std_logic_vector(3 DOWNTO 0) := "0111";
    CONSTANT OPCODE_SYS      : std_logic_vector(3 DOWNTO 0) := "1111";

    -- F de
    CONSTANT F_INPUT         : std_logic := '0';
    CONSTANT F_OUTPUT        : std_logic := '1';

    CONSTANT F_SYS_RDS       : std_logic_vector(5 DOWNTO 0) := "101100";
    CONSTANT F_SYS_WRS       : std_logic_vector(5 DOWNTO 0) := "110000";
    CONSTANT F_SYS_EI        : std_logic_vector(5 DOWNTO 0) := "100000";
    CONSTANT F_SYS_DI        : std_logic_vector(5 DOWNTO 0) := "100001";
    CONSTANT F_SYS_RETI      : std_logic_vector(5 DOWNTO 0) := "100100";
    CONSTANT F_SYS_GETIID    : std_logic_vector(5 DOWNTO 0) := "101000";

END package_opcodes;

PACKAGE BODY package_opcodes IS

END package_opcodes;

