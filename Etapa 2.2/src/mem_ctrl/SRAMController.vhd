LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SRAMController IS
	PORT (
		clk : IN std_logic; -- Va a 50MHZ. Esto lo tenemos que aprovechar
		-- senales para la placa de desarrollo
		SRAM_ADDR : OUT   std_logic_vector(17 DOWNTO 0);
		SRAM_DQ   : INOUT std_logic_vector(15 DOWNTO 0);
		SRAM_UB_N : OUT   std_logic;
		SRAM_LB_N : OUT   std_logic;
		SRAM_CE_N : OUT   std_logic := '1';
		SRAM_OE_N : OUT   std_logic := '1';
		SRAM_WE_N : OUT   std_logic := '1';
		-- senales internas del procesador
		address     : IN  std_logic_vector(15 DOWNTO 0) := "0000000000000000";
		dataReaded  : OUT std_logic_vector(15 DOWNTO 0);
		dataToWrite : IN  std_logic_vector(15 DOWNTO 0);
		WR          : IN  std_logic;
		byte_m      : IN  std_logic := '0');
END SRAMController;

ARCHITECTURE comportament OF SRAMController IS

	TYPE State_t IS (READ, WRITE_SETUP, WRITE);
	SIGNAL s_state : State_t := READ;

BEGIN

	SRAM_ADDR  <= "000" & address(15 DOWNTO 1);
	SRAM_CE_N  <= '0';
	SRAM_OE_N  <= '0';
	dataReaded <= std_logic_vector(resize(signed(SRAM_DQ(7 DOWNTO 0)), dataReaded'length)) WHEN byte_m = '1' AND address(0) = '0'
		ELSE std_logic_vector(resize(signed(SRAM_DQ(15 DOWNTO 8)), dataReaded'length)) WHEN byte_m = '1' AND address(0) = '1'
		ELSE SRAM_DQ;
	next_state : PROCESS (clk) IS
		VARIABLE v_valid_counter : integer;
		VARIABLE v_state         : State_t;
	BEGIN
		IF rising_edge(clk) THEN
			v_state := s_state;
			CASE (s_state) IS
				WHEN READ =>
					IF WR = '1' THEN
						v_state := WRITE_SETUP;
					END IF;

				WHEN WRITE_SETUP =>
					v_state := WRITE;

				WHEN WRITE =>
					IF WR = '0' THEN
						v_state := READ;
					END IF;

			END CASE;
			s_state <= v_state;
		END IF;
	END PROCESS; -- next_state
	output_logic : PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			CASE (s_state) IS
				WHEN READ =>
					IF WR = '1' THEN
						IF byte_m = '0' AND address(0) = '0' THEN
							SRAM_UB_N <= '0';
							SRAM_LB_N <= '0';
							SRAM_DQ   <= dataToWrite;
						ELSIF byte_m = '0' AND address(0) = '1' THEN
							SRAM_UB_N <= 'W';
							SRAM_LB_N <= 'W';
							SRAM_DQ   <= dataToWrite;
						ELSIF byte_m = '1' AND address(0) = '0' THEN
							SRAM_UB_N <= '1';
							SRAM_LB_N <= '0';
							SRAM_DQ   <= dataToWrite;
						ELSE -- byte_m = '1' and address(0) = '1'
							SRAM_UB_N <= '0';
							SRAM_LB_N <= '1';
							SRAM_DQ   <= dataToWrite(7 DOWNTO 0) & x"00";
						END IF;
						SRAM_WE_N <= '0';
					ELSE
						SRAM_UB_N <= '0';
						SRAM_LB_N <= '0';
						SRAM_WE_N <= '1';
						SRAM_DQ   <= (OTHERS => 'Z');
					END IF;

				WHEN WRITE_SETUP =>
					SRAM_UB_N <= '1';
					SRAM_LB_N <= '1';
					SRAM_WE_N <= '1';

				WHEN WRITE =>
					IF WR = '0' THEN
						SRAM_UB_N <= '0';
						SRAM_LB_N <= '0';
						SRAM_WE_N <= '1';
						SRAM_DQ   <= (OTHERS => 'Z');
					END IF;

			END CASE;
		END IF;
	END PROCESS; -- output_logic

END comportament;

