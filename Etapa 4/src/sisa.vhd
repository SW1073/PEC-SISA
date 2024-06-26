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
		SW        : IN    std_logic_vector(9 DOWNTO 9);
		HEX0      : OUT   std_logic_vector(6 DOWNTO 0);
		HEX1      : OUT   std_logic_vector(6 DOWNTO 0);
		HEX2      : OUT   std_logic_vector(6 DOWNTO 0);
		HEX3      : OUT   std_logic_vector(6 DOWNTO 0));
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
			dbg_pc    : OUT std_logic_vector(15 DOWNTO 0));
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

	COMPONENT driver7Segmentos IS
		PORT (
			codigoCaracter : IN  std_logic_vector(3 DOWNTO 0);
			bitsCaracter   : OUT std_logic_vector(6 DOWNTO 0));
	END COMPONENT;

	-- Senyals per conectar les dues entitats
	-- Que surten de PROC
	SIGNAL s_word_byte   : std_logic;
	SIGNAL s_wr_m        : std_logic;
	SIGNAL s_addr_m      : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_data_wr     : std_logic_vector(15 DOWNTO 0);
	-- Que surten de MEMCTRL
	SIGNAL s_rd_data     : std_logic_vector(15 DOWNTO 0);

	-- Registre del divisor de rellotge
	SIGNAL s_reg_divisor : std_logic_vector(2 DOWNTO 0) := "000";

	-- Senyals de debug
	SIGNAL s_dbg_pc      : std_logic_vector(15 DOWNTO 0);
BEGIN

	clk_divider : PROCESS (CLOCK_50) IS
	BEGIN
		IF rising_edge(CLOCK_50) THEN
			s_reg_divisor <= s_reg_divisor + 1;
		END IF;
	END PROCESS; -- clk_divider

	proc0 : proc PORT MAP(
		-- inputs
		boot      => SW(9),
		clk       => s_reg_divisor(2),
		datard_m  => s_rd_data,
		-- outputs
		word_byte => s_word_byte,
		wr_m      => s_wr_m,
		addr_m    => s_addr_m,
		data_wr   => s_data_wr,
		dbg_pc    => s_dbg_pc
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

	driver3 : driver7Segmentos PORT MAP(
		codigoCaracter => s_dbg_pc(15 DOWNTO 12),
		bitsCaracter   => HEX3
	);

	driver2 : driver7Segmentos PORT MAP(
		codigoCaracter => s_dbg_pc(11 DOWNTO 8),
		bitsCaracter   => HEX2
	);

	driver1 : driver7Segmentos PORT MAP(
		codigoCaracter => s_dbg_pc(7 DOWNTO 4),
		bitsCaracter   => HEX1
	);

	driver0 : driver7Segmentos PORT MAP(
		codigoCaracter => s_dbg_pc(3 DOWNTO 0),
		bitsCaracter   => HEX0
	);

END Structure;

