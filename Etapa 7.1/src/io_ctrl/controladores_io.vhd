LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
USE ieee.std_logic_unsigned.ALL; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE work.package_io.ALL;

ENTITY controladores_IO IS
    PORT (
        boot       : IN  STD_LOGIC;
        CLOCK_50   : IN  STD_LOGIC;
        inta       : IN  STD_LOGIC;
        intr       : OUT STD_LOGIC;
        addr_io    : IN  STD_LOGIC_VECTOR(7  DOWNTO 0);
        wr_io      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        rd_io      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        wr_out     : IN  STD_LOGIC;
        rd_in      : IN  STD_LOGIC;
        SW         : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        KEY        : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        hex        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        hex_on     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        led_verdes : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        led_rojos  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        ps2_clk    : inout STD_LOGIC;
        ps2_data   : inout STD_LOGIC);
END controladores_IO;

ARCHITECTURE Structure OF controladores_IO IS

    COMPONENT interrupt_ctrl IS
    PORT (
        clk         : IN std_logic;
        boot        : IN std_logic;
        inta        : IN std_logic;
        key_intr    : IN std_logic;
        ps2_intr    : IN std_logic;
        switch_intr : IN std_logic;
        timer_intr  : IN std_logic;
        --
        intr        : OUT std_logic;
        key_inta    : OUT std_logic;
        ps2_inta    : OUT std_logic;
        switch_inta : OUT std_logic;
        timer_inta  : OUT std_logic;
        iid         : OUT std_logic_vector(1 DOWNTO 0));
    END COMPONENT;

    COMPONENT keyboard_int_ctrl IS
        PORT (
            CLOCK_50    : IN    std_logic;
            reset       : IN    std_logic;
            inta        : IN    std_logic;
            intr        : OUT    std_logic;
            ps2_clk     : INOUT std_logic;
            ps2_data    : INOUT std_logic;
            read_char   : OUT   std_logic_vector(7 DOWNTO 0);
            clear_char  : IN    std_logic;
            data_ready  : OUT   std_logic);
    END COMPONENT;

    COMPONENT key_sw_int_ctrl IS
        GENERIC(
            n_bits    : integer);
        PORT (
            clk         : IN std_logic;
            boot        : IN std_logic;
            inta        : IN std_logic;
            data        : IN std_logic_vector(n_bits-1 DOWNTO 0);
            --
            intr        : OUT std_logic;
            read_data   : OUT std_logic_vector(n_bits-1 DOWNTO 0));
    END COMPONENT;

    COMPONENT timer_int_ctrl IS
        PORT (
            clk         : IN std_logic;
            boot        : IN std_logic;
            inta        : IN std_logic;
            --
            intr        : OUT std_logic);
    END COMPONENT;

    TYPE Mat IS ARRAY (255 DOWNTO 0) OF std_logic_vector(15 DOWNTO 0);
    SIGNAL registers : Mat := (OTHERS => (OTHERS => '0'));

    SIGNAL s_ps2_ascii_code : std_logic_vector(7 downto 0);
    SIGNAL s_ps2_clear_char : std_logic;
    SIGNAL s_ps2_data_ready : std_logic;

    SIGNAL s_timer_intr : std_logic;
    SIGNAL s_key_intr : std_logic;
    SIGNAL s_switch_intr : std_logic;
    SIGNAL s_ps2_intr : std_logic;

    SIGNAL s_timer_inta : std_logic;
    SIGNAL s_key_inta : std_logic;
    SIGNAL s_switch_inta : std_logic;
    SIGNAL s_ps2_inta : std_logic;

    SIGNAL s_read_keys : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_read_sw : std_logic_vector(7 DOWNTO 0);

    SIGNAL s_iid : std_logic_vector(1 DOWNTO 0);
