LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY keyboard_int_ctrl IS
    PORT (
        CLOCK_50    : IN    std_logic;
        reset       : IN    std_logic;
        inta        : IN    std_logic;
        intr        : OUT    std_logic;
        ps2_clk     : INOUT std_logic;
        ps2_data    : INOUT std_logic;
        read_char   : OUT   std_logic_vector(7 DOWNTO 0);
        clear_char  : IN    std_logic;
        data_ready  : OUT   std_logic);
END keyboard_int_ctrl;

ARCHITECTURE BEHAVIORAL OF keyboard_int_ctrl IS

    COMPONENT keyboard_controller is
        Port (clk        : in    STD_LOGIC;
              reset      : in    STD_LOGIC;
              ps2_clk    : inout STD_LOGIC;
              ps2_data   : inout STD_LOGIC;
              read_char  : out   STD_LOGIC_VECTOR (7 downto 0);
              clear_char : in    STD_LOGIC;
              data_ready : out   STD_LOGIC);
    end COMPONENT;

    SIGNAL s_data_ready : std_logic;
    SIGNAL s_clear_char : std_logic;

BEGIN

    -- intr cuando presionan tecla
    -- inta cuando llega clear_char
    -- algo de ese palo

    keyboard_controller0: keyboard_controller PORT MAP(
        clk         => CLOCK_50,
        reset       => reset,
        ps2_clk     => ps2_clk,
        ps2_data    => ps2_data,
        read_char   => read_char,
        clear_char  => s_clear_char,
        data_ready  => s_data_ready
    );

    s_clear_char <= clear_char or inta;

    intr <= s_data_ready;
    data_ready <= s_data_ready;

END BEHAVIORAL;

