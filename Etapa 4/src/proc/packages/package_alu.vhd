LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

package package_alu is

constant OP_ARIT_LOG        : std_logic_vector(2 downto 0) := "000";
constant OP_CMPS            : std_logic_vector(2 downto 0) := "001";
constant OP_EXT_ARIT        : std_logic_vector(2 downto 0) := "010";
constant OP_IMMED           : std_logic_vector(2 downto 0) := "011";
constant OP_MOVS            : std_logic_vector(2 downto 0) := "100";

-- ARITMETICO LOGICAS
constant F_ARIT_LOG_AND     : std_logic_vector(2 downto 0) := "000";
constant F_ARIT_LOG_OR      : std_logic_vector(2 downto 0) := "001";
constant F_ARIT_LOG_XOR     : std_logic_vector(2 downto 0) := "010";
constant F_ARIT_LOG_NOT     : std_logic_vector(2 downto 0) := "011";
constant F_ARIT_LOG_ADD     : std_logic_vector(2 downto 0) := "100";
constant F_ARIT_LOG_SUB     : std_logic_vector(2 downto 0) := "101";
constant F_ARIT_LOG_SHA     : std_logic_vector(2 downto 0) := "110";
constant F_ARIT_LOG_SHL     : std_logic_vector(2 downto 0) := "111";

-- COMPARACIONES
constant F_CMP_LT           : std_logic_vector(2 downto 0) := "000";
constant F_CMP_LE           : std_logic_vector(2 downto 0) := "001";
    --
constant F_CMP_EQ           : std_logic_vector(2 downto 0) := "011";
constant F_CMP_LTU          : std_logic_vector(2 downto 0) := "100";
constant F_CMP_LEU          : std_logic_vector(2 downto 0) := "101";
    --
    --

-- EXTENSION ARITMETICA
constant F_EXT_ARIT_MUL     : std_logic_vector(2 downto 0) := "000";
constant F_EXT_ARIT_MULH    : std_logic_vector(2 downto 0) := "001";
constant F_EXT_ARIT_MULHU   : std_logic_vector(2 downto 0) := "010";
    --
constant F_EXT_ARIT_DIV     : std_logic_vector(2 downto 0) := "100";
constant F_EXT_ARIT_DIVU    : std_logic_vector(2 downto 0) := "101";
    --
    --

-- BRANCHES
constant F_BRANCH_BZ        : std_logic := '0';
constant F_BRANCH_BNZ       : std_logic := '1';

-- JUMPS
constant F_JUMP_JZ          : std_logic_vector(2 downto 0) := "000";
constant F_JUMP_JNZ         : std_logic_vector(2 downto 0) := "001";
    --
constant F_JUMP_JMP         : std_logic_vector(2 downto 0) := "011";
constant F_JUMP_JAL         : std_logic_vector(2 downto 0) := "100";
    --
    --
constant F_JUMP_CALLS       : std_logic_vector(2 downto 0) := "111";


-- MISC
constant F_MISC_MOVI        : std_logic_vector(2 downto 0) := "000";
constant F_MISC_MOVHI       : std_logic_vector(2 downto 0) := "001";

end package_alu;


package body package_alu is

end package_alu;
