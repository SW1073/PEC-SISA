LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.package_records.ALL;
USE work.package_exceptions.ALL;

ENTITY exception_ctrl IS
	PORT (
		clk             : IN std_logic;
        vaddr_m_msb     : IN std_logic;
        vaddr_m_lsb     : IN std_logic;
        word_byte       : IN std_logic;
        is_mem_access   : IN std_logic;
        wr_m            : IN std_logic;
        int_enabled     : IN std_logic;
        intr            : IN std_logic;
        is_illegal_ir   : IN std_logic;
        div_by_zero     : IN std_logic;
        is_protected_ir : IN std_logic;
        calls           : IN std_logic;
        privileged      : IN std_logic;
        tlb_miss        : IN std_logic;
        tlb_valid       : IN std_logic;
        tlb_readonly    : IN std_logic;
        ins_dad         : IN std_logic;
        exception       : OUT t_exception_record);
END ENTITY;

ARCHITECTURE Structure OF exception_ctrl IS

    SIGNAL s_bad_alignment : std_logic;
    SIGNAL s_interrupt     : std_logic;
    SIGNAL s_protected_ir  : std_logic;
    SIGNAL s_protected_mem : std_logic;
    SIGNAL s_calls         : std_logic;


    SIGNAL s_tlb_miss      : std_logic;
    SIGNAL s_tlb_invalid   : std_logic;
    SIGNAL s_tlb_readonly  : std_logic;

    SIGNAL s_is_fetch           : std_logic;
    SIGNAL s_is_demw            : std_logic;
    SIGNAL s_is_demw_mem_access : std_logic;

BEGIN

    s_is_fetch           <= not ins_dad;
    s_is_demw            <= ins_dad;
    s_is_demw_mem_access <= is_mem_access AND s_is_demw;

    s_bad_alignment <=  (
                            (is_mem_access AND s_is_demw AND not word_byte)
                            OR
                            (s_is_fetch)
                        ) AND
                        vaddr_m_lsb;

    s_interrupt <= not is_illegal_ir AND
                   int_enabled       AND
                   intr;

    s_protected_ir <= not is_illegal_ir AND
                      is_protected_ir   AND
                      not privileged;

    s_protected_mem <= not is_illegal_ir AND
                       is_mem_access     AND
                       vaddr_m_msb       AND
                       not privileged;

    s_calls <= not is_illegal_ir AND
               calls;

    s_tlb_miss <= not is_illegal_ir AND
                  tlb_miss;

    s_tlb_invalid <= not is_illegal_ir    AND
                     not tlb_miss         AND
                     not tlb_valid;

    s_tlb_readonly <= not is_illegal_ir AND
                      not tlb_miss      AND
                      tlb_valid         AND
                      tlb_readonly      AND
                      not privileged    AND
                      is_mem_access     AND
                      wr_m;

    exception.is_exception <= '1' WHEN (s_is_demw = '1' AND (
                                       -- DEMW
                                           div_by_zero = '1'       OR
                                           is_illegal_ir = '1'     OR
                                           s_tlb_readonly = '1'    OR
                                           s_protected_ir = '1'    OR
                                           s_calls = '1'
                                       ))
                                       -- Both FETCH or DEMW
                                       OR (
                                           s_bad_alignment = '1'   OR
                                           s_interrupt = '1'
                                       )
                                       -- Fetch, or DEMW with memory access
                                       OR ((s_is_demw_mem_access = '1' OR s_is_fetch = '1') AND
                                           (s_tlb_miss = '1'        OR
                                            s_protected_mem = '1'   OR
                                            s_tlb_invalid = '1')
                                       )
                              ELSE '0';

    exception.code <=   EX_DIV_BY_ZERO      WHEN div_by_zero = '1'      AND s_is_demw = '1'             ELSE
                        EX_ILLEGAL_INSTR    WHEN is_illegal_ir = '1'    AND s_is_demw = '1'             ELSE
                        EX_BAD_ALIGNMENT    WHEN s_bad_alignment = '1'                                  ELSE
                        -- TLB
                        EX_MISS_ITLB        WHEN s_tlb_miss = '1'       AND s_is_fetch = '1'            ELSE
                        EX_MISS_DTLB        WHEN s_tlb_miss = '1'       AND s_is_demw_mem_access = '1'  ELSE

                        EX_INVALID_ITLB     WHEN s_tlb_invalid = '1'    AND s_is_fetch = '1'            ELSE
                        EX_INVALID_DTLB     WHEN s_tlb_invalid = '1'    AND s_is_demw_mem_access = '1'  ELSE

                        EX_PROTECTED_ITLB   WHEN s_protected_mem = '1'  AND s_is_fetch = '1'            ELSE
                        EX_PROTECTED_DTLB   WHEN s_protected_mem = '1'  AND s_is_demw_mem_access = '1'  ELSE

                        EX_READONLY_DTLB    WHEN s_tlb_readonly = '1'   AND s_is_demw_mem_access = '1'  ELSE
                        -- NON EXCEPTION EXCEPTIONS
                        EX_PROTECTED_IR     WHEN s_protected_ir = '1'   AND s_is_demw = '1'             ELSE
                        EX_CALLS            WHEN s_calls = '1'          AND s_is_demw = '1'             ELSE
                        EX_INTERRUPT_CODE   WHEN s_interrupt = '1'                                      ELSE
                        (OTHERS => 'X');

END Structure;

