LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_records.ALL;

ENTITY sisa IS
	PORT (
		CLOCK_50    : IN    std_logic;
		SRAM_ADDR   : OUT   std_logic_vector(17 DOWNTO 0);
		SRAM_DQ     : INOUT std_logic_vector(15 DOWNTO 0);
		SRAM_UB_N   : OUT   std_logic;
		SRAM_LB_N   : OUT   std_logic;
		SRAM_CE_N   : OUT   std_logic := '1';
		SRAM_OE_N   : OUT   std_logic := '1';
		SRAM_WE_N   : OUT   std_logic := '1';
		SW          : IN    std_logic_vector(9 DOWNTO 0);
        KEY         : IN    std_logic_vector(3 DOWNTO 0);
		HEX0        : OUT   std_logic_vector(6 DOWNTO 0);
		HEX1        : OUT   std_logic_vector(6 DOWNTO 0);
		HEX2        : OUT   std_logic_vector(6 DOWNTO 0);
		HEX3        : OUT   std_logic_vector(6 DOWNTO 0);
        LEDG        : OUT   std_logic_vector(7 DOWNTO 0);
        LEDR        : OUT   std_logic_vector(7 DOWNTO 0);
        VGA_BLANK_N : OUT std_logic;
        VGA_SYNC_N  : OUT std_logic;
        VGA_R       : OUT std_logic_vector(7 downto 0);
        VGA_G       : OUT std_logic_vector(7 downto 0);
        VGA_B       : OUT std_logic_vector(7 downto 0);
        VGA_HS      : OUT std_logic;
        VGA_VS      : OUT std_logic);

END sisa;

