LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.package_exceptions.ALL;
USE work.package_opcodes.ALL;

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

    SIGNAL s_opcode: std_logic_vector(3 DOWNTO 0);
    SIGNAL s_is_memw_instr: std_logic;

    SIGNAL s_true_bad_alignment: std_logic;

    SIGNAL s_exception_code_register: std_logic_vector(3 DOWNTO 0);
    SIGNAL s_exception: std_logic;

BEGIN

    s_opcode <= ir(15 DOWNTO 12);
    s_is_memw_instr <= '1' WHEN s_opcode = OPCODE_LOAD OR
                                s_opcode = OPCODE_STORE ELSE
                       '0';

    s_true_bad_alignment <= bad_allignment AND s_is_memw_instr;

    illegal_ir1: illegal_ir PORT MAP (ir, s_illegal);
    s_interrupt <= int_enabled AND intr;

    s_exception <= s_illegal OR s_interrupt OR s_true_bad_alignment;
    exception <= s_exception;

    process (s_exception) is
    begin
        if rising_edge(s_exception) then
            if s_illegal = '1' then
                s_exception_code_register <= EX_ILLEGAL_INSTR;
            elsif s_interrupt = '1' then
                s_exception_code_register <= EX_INTERRUPT_CODE;
            elsif s_true_bad_alignment = '1' then
                s_exception_code_register <= EX_BAD_ALLIGNMENT;
            elsif div_by_zero = '1' then
                s_exception_code_register <= EX_DIV_BY_ZERO;
            else
                s_exception_code_register <= (OTHERS => 'X');
            end if;
        end if;
    end process;

    exception_code <= s_exception_code_register;

END Structure;

