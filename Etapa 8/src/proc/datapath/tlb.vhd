LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_tlb.ALL;

ENTITY tlb IS
    PORT (
        -- INPUT
        clk         : IN  std_logic;
        boot        : IN  std_logic;
        -- =========== INPUT de lectura ===========
        -- El vtag que se quiere buscar
        vtag        : IN  std_logic_vector(3 DOWNTO 0);
        -- =========== INPUT de escritura ===========
        -- ID de la entrada que se quiere escribir
        tag_addr    : IN  std_logic_vector(2 DOWNTO 0);
        -- Write Enable para escribir tags
        we          : IN  std_logic;
        -- Selecciona si la escritura se efectua en el banco virtual o físico
        we_sel      : IN  std_logic;
        -- Data line de la entrada del tag que se quiere escribir
        tag_d       : IN  std_logic_vector(5 DOWNTO 0);
        -- =========== INPUT control ============
        flush       : IN  std_logic;

        -- OUTPUT
        -- =========== OUTPUT control ===========
        tlb_miss    : OUT std_logic;
        -- ============ OUTPUT datos ============
        ptag        : OUT std_logic_vector(3 DOWNTO 0);
        v           : OUT std_logic;
        r           : OUT std_logic);
END tlb;

ARCHITECTURE Structure OF tlb IS

    CONSTANT c_NUM_ENTRIES  : INTEGER := 8;
    CONSTANT c_TAG_WIDTH    : INTEGER := 4;

    TYPE t_entry IS RECORD
        vtag : std_logic_vector(c_TAG_WIDTH-1 DOWNTO 0);
        ptag : std_logic_vector(c_TAG_WIDTH-1 DOWNTO 0);
        v    : std_logic;
        r    : std_logic;
    END RECORD;


    TYPE t_tlb IS ARRAY (c_NUM_ENTRIES-1 DOWNTO 0) OF t_entry;

    signal s_tlb            : t_tlb;
    SIGNAL s_output_idx     : INTEGER range 0 to c_NUM_ENTRIES - 1 := 0;
    SIGNAL s_one_hot        : std_logic_vector(c_NUM_ENTRIES-1 DOWNTO 0) := (OTHERS => '0');

    CONSTANT c_init_tlb : t_tlb := (
        (x"F", x"F", '1', '1'),
        (x"E", x"E", '1', '1'),
        (x"D", x"D", '1', '0'),
        (x"C", x"C", '1', '0'),
        (x"8", x"8", '1', '0'),
        (x"2", x"2", '1', '0'),
        (x"1", x"1", '1', '0'),
        (x"0", x"0", '1', '0')
    );

BEGIN

    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF boot = '1' THEN
                s_tlb <= c_init_tlb;
            ELSE
                IF flush = '1' THEN
                    FOR i IN s_tlb'range LOOP
                        s_tlb(i).v <= '0';
                    END LOOP;
                ELSE
                    IF we = '1' THEN
                        IF we_sel = W_SEL_VIRTUAL THEN
                            s_tlb(to_integer(unsigned(tag_addr))).vtag <= tag_d(c_TAG_WIDTH-1 DOWNTO 0);
                        ELSE -- WE_SEL_PHYSICAL
                            s_tlb(to_integer(unsigned(tag_addr))).v    <= tag_d(c_TAG_WIDTH+1);
                            s_tlb(to_integer(unsigned(tag_addr))).r    <= tag_d(c_TAG_WIDTH);
                            s_tlb(to_integer(unsigned(tag_addr))).ptag <= tag_d(c_TAG_WIDTH-1 DOWNTO 0);
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Comparadores        IF s_one_hot = (OTHERS => '0') THEN
    g_generate: FOR i IN 0 TO c_NUM_ENTRIES-1 GENERATE
        s_one_hot(i) <= '1' WHEN vtag = s_tlb(i).vtag ELSE '0';
    END GENERATE;

    PROCESS (s_one_hot) IS
        VARIABLE v_idx : INTEGER range 0 to c_NUM_ENTRIES - 1 := 0;
        VARIABLE v_tlb_miss : std_logic := '0';
        VARIABLE v_inverted_one_hot : std_logic_vector(0 TO c_NUM_ENTRIES-1) := (OTHERS => '0');
    BEGIN
        -- IF s_one_hot = 0 THEN
        --     -- TENEMOS UN FALLO DE TLB
        -- ELSE
        --     v_inverted_one_hot := s_one_hot;
        --     FOR i IN v_inverted_one_hot'range LOOP
        --         IF v_inverted_one_hot(i) = '1' THEN
        --             v_idx := i;
        --         END IF;
        --     END LOOP;
        --     s_output_idx <= v_idx;
        -- END IF;

        v_tlb_miss := '0';
        v_idx := s_output_idx;

        IF    s_one_hot(0) = '1' THEN
            v_idx := 0;
        ELSIF s_one_hot(1) = '1' THEN
            v_idx := 1;
        ELSIF s_one_hot(2) = '1' THEN
            v_idx := 2;
        ELSIF s_one_hot(3) = '1' THEN
            v_idx := 3;
        ELSIF s_one_hot(4) = '1' THEN
            v_idx := 4;
        ELSIF s_one_hot(5) = '1' THEN
            v_idx := 5;
        ELSIF s_one_hot(6) = '1' THEN
            v_idx := 6;
        ELSIF s_one_hot(7) = '1' THEN
            v_idx := 7;
        ELSE
            -- No encontrado. Fallo de tlb
            v_tlb_miss := '1';
        END IF;

        s_output_idx <= v_idx;
        tlb_miss <= v_tlb_miss;
    END PROCESS;

    ptag <= s_tlb(s_output_idx).ptag;
    v    <= s_tlb(s_output_idx).v;
    r    <= s_tlb(s_output_idx).r;

END Structure;

