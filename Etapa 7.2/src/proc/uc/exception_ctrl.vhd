LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.package_exceptions.ALL;

ENTITY exception_ctrl IS
	PORT (
		clk             : IN  std_logic;
        ir              : IN  std_logic_vector(15 DOWNTO 0);
        int_enabled     : IN std_logic;
        intr            : IN std_logic;
        bad_allignment  : IN std_logic;
        div_by_zero     : IN std_logic;
        exception       : OUT std_logic;
        exception_code  : OUT std_logic_vector(3 DOWNTO 0));
END ENTITY;

ARCHITECTURE Structure OF exception_ctrl IS

    COMPONENT illegal_ir IS
	PORT (
		ir              : IN  std_logic_vector(15 DOWNTO 0);
        is_illegal      : OUT std_logic);
    END COMPONENT;

    SIGNAL s_illegal : std_logic;
    SIGNAL s_interrupt : std_logic;

BEGIN

    illegal_ir1: illegal_ir PORT MAP (ir, s_illegal);
    s_interrupt <= int_enabled AND intr;

    exception <= s_illegal OR s_interrupt OR bad_allignment OR div_by_zero;
    exception_code <= EX_ILLEGAL_INSTR WHEN s_illegal = '1' ELSE
                      EX_INTERRUPT_CODE WHEN s_interrupt = '1' ELSE
                      EX_BAD_ALLIGNMENT WHEN bad_allignment = '1' ELSE
                      EX_DIV_BY_ZERO WHEN div_by_zero = '1' ELSE
                      (OTHERS => '0');

END Structure;

