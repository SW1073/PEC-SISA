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

    type ps2_state_t is ( IDLE, SENDING );

    signal s_state : ps2_state_t := IDLE;
    signal s_seq_buff : std_logic_vector(10 downto 0); -- 11 bits

    signal s_idx : integer range 10 downto 0 := 10;
    signal s_internal_ps2_clk : std_logic := '0';

    signal s_falling_edge_counter : integer := 0;

begin

    -- Clock de 10 Mhz lol
    s_internal_ps2_clk <= not s_internal_ps2_clk after 50 ns;

    -- start bit
    s_seq_buff(10) <= '0';
    -- make command
    s_seq_buff(9 downto 2) <= i_data_to_send;
    -- parity bit
    s_seq_buff(1) <= not xor_reduce(i_data_to_send);
    -- stop bit
    s_seq_buff(0) <= '1';

    -- next state process
    next_state: process (i_send, s_idx) is
        variable v_state : ps2_state_t;
    begin
        v_state := s_state;
        case (v_state) is
            when IDLE =>
                if rising_edge(i_send) then
                    v_state := SENDING;
                end if;
            when SENDING =>
                if s_idx+1 = 0 then
                    v_state := IDLE;
                end if;
        end case;
        s_state <= v_state;
    end process; -- next_state

    -- output logic process
    output_logic: process (ps2_clk) is
    begin
        if falling_edge(ps2_clk) then
            s_falling_edge_counter <= s_falling_edge_counter + 1;
            case (s_state) is
                when IDLE =>
                    if i_send = '1' then
                        s_idx <= s_idx - 1;
                    end if;
                when SENDING =>
                    if s_idx > 0 then
                        s_idx <= s_idx - 1;
                    else
                        s_idx <= 10;
                    end if;
            end case;
        end if;
    end process; -- output_logic

    -- done flag output
    with s_state select
        o_done <= '1' when IDLE,
                  '0' when SENDING;

    -- Select which clock is running
    ps2_clk <= '1' when
                (s_state = IDLE and s_falling_edge_counter = 0) or
                (s_state = SENDING and s_falling_edge_counter > 11)
                else s_internal_ps2_clk;
    -- with s_state select
    --     ps2_clk <= '1'                  when IDLE,
    --                 s_internal_ps2_clk  when SENDING;


    -- Select what data is on the bus
    with s_state select
        ps2_data <= '1'                 when IDLE,
                     s_seq_buff(s_idx)  when SENDING;

end comportament;

