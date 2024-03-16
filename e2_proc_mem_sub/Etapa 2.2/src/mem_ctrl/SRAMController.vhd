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

    type State_t is (IDLE); -- TODO: Añadir más estados
    signal s_state: State_t := IDLE;
begin
-- Así pues, las entradas de la SRAMController son:
--   - clk: La señal de reloj.
--   - address: Es la dirección de memoria a la que el procesador SISA desea acceder (de 16 bits).
--   - dataToWrite: Es el valor procedente del procesador que se escribirá en la memoria en el caso de hacer un store.
--   - WR: Señal que le indica a la memoria si debe leer o escribir un valor.
--   - byte_m: Señal que le indica a la memoria si ha de realizar un acceso a un word o debe realizar un acceso a un byte y extenderlo de signo.

-- Las salidas de la SRAMController son:
--   - SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N y SRAM_WE_N: Son las señales de control de la memoria descritas en el datasheet del fabricante.
--   - SRAM_ADDR: Es el bus de direcciones correspondiente al chip de memoria. Su valor depende de donde hayamos mapeado los 64KB de memoria del
--     procesador SISA. Su ancho depende del modelo de placa de desarrollo que estemos usando.
--   - dataReaded: Es el valor que se ha leído de la memoria. En caso de que se hubiese leído un byte se habría extendido el signo.

-- El bus SRAM_DQ es un bus bidireccional (de entrada y salida) de la SRAMController por el que van los datos hacia y
-- desde el chip de memoria. Al ser un bus bidireccional implica que diversos componentes pondrán datos en él en distintos
-- momentos. Hemos de garantizar en el diseño que dos componentes nunca pongan un valor en el bus de forma simultánea.
-- Por ello, cuando un componente no desee escribir en el bus deberá poner sus salidas en alta impedancia (High-Z)


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
                when IDLE =>
                    v_state := IDLE;
            end case;
            s_state <= v_state;
        end if;
    end process; -- next_state

    output_logic: process(clk) is
    begin
        if rising_edge(clk) then
            case (s_state) is
                when IDLE =>
                    SRAM_UB_N <= '0';
                    SRAM_LB_N <= '0';
                    SRAM_WE_N <= '1';
					SRAM_DQ <= (others => 'Z');
                    -- if next state is gona be READ, hacer las cosaas de read
                    -- COMO EN MP XD
            end case;
        end if;
    end process; -- output_logic

end comportament;
