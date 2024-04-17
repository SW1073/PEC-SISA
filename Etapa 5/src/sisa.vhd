LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY sisa IS
	PORT (
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
        LEDR      : OUT   std_logic_vector(7 DOWNTO 0));
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
			SRAM_WE_N : OUT   std_logic := '1');
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
            hex_off    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            led_verdes : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            led_rojos  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;

	COMPONENT driver7Segmentos IS
		PORT (
            data            : IN  std_logic_vector(15 DOWNTO 0);
            hex0_off        : IN std_logic;
            hex1_off        : IN std_logic;
            hex2_off        : IN std_logic;
            hex3_off        : IN std_logic;
            hex0            : OUT std_logic_vector(6 DOWNTO 0);
            hex1            : OUT std_logic_vector(6 DOWNTO 0);
            hex2            : OUT std_logic_vector(6 DOWNTO 0);
            hex3            : OUT std_logic_vector(6 DOWNTO 0));
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

	-- Registre del divisor de rellotge
	SIGNAL s_reg_divisor : std_logic_vector(2 DOWNTO 0) := "000";

	-- Senyals de debug
	SIGNAL s_dbg_pc      : std_logic_vector(15 DOWNTO 0);

    -- Que surten del controlador_IO
    SIGNAL s_hex_off     : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_hex         : std_logic_vector(15 DOWNTO 0);
BEGIN

	clk_divider : PROCESS (CLOCK_50) IS
	BEGIN
		IF rising_edge(CLOCK_50) THEN
			s_reg_divisor <= s_reg_divisor + 1;
		END IF;
	END PROCESS; -- clk_divider

    io: controladores_IO PORT MAP(
        -- inputs
        boot        => SW(9),
        CLOCK_50    => CLOCK_50,
        addr_io     => s_addr_io, -- address
        wr_io       => s_data_wr, -- write data
        wr_out      => s_wr_out,  -- write eanble
        rd_in       => s_rd_in,   -- read enable
        SW          => SW(7 downto 0),  -- switches
        KEY         => KEY(3 downto 0),  -- keys
        -- outputs
        rd_io       => s_rd_io,   -- read data
        hex         => s_hex,
        hex_off     => s_hex_off, -- vector de cuales hex estan apagados
        led_verdes  => LEDG,
        led_rojos   => LEDR
    );


	proc0 : proc PORT MAP(
		-- inputs
		boot      => SW(9),
		clk       => s_reg_divisor(2),
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
		CLOCK_50  => CLOCK_50,
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
		SRAM_WE_N => SRAM_WE_N
	);

	driver7seg : driver7Segmentos PORT MAP(
		data        => s_dbg_pc(15 DOWNTO 0),
        hex0        => HEX0,
        hex1        => HEX1,
        hex2        => HEX2,
        hex3        => HEX3,
        hex0_off    => s_hex_off(0),
        hex1_off    => s_hex_off(1),
        hex2_off    => s_hex_off(2),
        hex3_off    => s_hex_off(3)
	);

END Structure;

