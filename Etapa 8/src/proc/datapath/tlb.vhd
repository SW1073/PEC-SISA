LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY tlb IS
	PORT (
        clk     : IN  std_logic;
        boot    : IN  std_logic;

        -- El vtag que se quiere buscar (o escribir, depende del estado de we_v)
        vtag    : IN  std_logic_vector(3 DOWNTO 0);
        -- ID de la entrada que se quiere escribir
        addr    : IN  std_logic_vector(2 DOWNTO 0);
        -- Write Enable para la entrada del vtag
        we_v    : IN  std_logic;
        -- Write Enable para la entrada del ptag
        we_p    : IN  std_logic;
        -- Data line de la entrada del ptag que se quiere escribir
        ptag_d  : IN  std_logic_vector(5 DOWNTO 0);

        -- Output
        ptag    : OUT std_logic_vector(3 DOWNTO 0);
        v       : OUT std_logic;
        r       : OUT std_logic);
END tlb;

ARCHITECTURE Structure OF tlb IS

    CONSTANT c_NUM_ENTRIES : INTEGER := 8;
    SIGNAL s_output_idx : INTEGER range 0 to c_NUM_ENTRIES - 1 := 0;

	TYPE t_vtlb IS ARRAY (c_NUM_ENTRIES-1 DOWNTO 0) OF std_logic_vector(3 DOWNTO 0);
	TYPE t_ptlb IS ARRAY (c_NUM_ENTRIES-1 DOWNTO 0) OF std_logic_vector(5 DOWNTO 0);

	SIGNAL s_vtlb : t_vtlb := (OTHERS => (OTHERS => '0'));
    SIGNAL s_ptlb : t_ptlb := (OTHERS => (OTHERS => '0'));

    SIGNAL s_compares : std_logic_vector(c_NUM_ENTRIES-1 DOWNTO 0) := (OTHERS => '0');

    CONSTANT c_init_vtlb : t_vtlb := (
        x"0",
        x"1",
        x"2",
        x"8",
        x"C",
        x"D",
        x"E",
        x"F"
    );

    CONSTANT c_init_ptlb : t_ptlb := (
        x"0" & "10",
        x"1" & "10",
        x"2" & "10",
        x"8" & "10",
        x"C" & "10",
        x"D" & "10",
        x"E" & "11",
        x"F" & "11"
    );

BEGIN

    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF boot = '1' THEN
                s_vtlb <= c_init_vtlb;
                s_ptlb <= c_init_ptlb;
            ELSE
                IF we_v = '1' THEN
                    s_vtlb(to_integer(unsigned(addr))) <= vtag;
                END IF;
                IF we_p = '1' THEN
                    s_ptlb(to_integer(unsigned(addr))) <= ptag_d;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Comparadores
    g_generate: FOR i IN 0 TO c_NUM_ENTRIES-1 GENERATE
        s_compares(i) <= '1' WHEN vtag = s_vtlb(i) ELSE '0';
    END GENERATE;

    PROCESS (s_compares) IS
    BEGIN
        -- Else if necesario, pues en caso de tener coincidencia en dos o mas
        -- entradas se quedaria con la primera que cumpla la condicion.
        IF    s_compares(0) = '1' THEN
            s_output_idx <= 0;
        ELSIF s_compares(1) = '1' THEN
            s_output_idx <= 1;
        ELSIF s_compares(2) = '1' THEN
            s_output_idx <= 2;
        ELSIF s_compares(3) = '1' THEN
            s_output_idx <= 3;
        ELSIF s_compares(4) = '1' THEN
            s_output_idx <= 4;
        ELSIF s_compares(5) = '1' THEN
            s_output_idx <= 5;
        ELSIF s_compares(6) = '1' THEN
            s_output_idx <= 6;
        ELSIF s_compares(7) = '1' THEN
            s_output_idx <= 7;

        ELSE
            -- No encontrado. Fallo de tlb TODO
            s_output_idx <= 0;
        END IF;
    END PROCESS;

    -- s_output_idx <= 0 WHEN s_compares(0) = '1' ELSE
    --                 1 WHEN s_compares(1) = '1' ELSE
    --                 2 WHEN s_compares(2) = '1' ELSE
    --                 3 WHEN s_compares(3) = '1' ELSE
    --                 4 WHEN s_compares(4) = '1' ELSE
    --                 5 WHEN s_compares(5) = '1' ELSE
    --                 6 WHEN s_compares(6) = '1' ELSE
    --                 7 WHEN s_compares(7) = '1' ELSE
    --                 0;

    ptag <= s_ptlb(s_output_idx)(5 DOWNTO 2);
    v <= s_ptlb(s_output_idx)(1);
    r <= s_ptlb(s_output_idx)(0);

END Structure;