BEGIN

    PROCESS (CLOCK_50) IS
        variable v_contador_milisegundos : std_logic_vector(15 downto 0) := x"0000";
        variable v_contador_ciclos       : std_logic_vector(15 downto 0) := x"0000";
    BEGIN
        IF rising_edge(CLOCK_50) THEN
            registers(PORT_KEY)(3 downto 0) <= s_read_keys;
            registers(PORT_SW)(7 downto 0) <= s_read_sw;

            if v_contador_ciclos = 0 then
                v_contador_ciclos := x"C350"; -- tiempo de ciclo=20ns(50Mhz) 1ms=50000ciclos
                if v_contador_milisegundos > 0 then
                    v_contador_milisegundos := v_contador_milisegundos - 1;
                end if;
            else
                v_contador_ciclos := v_contador_ciclos - 1;
            end if;

            registers(PORT_TIMER) <= v_contador_milisegundos;
            registers(PORT_RAND) <= v_contador_ciclos;

            IF wr_out = '1' AND addr_io /= PORT_KEY AND addr_io /= PORT_SW THEN
                if addr_io = PORT_PS2_DATA_VALID THEN
                    registers(conv_integer(addr_io)) <= x"0000";
                    s_ps2_clear_char <= '1';
                ELSE
                    registers(conv_integer(addr_io)) <= wr_io;
                    if addr_io = PORT_TIMER then
                        v_contador_milisegundos := wr_io;
                    end if;
                END IF;
            ELSE
                s_ps2_clear_char <= '0';
            END IF;

            IF s_ps2_data_ready = '1' THEN
                registers(PORT_PS2_DATA)(7 downto 0) <= s_ps2_ascii_code;
                registers(PORT_PS2_DATA_VALID) <= x"FFFF";
            END IF;
        END IF;
    END PROCESS;

    -- Read con enable
    rd_io <= registers(conv_integer(addr_io))   WHEN rd_in = '1' AND inta = '0' ELSE
             x"000" & "00" & s_iid              WHEN inta = '1'                 ELSE
             x"0000";

    hex <= registers(PORT_HEX)(15 downto 0);
    hex_on <= registers(PORT_HEX_OFF)(3 downto 0);
    led_verdes <= registers(PORT_GREEN_LEDS)(7 downto 0);
    led_rojos <= registers(PORT_RED_LEDS)(7 downto 0);

    intr_ctrl: interrupt_ctrl PORT MAP(
        clk         => CLOCK_50,
        boot        => boot,
        inta        => inta,
        key_intr    => s_key_intr,
        ps2_intr    => s_ps2_intr,
        switch_intr => s_switch_intr,
        timer_intr  => s_timer_intr,
        --
        intr        => intr,
        key_inta    => s_key_inta,
        ps2_inta    => s_ps2_inta,
        switch_inta => s_switch_inta,
        timer_inta  => s_timer_inta,
        iid         => s_iid
    );

    keyboard0: keyboard_int_ctrl PORT MAP(
        CLOCK_50    => CLOCK_50,
        reset       => boot,
        inta        => s_ps2_inta,
        intr        => s_ps2_intr,
        ps2_clk     => ps2_clk,
        ps2_data    => ps2_data,
        read_char   => s_ps2_ascii_code,
        clear_char  => s_ps2_clear_char,
        data_ready  => s_ps2_data_ready
    );

    keys0: key_sw_int_ctrl
    GENERIC MAP(
        n_bits    => 4)
    PORT MAP(
        clk         => CLOCK_50,
        boot        => boot,
        inta        => s_key_inta,
        data        => KEY,
        --
        intr        => s_key_intr,
        read_data   => s_read_keys
    );

    switches0: key_sw_int_ctrl
    GENERIC MAP(
        n_bits    => 8)
    PORT MAP(
        clk         => CLOCK_50,
        boot        => boot,
        inta        => s_switch_inta,
        data        => SW,
        --
        intr        => s_switch_intr,
        read_data   => s_read_sw
    );

    timer0: timer_int_ctrl PORT MAP (
        clk         => CLOCK_50,
        boot        => boot,
        inta        => s_timer_inta,
        --
        intr        => s_timer_intr
    );

END Structure;
