library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity test_illegal_ir is
    -- la entidad de test es una entidad vacía.
    -- no tiene señales que entren o salgan,
    -- solamente señales que se generan dentro
    -- para controlar el dut
end test_illegal_ir;

architecture comportament of test_illegal_ir is

    component illegal_ir is
        port (
            ir              : in  std_logic_vector(15 downto 0);
            is_illegal      : out std_logic
        );
    end component;

    signal clk          : std_logic                     := '0';
    signal s_ir         : std_logic_vector(15 downto 0) := x"0000";
    signal s_is_illegal : std_logic;
    signal s_finish     : std_logic                     := '0';

begin

    -- descripcio del comportament
    clk <= not clk after 10 ns;

    dut: illegal_ir port map (
        ir => s_ir,
        is_illegal => s_is_illegal
    );

    process (clk) is
    begin
        if rising_edge(clk) then
            if (s_ir < x"FFFF") then
                s_ir <= s_ir + 1;
                s_finish <= '0';
            else
                s_finish <= '1';
            end if;
        end if;
    end process;

end comportament;

