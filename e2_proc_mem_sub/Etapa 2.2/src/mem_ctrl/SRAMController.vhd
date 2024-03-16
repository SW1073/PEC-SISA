library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SRAMController is
    port (clk         : in    std_logic; -- Va a 50MHZ. Esto lo tenemos que aprovechar
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
          byte_m      : in    std_logic := '0');
end SRAMController;

architecture comportament of SRAMController is

    type State_t is (READ, WRITE_SETUP, WRITE);
    signal s_state: State_t := READ;

begin

	SRAM_ADDR <= "00" & address;
	SRAM_CE_N <= '0';
	SRAM_OE_N <= '0';
	dataReaded <= SRAM_DQ;


    next_state: process(clk) is
        variable v_valid_counter: integer;
        variable v_state: State_t;
    begin
        if rising_edge(clk) then
            v_state := s_state;
            case (s_state) is
                when READ =>
					if WR = '1' then
						v_state := WRITE_SETUP;
					end if;

				when WRITE_SETUP =>
					v_state := WRITE;

				when WRITE =>
					if WR = '0' then
						v_state := READ;
					end if;

            end case;
            s_state <= v_state;
        end if;
    end process; -- next_state


    output_logic: process(clk) is
    begin
        if rising_edge(clk) then
            case (s_state) is
                when READ =>
					if WR = '1' then
						SRAM_UB_N <= byte_m;
						SRAM_LB_N <= '0';
						SRAM_WE_N <= '0';
						SRAM_DQ <= dataToWrite;
					else
						SRAM_UB_N <= '0';
						SRAM_LB_N <= '0';
						SRAM_WE_N <= '1';
						SRAM_DQ <= (others => 'Z');
					end if;

				when WRITE_SETUP =>
					SRAM_WE_N <= '1';
					SRAM_LB_N <= '1';
					SRAM_UB_N <= '1';

				when WRITE =>
					if WR= '0' then
						SRAM_UB_N <= '0';
						SRAM_LB_N <= '0';
						SRAM_WE_N <= '1';
						SRAM_DQ <= (others => 'Z');
					end if;

            end case;
        end if;
    end process; -- output_logic

end comportament;
