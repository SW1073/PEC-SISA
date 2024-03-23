LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY sisa IS
    PORT (CLOCK_50  : IN    STD_LOGIC;
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
          SW        : in std_logic_vector(9 downto 9);
		  HEX0		: out STD_LOGIC_VECTOR(6 DOWNTO 0);
		  HEX1		: out STD_LOGIC_VECTOR(6 DOWNTO 0);
		  HEX2		: out STD_LOGIC_VECTOR(6 DOWNTO 0);
		  HEX3		: out STD_LOGIC_VECTOR(6 DOWNTO 0));
END sisa;

ARCHITECTURE Structure OF sisa IS

	COMPONENT proc IS
		PORT (clk			: IN STD_LOGIC;
				boot			: IN STD_LOGIC;
				datard_m		: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				addr_m		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				data_wr		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				wr_m			: OUT STD_LOGIC;
				word_byte	: OUT STD_LOGIC;
				dbg_pc		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT MemoryController is
		port (CLOCK_50  : in  std_logic;
				addr      : in  std_logic_vector(15 downto 0);
				wr_data   : in  std_logic_vector(15 downto 0);
				rd_data   : out std_logic_vector(15 downto 0);
				we        : in  std_logic;
				byte_m    : in  std_logic;
				-- señales para la placa de desarrollo
				SRAM_ADDR : out   std_logic_vector(17 downto 0);
				SRAM_DQ   : inout std_logic_vector(15 downto 0);
				SRAM_UB_N : out   std_logic;
				SRAM_LB_N : out   std_logic;
				SRAM_CE_N : out   std_logic := '1';
				SRAM_OE_N : out   std_logic := '1';
				SRAM_WE_N : out   std_logic := '1');
	end COMPONENT;

	COMPONENT driver7Segmentos IS
		PORT( codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT;
	
	-- Senyals per conectar les dues entitats
	-- Que surten de PROC
	signal s_word_byte: std_logic;
	signal s_wr_m: std_logic;
	signal s_addr_m: std_logic_vector(15 downto 0);
	signal s_data_wr: std_logic_vector(15 downto 0);
	-- Que surten de MEMCTRL
	signal s_rd_data: std_logic_vector(15 downto 0);
	
	-- Registre del divisor de rellotge
	signal s_reg_divisor: std_logic_vector(2 downto 0) := "000";

	-- Senyals de debug
	signal s_dbg_pc: std_logic_vector(15 downto 0);
BEGIN
	
	clk_divider: process(CLOCK_50) is
	begin
		if rising_edge(CLOCK_50) then
			s_reg_divisor <= s_reg_divisor + 1;
		end if;
	end process; -- clk_divider

	proc0: proc port map(
		-- inputs
		boot			=> SW(9),
		clk 			=> s_reg_divisor(2),
		datard_m		=> s_rd_data,
		-- outputs
		word_byte	=> s_word_byte,
		wr_m			=> s_wr_m,
		addr_m		=> s_addr_m,
		data_wr		=> s_data_wr,
		dbg_pc => s_dbg_pc
	);

	memctrl0: MemoryController port map(
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

	driver3: driver7Segmentos port map(
			codigoCaracter => s_dbg_pc(15 downto 12),
			bitsCaracter => HEX3
	);

	driver2: driver7Segmentos port map(
			codigoCaracter => s_dbg_pc(11 downto 8),
			bitsCaracter => HEX2
	);
	
	driver1: driver7Segmentos port map(
			codigoCaracter => s_dbg_pc(7 downto 4),
			bitsCaracter => HEX1
	);

	driver0: driver7Segmentos port map(
			codigoCaracter => s_dbg_pc(3 downto 0),
			bitsCaracter => HEX0
	);

END Structure;