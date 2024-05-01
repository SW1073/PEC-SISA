library ieee;
use ieee.std_logic_1164.all;


entity test_sisa is
    -- la entidad de test es una entidad vacía.
    -- no tiene señales que entren o salgan,
    -- solamente señales que se generan dentro
    -- para controlar el DUT
end test_sisa;

architecture comportament of test_sisa is
    component async_64Kx16 is
        generic (
            ADDR_BITS		: integer := 16;
            DATA_BITS		: integer := 16;
            depth 			: integer := 65536;

            TimingInfo		: BOOLEAN := TRUE;
            TimingChecks	: std_logic := '1'
        );
        port (
            CE_b    : IN Std_Logic;	                                                -- Chip Enable CE#
            WE_b  	: IN Std_Logic;	                                                -- Write Enable WE#
            OE_b  	: IN Std_Logic;                                                 -- Output Enable OE#
            BHE_b	: IN std_logic;                                                 -- Byte Enable High BHE#
            BLE_b   : IN std_logic;                                                 -- Byte Enable Low BLE#
            A 		: IN Std_Logic_Vector(addr_bits-1 downto 0);                    -- Address Inputs A
            DQ		: INOUT Std_Logic_Vector(DATA_BITS-1 downto 0):=(others=>'Z');   -- Read/Write Data IO
            boot    : in std_logic
        );
    end component;


    component sisa is
        port (
             CLOCK_50  : IN    std_logic;
             SRAM_ADDR : OUT   std_logic_vector(17 DOWNTO 0);
             SRAM_DQ   : INOUT std_logic_vector(15 DOWNTO 0);
             SRAM_UB_N : OUT   std_logic;
             SRAM_LB_N : OUT   std_logic;
             SRAM_CE_N : OUT   std_logic := '1';
             SRAM_OE_N : OUT   std_logic := '1';
             SRAM_WE_N : OUT   std_logic := '1';
             SW        : IN    std_logic_vector(9 DOWNTO 0);
             KEY       : IN    std_logic_vector(3 DOWNTO 0);
             HEX0      : OUT   std_logic_vector(6 DOWNTO 0);
             HEX1      : OUT   std_logic_vector(6 DOWNTO 0);
             HEX2      : OUT   std_logic_vector(6 DOWNTO 0);
             HEX3      : OUT   std_logic_vector(6 DOWNTO 0);
             LEDG      : OUT   std_logic_vector(7 DOWNTO 0);
             LEDR      : OUT   std_logic_vector(7 DOWNTO 0);
             PS2_CLK   : INOUT std_logic;
             PS2_DAT   : INOUT std_logic);
    end component;

    component ps2_keyboard_emul is
        port (
            i_data_to_send  : in    std_logic_vector(7 downto 0);
            i_send          : in    std_logic;
            o_done          : out   std_logic;
            ps2_data        : inout std_logic;
            ps2_clk         : inout std_logic);
    end component;


    -- Registres (entrades) i cables
    signal clk                  : std_logic := '0';
    signal reset_ram            : std_logic := '0';
    signal reset_proc           : std_logic := '0';

    signal addr_SoC             : std_logic_vector(17 downto 0);
    signal addr_mem             : std_logic_vector(15 downto 0);
    signal data_mem             : std_logic_vector(15 downto 0);

    signal ub_m                 : std_logic;
    signal lb_m                 : std_logic;
    signal ce_m                 : std_logic;
    signal oe_m                 : std_logic;
    signal we_m                 : std_logic;
    signal ce_m2                : std_logic;

    signal botones              : std_logic_vector(9 downto 0);


    signal s_ps2_data_to_send   : std_logic_vector(7 downto 0);
    signal s_ps2_send           : std_logic;
    signal s_ps2_done           : std_logic;

    signal s_ps2_clk            : std_logic;
    signal s_ps2_dat            : std_logic;


    constant c_N                : integer := 4;
    type arr_t is array (0 to c_N-1) of std_logic_vector(7 downto 0);
    signal s_keyboard_scancodes : arr_t := (x"1C", x"F0", x"1C", x"1B");
    signal s_keyboard_idx       : integer range 0 to c_N-1 := 0;
    signal s_keyboard_done      : std_logic := '0';

    signal s_keys               : std_logic_vector(3 downto 0) := x"0";
begin

    s_ps2_data_to_send <= s_keyboard_scancodes(s_keyboard_idx);
    s_ps2_send <= '0' when (s_keyboard_done = '1' or reset_proc = '1') else '1';

    keyboard_sender: process (s_ps2_done) is
    begin
        if rising_edge(s_ps2_done) then
            if s_keyboard_idx = c_N-1 then
                s_keyboard_done <= '1';
            else
                s_keyboard_idx <= s_keyboard_idx + 1;
            end if;
        end if;
    end process; -- keyboard sender

    ce_m2 <= '1', ce_m after 100ns;

    -- Instanciacions de moduls
    SoC : sisa port map (
        CLOCK_50    => clk,
        SW          => botones,
        KEY         => s_keys,

        SRAM_ADDR   => addr_SoC,
        SRAM_DQ     => data_mem,
        SRAM_UB_N   => ub_m,
        SRAM_LB_N   => lb_m,
        SRAM_CE_N   => ce_m,
        SRAM_OE_N   => oe_m,
        SRAM_WE_N   => we_m,
        PS2_clk     => s_ps2_clk,
        PS2_DAT     => s_ps2_dat
    );

    mem0 : async_64Kx16 port map (
        A 	 => addr_mem,
        DQ  => data_mem,

        --CE_b => ce_m,
        CE_b => ce_m2,
        OE_b => oe_m,
        WE_b => we_m,
        BLE_b => lb_m,
        BHE_b => ub_m,

        boot     => reset_ram
    );

    keyboard : ps2_keyboard_emul port map (
        i_data_to_send => s_ps2_data_to_send,
        i_send => s_ps2_send,
        o_done => s_ps2_done,

        ps2_clk => s_ps2_clk,
        ps2_data => s_ps2_dat
    );

    -- Creamos una interrupcion (a priori)
    s_keys <= x"0", x"2" after 400 ns;

    addr_mem (15 downto 0) <= addr_SOC (15 downto 0);
    botones(9) <= reset_proc;
    botones(8) <= '0'; -- normal running mode

    -- Descripcio del comportament
    clk <= not clk after 10 ns;
    reset_ram <= '1' after 15 ns, '0' after 50 ns;    -- reseteamos la RAm en el primer ciclo
    reset_proc <= '1' after 25 ns, '0' after 320 ns;  -- reseteamos el procesador en el segundo ciclo


end comportament;


