LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MemoryController IS
	PORT (
		CLOCK_50  : IN    std_logic;
		addr      : IN    std_logic_vector(15 DOWNTO 0);
		wr_data   : IN    std_logic_vector(15 DOWNTO 0);
		rd_data   : OUT   std_logic_vector(15 DOWNTO 0);
		we        : IN    std_logic;
		byte_m    : IN    std_logic;
		-- se�ales para la placa de desarrollo
		SRAM_ADDR : OUT   std_logic_vector(17 DOWNTO 0);
		SRAM_DQ   : INOUT std_logic_vector(15 DOWNTO 0);
		SRAM_UB_N : OUT   std_logic;
		SRAM_LB_N : OUT   std_logic;
		SRAM_CE_N : OUT   std_logic := '1';
		SRAM_OE_N : OUT   std_logic := '1';
		SRAM_WE_N : OUT   std_logic := '1');
END MemoryController;

ARCHITECTURE comportament OF MemoryController IS
	COMPONENT SRAMController IS
		PORT (
			clk         : IN    std_logic;
			-- se�ales para la placa de desarrollo
			SRAM_ADDR   : OUT   std_logic_vector(17 DOWNTO 0);
			SRAM_DQ     : INOUT std_logic_vector(15 DOWNTO 0);
			SRAM_UB_N   : OUT   std_logic;
			SRAM_LB_N   : OUT   std_logic;
			SRAM_CE_N   : OUT   std_logic                    := '1';
			SRAM_OE_N   : OUT   std_logic                    := '1';
			SRAM_WE_N   : OUT   std_logic                    := '1';
			-- se�ales internas del procesador
			address     : IN    std_logic_vector(15 DOWNTO 0) := "0000000000000000";
			dataReaded  : OUT   std_logic_vector(15 DOWNTO 0);
			dataToWrite : IN    std_logic_vector(15 DOWNTO 0);
			WR          : IN    std_logic;
			byte_m      : IN    std_logic := '0');
	END COMPONENT;
	SIGNAL s_sram_data_readed : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_sram_wr          : std_logic;
BEGIN
	-- Por ahora, toda lectura es siempre de la SRAM, per en un futuro aquí habrá que multiplexar
	rd_data   <= s_sram_data_readed;
	s_sram_wr <= we WHEN (addr < x"C000") ELSE '0';

	sramctrl0 : SRAMController PORT MAP(
		clk         => CLOCK_50,
		-- se�ales para la placa de desarrollo
		SRAM_ADDR   => SRAM_ADDR,
		SRAM_DQ     => SRAM_DQ,
		SRAM_UB_N   => SRAM_UB_N,
		SRAM_LB_N   => SRAM_LB_N,
		SRAM_CE_N   => SRAM_CE_N,
		SRAM_OE_N   => SRAM_OE_N,
		SRAM_WE_N   => SRAM_WE_N,
		-- se�ales internas del procesador
		address     => addr,
		dataReaded  => s_sram_data_readed,
		dataToWrite => wr_data,
		WR          => s_sram_wr,
		byte_m      => byte_m
	);

END comportament;

