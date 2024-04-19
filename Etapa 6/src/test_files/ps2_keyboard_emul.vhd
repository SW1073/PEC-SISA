library ieee;
use ieee.std_logic_1164.all;

entity ps2_keyboard_emul is
    port (
        ps2_data : out std_logic;
        ps2_clk  : in  std_logic
    );
end ps2_keyboard_emul;

architecture comportament of ps2_keyboard_emul is

    type sending_state_t is (
        IDLE,
        SENDING
    );

    signal s_seq_buff : std_logic_vector(21 downto 0);
    -- TODO: seq_buff_idx or smth like that

begin

    -- start bits
    s_seq_buff(21) <= '0';
    s_seq_buff(10) <= '0';

    -- make command
    s_seq_buff(20 downto 13) <= x"1C"; -- A make command

    process (ps2_clk) is
    begin
        if falling_edge(ps2_clk) then
        end if;
    end process;

end comportament;


