LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

package package_opcodes is

constant    OPCODE_ARIT_LOG     :   std_logic_vector(3 downto 0) := "0000";
constant    OPCODE_CMPS         :   std_logic_vector(3 downto 0) := "0001";
constant    OPCODE_IMMED        :   std_logic_vector(3 downto 0) := "0010";
constant    OPCODE_EXT_ARIT     :   std_logic_vector(3 downto 0) := "1000";
constant    OPCODE_LOAD         :   std_logic_vector(3 downto 0) := "0011";
constant    OPCODE_STORE        :   std_logic_vector(3 downto 0) := "0100";
constant    OPCODE_LOADB        :   std_logic_vector(3 downto 0) := "1101";
constant    OPCODE_STOREB       :   std_logic_vector(3 downto 0) := "1110";
constant    OPCODE_MOVS         :   std_logic_vector(3 downto 0) := "0101";

end package_opcodes;

package body package_opcodes is

end package_opcodes;
