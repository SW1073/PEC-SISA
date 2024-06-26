LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.package_records.ALL;
USE work.package_exceptions.ALL;

ENTITY exception_ctrl IS
	PORT (
		clk             : IN std_logic;
        addr_m          : IN std_logic_vector(15 DOWNTO 0);
        is_word_mem_access : IN std_logic;
        int_enabled     : IN std_logic;
        intr            : IN std_logic;
        is_illegal_ir   : IN  std_logic;
        div_by_zero     : IN std_logic;
        exception       : OUT t_exception_record);
END ENTITY;

ARCHITECTURE Structure OF exception_ctrl IS

    SIGNAL s_bad_alignment : std_logic;
    SIGNAL s_interrupt     : std_logic;

    -- de control_l sale:
        -- illegal_ir
        -- is_mem_access

BEGIN

    s_bad_alignment <= '1' WHEN is_word_mem_access = '1' AND addr_m(0) = '1'
                       ELSE '0';

    s_interrupt <= '1' WHEN int_enabled = '1' AND intr = '1'
                  ELSE '0';

    exception.is_exception <= '1' WHEN  s_interrupt = '1'   OR
                                        is_illegal_ir = '1' OR
                                        div_by_zero = '1'   OR
                                        s_bad_alignment = '1'
                            ELSE '0';

    exception.code <=   EX_DIV_BY_ZERO      WHEN div_by_zero = '1'      ELSE 
                        EX_ILLEGAL_INSTR    WHEN is_illegal_ir = '1'    ELSE
                        EX_BAD_ALIGNMENT   WHEN s_bad_alignment = '1'  ELSE
                        EX_INTERRUPT_CODE   WHEN s_interrupt = '1'      ELSE
                        (OTHERS => 'X'); 

END Structure;

