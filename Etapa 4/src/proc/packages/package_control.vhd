LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

package package_control is

constant TKNBR_NOT_TAKEN    : std_logic_vector(1 downto 0) := "00";
constant TKNBR_BRANCH       : std_logic_vector(1 downto 0) := "01";
constant TKNBR_JUMP         : std_logic_vector(1 downto 0) := "10";

constant IN_D_ALUOUT        : std_logic_vector(1 downto 0) := "00";
constant IN_D_DATAMEM       : std_logic_vector(1 downto 0) := "01";
constant IN_D_PC            : std_logic_vector(1 downto 0) := "10";

end package_control;

package body package_control is

end package_control;