ARCHITECTURE Structure OF sisa IS

	COMPONENT proc IS
		PORT (
			clk       : IN  std_logic;
			boot      : IN  std_logic;
			datard_m  : IN  std_logic_vector(15 DOWNTO 0);
			addr_m    : OUT std_logic_vector(15 DOWNTO 0);
			data_wr   : OUT std_logic_vector(15 DOWNTO 0);
			wr_m      : OUT std_logic;
			word_byte : OUT std_logic;
            dbg_pc    : OUT std_logic_vector(15 DOWNTO 0);
            addr_io   : OUT STD_LOGIC_VECTOR(7  DOWNTO 0);
            rd_io     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            wr_out    : OUT STD_LOGIC;
            rd_in     : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT MemoryController IS
		PORT (
			CLOCK_50  : IN    std_logic;
			addr      : IN    std_logic_vector(15 DOWNTO 0);
			wr_data   : IN    std_logic_vector(15 DOWNTO 0);
			rd_data   : OUT   std_logic_vector(15 DOWNTO 0);
			we        : IN    std_logic;
			byte_m    : IN    std_logic;
			-- señales para la placa de desarrollo
			SRAM_ADDR : OUT   std_logic_vector(17 DOWNTO 0);
			SRAM_DQ   : INOUT std_logic_vector(15 DOWNTO 0);
			SRAM_UB_N : OUT   std_logic;
			SRAM_LB_N : OUT   std_logic;
			SRAM_CE_N : OUT   std_logic := '1';
			SRAM_OE_N : OUT   std_logic := '1';
			SRAM_WE_N : OUT   std_logic := '1';
            -- senales sobre el vga_controller
            vga_addr    : out std_logic_vector(12 downto 0);
            vga_we      : out std_logic;
            vga_wr_data : out std_logic_vector(15 downto 0);
            vga_rd_data : in std_logic_vector(15 downto 0);
            vga_byte_m  : out std_logic);
	END COMPONENT;

    COMPONENT controladores_IO IS
        PORT (
            boot       : IN  STD_LOGIC;
            CLOCK_50   : IN  STD_LOGIC;
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
            led_rojos  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;

	COMPONENT driver7Segmentos IS
		PORT (
            data            : IN  std_logic_vector(15 DOWNTO 0);
            hex0_on         : IN std_logic;
            hex1_on         : IN std_logic;
            hex2_on         : IN std_logic;
            hex3_on         : IN std_logic;
            hex0            : OUT std_logic_vector(6 DOWNTO 0);
            hex1            : OUT std_logic_vector(6 DOWNTO 0);
            hex2            : OUT std_logic_vector(6 DOWNTO 0);
            hex3            : OUT std_logic_vector(6 DOWNTO 0));
	END COMPONENT;

    COMPONENT debugger IS
        PORT (
            i_dbg      : IN t_dbg;
            i_selector : IN std_logic_vector(1 downto 0);
            o_data     : OUT std_logic_vector(15 downto 0));
    END COMPONENT;

    COMPONENT vga_controller is
        PORT (
            clk_50mhz           : in  std_logic; -- system clock signal
            reset               : in  std_logic; -- system reset
            blank_out           : out std_logic; -- vga control signal
            csync_out           : out std_logic; -- vga control signal
            red_out             : out std_logic_vector(7 downto 0); -- vga red pixel value
            green_out           : out std_logic_vector(7 downto 0); -- vga green pixel value
            blue_out            : out std_logic_vector(7 downto 0); -- vga blue pixel value
            horiz_sync_out      : out std_logic; -- vga control signal
            vert_sync_out       : out std_logic; -- vga control signal
             --
            addr_vga            : in std_logic_vector(12 downto 0);
            we                  : in std_logic;
            wr_data             : in std_logic_vector(15 downto 0);
            rd_data             : out std_logic_vector(15 downto 0);
            byte_m              : in std_logic;
            vga_cursor          : in std_logic_vector(15 downto 0);  -- simplemente lo ignoramos, este controlador no lo tiene implementado
            vga_cursor_enable   : in std_logic);                     -- simplemente lo ignoramos, este controlador no lo tiene implementado
    END COMPONENT;

	-- Senyals per conectar les dues entitats
	-- Que surten de PROC
	SIGNAL s_word_byte   : std_logic;
	SIGNAL s_wr_m        : std_logic;
	SIGNAL s_addr_m      : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_data_wr     : std_logic_vector(15 DOWNTO 0);
    SIGNAL s_addr_io     : std_logic_vector(7 DOWNTO 0);
    SIGNAL s_rd_io       : std_logic_vector(15 DOWNTO 0);
    SIGNAL s_wr_out      : std_logic;
    SIGNAL s_rd_in       : std_logic;
	-- Que surten de MEMCTRL
	SIGNAL s_rd_data     : std_logic_vector(15 DOWNTO 0);
    SIGNAL s_vga_wr_data : std_logic_vector(15 DOWNTO 0);
    SIGNAL s_vga_rd_data : std_logic_vector(15 DOWNTO 0);
    SIGNAL s_vga_addr    : std_logic_vector(12 DOWNTO 0);
    SIGNAL s_vga_we      : std_logic;
    SIGNAL s_vga_byte_m  : std_logic;

	-- Registre del divisor de rellotge
	SIGNAL s_reg_divisor : std_logic_vector(2 DOWNTO 0) := "000";

	-- Senyals de debug
	SIGNAL s_dbg_pc      : std_logic_vector(15 DOWNTO 0);

    -- Que surten del controlador_IO
    SIGNAL s_hex_on      : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_o_io_hex    : std_logic_vector(15 downto 0);

    SIGNAL s_dbg : t_dbg := c_DBG_INIT;
    SIGNAL s_o_debugger  : std_logic_vector(15 downto 0);

    SIGNAL s_hex_output  : std_logic_vector(15 downto 0);

    -- Selectors, i senyals de control
    SIGNAL s_boot        : std_logic;
    SIGNAL s_run_mode    : std_logic;

    -- Clocks
    signal s_clk_50      : std_logic;
    signal s_clk_6_25    : std_logic;
BEGIN

    s_boot <= SW(9);
    s_run_mode <= SW(8);

    WITH s_run_mode SELECT
        s_clk_50 <= KEY(0)   when RUN_MODE_DEBUG,
                    CLOCK_50 when RUN_MODE_NORMAL,
                    CLOCK_50 when others;

    s_clk_6_25 <= s_reg_divisor(2);

    s_dbg.pc <= s_dbg_pc;
    s_dbg.mem_addr <= s_addr_m;
    s_dbg.mem_data <= s_rd_data;

    WITH s_run_mode SELECT
        s_hex_output <= s_o_debugger when RUN_MODE_DEBUG,
                        s_o_io_hex   when RUN_MODE_NORMAL,
                        s_o_debugger when others;

	clk_divider : PROCESS (s_clk_50) IS
	BEGIN
		IF rising_edge(s_clk_50) THEN
			s_reg_divisor <= s_reg_divisor + 1;
		END IF;
	END PROCESS; -- clk_divider

    io: controladores_IO PORT MAP(
        -- inputs
        boot        => s_boot,
        CLOCK_50    => s_clk_50,
        addr_io     => s_addr_io, -- address
        wr_io       => s_data_wr, -- write data
        wr_out      => s_wr_out,  -- write eanble
        rd_in       => s_rd_in,   -- read enable
        SW          => SW(7 downto 0),  -- switches
        KEY         => KEY(3 downto 0),  -- keys
        -- outputs
        rd_io       => s_rd_io,   -- read data
        hex         => s_o_io_hex,
        hex_on      => s_hex_on, -- vector de cuales hex estan apagados
        led_verdes  => LEDG,
        led_rojos   => LEDR
    );


	proc0 : proc PORT MAP(
		-- inputs
		boot      => s_boot,
		clk       => s_clk_6_25,
		datard_m  => s_rd_data,
        rd_io     => s_rd_io,
		-- outputs
		word_byte => s_word_byte,
		wr_m      => s_wr_m,
		addr_m    => s_addr_m,
		data_wr   => s_data_wr,
		dbg_pc    => s_dbg_pc,
        addr_io   => s_addr_io,
        wr_out    => s_wr_out,
        rd_in     => s_rd_in
	);

	memctrl0 : MemoryController PORT MAP(
		CLOCK_50  => s_clk_50,
		addr      => s_addr_m,
		wr_data   => s_data_wr,
		rd_data   => s_rd_data,
		we        => s_wr_m,
		byte_m    => s_word_byte,
		-- señales para la placa de desarrollo
		SRAM_ADDR => SRAM_ADDR,
		SRAM_DQ   => SRAM_DQ,
		SRAM_UB_N => SRAM_UB_N,
		SRAM_LB_N => SRAM_LB_N,
		SRAM_CE_N => SRAM_CE_N,
		SRAM_OE_N => SRAM_OE_N,
		SRAM_WE_N => SRAM_WE_N,
        -- senales sobre el vga_controller
        vga_addr    => s_vga_addr,
        vga_we      => s_vga_we,
        vga_wr_data => s_vga_wr_data,
        vga_rd_data => s_vga_rd_data,
        vga_byte_m  => s_vga_byte_m
	);

    vga_ctrl: vga_controller PORT MAP (
        clk_50mhz           => s_clk_50,
        reset               => s_boot,
        blank_out           => VGA_BLANK_N,
        csync_out           => VGA_SYNC_N,
        red_out             => VGA_R,
        green_out           => VGA_G,
        blue_out            => VGA_B,
        horiz_sync_out      => VGA_HS,
        vert_sync_out       => VGA_VS,
         --
        addr_vga            => s_vga_addr,
        we                  => s_vga_we,
        wr_data             => s_vga_wr_data,
        rd_data             => s_vga_rd_data,
        byte_m              => s_vga_byte_m,
        vga_cursor          => x"0000",
        vga_cursor_enable   => '0'
    );

	driver7seg : driver7Segmentos PORT MAP(
		data        => s_hex_output,
        hex0        => HEX0,
        hex1        => HEX1,
        hex2        => HEX2,
        hex3        => HEX3,
        hex0_on     => s_hex_on(0),
        hex1_on     => s_hex_on(1),
        hex2_on     => s_hex_on(2),
        hex3_on     => s_hex_on(3)
	);

    debugger0: debugger PORT MAP(
        i_dbg => s_dbg,
        i_selector => SW(1 downto 0),
        o_data => s_o_debugger
    );

END Structure;

