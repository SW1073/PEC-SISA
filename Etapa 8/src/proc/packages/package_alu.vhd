LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

PACKAGE package_alu IS

	CONSTANT OP_ARIT_LOG      : std_logic_vector(2 DOWNTO 0) := "000";
	CONSTANT OP_CMPS          : std_logic_vector(2 DOWNTO 0) := "001";
	CONSTANT OP_EXT_ARIT      : std_logic_vector(2 DOWNTO 0) := "010";
	CONSTANT OP_IMMED         : std_logic_vector(2 DOWNTO 0) := "011";
	CONSTANT OP_MISC          : std_logic_vector(2 DOWNTO 0) := "100";

	-- ARITMETICO LOGICAS
	CONSTANT F_ARIT_LOG_AND   : std_logic_vector(2 DOWNTO 0) := "000";
	CONSTANT F_ARIT_LOG_OR    : std_logic_vector(2 DOWNTO 0) := "001";
	CONSTANT F_ARIT_LOG_XOR   : std_logic_vector(2 DOWNTO 0) := "010";
	CONSTANT F_ARIT_LOG_NOT   : std_logic_vector(2 DOWNTO 0) := "011";
	CONSTANT F_ARIT_LOG_ADD   : std_logic_vector(2 DOWNTO 0) := "100";
	CONSTANT F_ARIT_LOG_SUB   : std_logic_vector(2 DOWNTO 0) := "101";
	CONSTANT F_ARIT_LOG_SHA   : std_logic_vector(2 DOWNTO 0) := "110";
	CONSTANT F_ARIT_LOG_SHL   : std_logic_vector(2 DOWNTO 0) := "111";

	-- COMPARACIONES
	CONSTANT F_CMP_LT         : std_logic_vector(2 DOWNTO 0) := "000";
	CONSTANT F_CMP_LE         : std_logic_vector(2 DOWNTO 0) := "001";
	--
	CONSTANT F_CMP_EQ         : std_logic_vector(2 DOWNTO 0) := "011";
	CONSTANT F_CMP_LTU        : std_logic_vector(2 DOWNTO 0) := "100";
	CONSTANT F_CMP_LEU        : std_logic_vector(2 DOWNTO 0) := "101";
	--
	--

	-- EXTENSION ARITMETICA
	CONSTANT F_EXT_ARIT_MUL   : std_logic_vector(2 DOWNTO 0) := "000";
	CONSTANT F_EXT_ARIT_MULH  : std_logic_vector(2 DOWNTO 0) := "001";
	CONSTANT F_EXT_ARIT_MULHU : std_logic_vector(2 DOWNTO 0) := "010";
	--
	CONSTANT F_EXT_ARIT_DIV   : std_logic_vector(2 DOWNTO 0) := "100";
	CONSTANT F_EXT_ARIT_DIVU  : std_logic_vector(2 DOWNTO 0) := "101";
	--
	--

	-- BRANCHES
	CONSTANT F_BRANCH_BZ      : std_logic                    := '0';
	CONSTANT F_BRANCH_BNZ     : std_logic                    := '1';

	-- JUMPS
	CONSTANT F_JUMP_JZ        : std_logic_vector(2 DOWNTO 0) := "000";
	CONSTANT F_JUMP_JNZ       : std_logic_vector(2 DOWNTO 0) := "001";
	--
	CONSTANT F_JUMP_JMP       : std_logic_vector(2 DOWNTO 0) := "011";
	CONSTANT F_JUMP_JAL       : std_logic_vector(2 DOWNTO 0) := "100";
	--
	--
	CONSTANT F_JUMP_CALLS     : std_logic_vector(2 DOWNTO 0) := "111";

	-- MISC
	CONSTANT F_MISC_MOVI      : std_logic_vector(2 DOWNTO 0) := "000";
	CONSTANT F_MISC_MOVHI     : std_logic_vector(2 DOWNTO 0) := "001";
    CONSTANT F_MISC_X_OUT     : std_logic_vector(2 DOWNTO 0) := "010";
    CONSTANT F_MISC_Y_OUT     : std_logic_vector(2 DOWNTO 0) := "000";

END package_alu;
PACKAGE BODY package_alu IS

END package_alu;

