library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MemoryController is
    port (CLOCK_50   : in  std_logic;
	      addr       : in  std_logic_vector(15 downto 0);
          wr_data    : in  std_logic_vector(15 downto 0);
          rd_data    : out std_logic_vector(15 downto 0);
          we         : in  std_logic;
          byte_m     : in  std_logic;
          bad_allignment : out std_logic;
          -- se�ales para la placa de desarrollo
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
            -- senales sobre el vga_controller
            vga_addr    : out std_logic_vector(12 downto 0);
            vga_we      : out std_logic;
            vga_wr_data : out std_logic_vector(15 downto 0);
            vga_rd_data : in std_logic_vector(15 downto 0);
            vga_byte_m  : out std_logic);
end MemoryController;

architecture comportament of MemoryController is
    COMPONENT SRAMController is
        port (clk         : in    std_logic;
            -- senales para la placa de desarrollo
            SRAM_ADDR   : out   std_logic_vector(17 downto 0);
            SRAM_DQ     : inout std_logic_vector(15 downto 0);
            SRAM_UB_N   : out   std_logic;
            SRAM_LB_N   : out   std_logic;
            SRAM_CE_N   : out   std_logic := '1';
            SRAM_OE_N   : out   std_logic := '1';
            SRAM_WE_N   : out   std_logic := '1';
            -- senales internas del procesador
            address     : in    std_logic_vector(15 downto 0) := "0000000000000000";
            dataReaded  : out   std_logic_vector(15 downto 0);
            dataToWrite : in    std_logic_vector(15 downto 0);
            WR          : in    std_logic;
            byte_m      : in    std_logic := '0';
            bad_allignment : in std_logic);
    end COMPONENT;


    signal s_sram_data_readed: std_logic_vector(15 downto 0);
    signal s_sram_wr: std_logic;
    signal s_sram_we: std_logic;

    signal s_proc_addr_menos_vga_base_addr : std_logic_vector(15 downto 0);
    signal s_is_vga_access : std_logic;

    signal s_bad_allignment : std_logic;
begin
    s_is_vga_access <= '1' WHEN (addr >= x"A000") AND (addr <= x"BFFF") ELSE '0';
    s_proc_addr_menos_vga_base_addr <= addr - x"A000";

    s_bad_allignment <= '1' WHEN byte_m = '0' AND addr(0) = '1'
                        ELSE '0';

    s_sram_we <= '0' WHEN s_is_vga_access = '1' ELSE we;

    -- Por ahora, toda lectura es siempre de la SRAM, per en un futuro aquí habrá que multiplexar
    rd_data     <= s_sram_data_readed when s_is_vga_access = '0' else vga_rd_data;
    s_sram_wr   <= s_sram_we when (addr < x"C000") else '0';

    sramctrl0: SRAMController port map(
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
        byte_m      => byte_m,
        bad_allignment => s_bad_allignment
    );

    vga_addr    <= s_proc_addr_menos_vga_base_addr(12 downto 0) WHEN s_is_vga_access = '1' ELSE (others => '0');
    vga_we      <= we AND s_is_vga_access;
    vga_wr_data <= wr_data;
    vga_byte_m  <= byte_m;
    bad_allignment <= s_bad_allignment;

end comportament;
