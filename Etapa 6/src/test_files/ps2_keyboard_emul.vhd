library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity ps2_keyboard_emul is
    port (
        i_data_to_send  : in    std_logic_vector(7 downto 0);
        i_send          : in    std_logic;
        o_done          : out   std_logic;
        ps2_data        : inout std_logic;
        ps2_clk         : inout std_logic);
end ps2_keyboard_emul;

architecture comportament of ps2_keyboard_emul is

    type ps2_state_t is ( IDLE, START, DATA, PARITY, STOP );

    signal s_state : ps2_state_t := IDLE;
    signal s_idx : integer range 8 downto 0 := 8;
    signal s_internal_ps2_clk : std_logic := '0';

    signal s_ps2_data : std_logic := '1';

begin

    -- next state process
    next_state: process (s_internal_ps2_clk) is
        variable v_state : ps2_state_t;
    begin
        if falling_edge(s_internal_ps2_clk) then
            v_state := s_state;
            case (v_state) is
                when IDLE =>
                    if i_send = '1' then
                        v_state := START;
                    end if;

                when START => v_state := DATA;

                when DATA =>
                    if s_idx = 0 then
                        v_state := PARITY;
                    end if;

                when PARITY => v_state := STOP;

                when STOP => v_state := IDLE;
            end case;
            s_state <= v_state;
        end if;
    end process; -- next_state

    -- output logic process
    output_logic: process (ps2_clk) is
    begin
        if falling_edge(ps2_clk) then
            case (s_state) is
                when IDLE =>
                    s_ps2_data <= '1';

                when START =>
                    s_ps2_data <= '0';

                when DATA =>
                    if s_idx > 0 then
                        s_ps2_data <= i_data_to_send(s_idx-1);
                        s_idx <= s_idx - 1;
                    end if;

                when PARITY =>
                    s_ps2_data <= not xor_reduce(i_data_to_send);

                when STOP =>
                    s_ps2_data <= '1';
                    s_idx <= 8;
            end case;
        end if;
    end process; -- output_logic

    s_internal_ps2_clk <= not s_internal_ps2_clk after 50 ns;

    -- done flag output
    with s_state select
        o_done <= '1' when IDLE,
                  '0' when others;

    -- Select which clock is running
    ps2_clk <= '1' when s_state = IDLE else s_internal_ps2_clk;

    ps2_data <= s_ps2_data;

end comportament;

