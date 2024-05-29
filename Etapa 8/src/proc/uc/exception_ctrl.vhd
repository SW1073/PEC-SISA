LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.package_records.ALL;
USE work.package_exceptions.ALL;

ENTITY exception_ctrl IS
	PORT (
		clk             : IN std_logic;
        addr_m          : IN std_logic_vector(15 DOWNTO 0);
        word_byte       : IN std_logic;
        is_mem_access   : IN std_logic;
        int_enabled     : IN std_logic;
        intr            : IN std_logic;
        is_illegal_ir   : IN std_logic;
        div_by_zero     : IN std_logic;
        is_protected_ir : IN std_logic;
        calls           : IN std_logic;
        privileged      : IN std_logic;
        is_demw         : IN std_logic;
        tlb_status_out  : IN t_tlb_status_out;
        wr_m            : IN std_logic;
        exception       : OUT t_exception_record);
END ENTITY;

ARCHITECTURE Structure OF exception_ctrl IS

    SIGNAL s_bad_alignment : std_logic;
    SIGNAL s_interrupt     : std_logic;
    SIGNAL s_protected_ir  : std_logic;
    SIGNAL s_protected_mem : std_logic;
    SIGNAL s_calls         : std_logic;

    SIGNAL s_tlb_miss_i      : std_logic;
    SIGNAL s_tlb_invalid_i   : std_logic;

    SIGNAL s_tlb_miss_d      : std_logic;
    SIGNAL s_tlb_invalid_d   : std_logic;
    SIGNAL s_tlb_readonly_d  : std_logic;

    SIGNAL s_div_by_zero    : std_logic;

BEGIN

    s_div_by_zero <= not is_illegal_ir AND
                     is_demw           AND
                     div_by_zero;

    s_bad_alignment <= is_mem_access AND
                       not word_byte AND
                       tlb_status_out.v_addr_lsb;

    s_interrupt <= not is_illegal_ir AND
                   int_enabled       AND
                   intr              AND
                   is_demw;

    s_protected_ir <= not is_illegal_ir AND
                      is_protected_ir   AND
                      not privileged    AND
                      is_demw;

    s_protected_mem <= not is_illegal_ir            AND
                       is_mem_access                AND
                       tlb_status_out.v_addr_msb    AND
                       not privileged;

    s_calls <= not is_illegal_ir AND
               is_demw           AND
               calls;

    s_tlb_miss_i <= not is_illegal_ir       AND
                  not is_demw               AND
                  tlb_status_out.tlb_miss_i;

    s_tlb_invalid_i <= not is_illegal_ir              AND
                     not is_demw                    AND
                     not tlb_status_out.tlb_miss_i  AND
                     not tlb_status_out.tlb_valid_i;

    s_tlb_miss_d <= not is_illegal_ir   AND
                  is_mem_access         AND
                  is_demw               AND
                  tlb_status_out.tlb_miss_d;

    s_tlb_invalid_d <= not is_illegal_ir            AND
                     is_demw                      AND
                     is_mem_access                AND
                     not tlb_status_out.tlb_miss_d  AND
                     not tlb_status_out.tlb_valid_d;

    s_tlb_readonly_d <= not is_illegal_ir AND
                      is_mem_access       AND
                      wr_m                AND
                      not tlb_status_out.tlb_miss_d      AND
                      tlb_status_out.tlb_valid_d         AND
                      tlb_status_out.tlb_readonly_d;

    exception.is_exception <= '1' WHEN  s_interrupt = '1'       OR
                                        is_illegal_ir = '1'     OR
                                        div_by_zero = '1'       OR
                                        s_protected_ir = '1'    OR
                                        s_protected_mem = '1'   OR
                                        s_calls = '1'           OR
                                        s_tlb_miss_i = '1'      OR
                                        s_tlb_invalid_i = '1'     OR
                                        s_tlb_miss_d = '1'      OR
                                        s_tlb_invalid_d = '1'     OR
                                        s_tlb_readonly_d = '1'  OR
                                        s_bad_alignment = '1'
                            ELSE '0';

    exception.code <=   EX_DIV_BY_ZERO      WHEN s_div_by_zero = '1'    ELSE
                        EX_ILLEGAL_INSTR    WHEN is_illegal_ir = '1'    ELSE
                        EX_BAD_ALIGNMENT    WHEN s_bad_alignment = '1'  ELSE
                    -- TLB
                        EX_MISS_ITLB        WHEN s_tlb_miss_i = '1'       ELSE
                        EX_MISS_DTLB        WHEN s_tlb_miss_d = '1'       ELSE

                        EX_INVALID_ITLB     WHEN s_tlb_invalid_i = '1'    ELSE
                        EX_INVALID_DTLB     WHEN s_tlb_invalid_d = '1'    ELSE

                        EX_PROTECTED_ITLB   WHEN s_protected_mem = '1'  ELSE
                        EX_PROTECTED_DTLB   WHEN s_protected_mem = '1'  ELSE

                        EX_READONLY_DTLB    WHEN s_tlb_readonly_d = '1'   ELSE
                    -- NON EXCEPTION EXCEPTIONS
                        EX_PROTECTED_IR     WHEN s_protected_ir = '1'   ELSE
                        EX_CALLS            WHEN s_calls = '1'          ELSE
                        EX_INTERRUPT_CODE   WHEN s_interrupt = '1'      ELSE
                        (OTHERS => 'X');
END Structure;

