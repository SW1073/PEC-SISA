LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

PACKAGE package_control IS

	CONSTANT TKNBR_NOT_TAKEN : std_logic_vector(1 DOWNTO 0) := "00";
	CONSTANT TKNBR_BRANCH    : std_logic_vector(1 DOWNTO 0) := "01";
	CONSTANT TKNBR_JUMP      : std_logic_vector(1 DOWNTO 0) := "10";

	CONSTANT IN_D_ALUOUT     : std_logic_vector(1 DOWNTO 0) := "00";
	CONSTANT IN_D_DATAMEM    : std_logic_vector(1 DOWNTO 0) := "01";
	CONSTANT IN_D_PC         : std_logic_vector(1 DOWNTO 0) := "10";
	CONSTANT IN_D_IO         : std_logic_vector(1 DOWNTO 0) := "11";

    CONSTANT A_SYS_OUT_REG   : std_logic := '0';
    CONSTANT A_SYS_OUT_SYS   : std_logic := '1';

    CONSTANT BIMM_IMMED_OUT  : std_logic := '0';
    CONSTANT BIMM_B_OUT      : std_logic := '1';

END package_control;

PACKAGE BODY package_control IS

END package_control;

