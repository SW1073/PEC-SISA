LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
USE ieee.std_logic_unsigned.ALL; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE work.package_io.ALL;

ENTITY controladores_IO IS
    PORT (
        boot       : IN  STD_LOGIC;
        CLOCK_50   : IN  STD_LOGIC;
        addr_io    : IN  STD_LOGIC_VECTOR(7  DOWNTO 0);
        wr_io      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        rd_io      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        wr_out     : IN  STD_LOGIC;
        rd_in      : IN  STD_LOGIC;
        SW         : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        KEY        : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        hex        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        hex_off    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        led_verdes : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        led_rojos  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        ps2_clk    : inout STD_LOGIC;
        ps2_data   : inout STD_LOGIC);
END controladores_IO;

ARCHITECTURE Structure OF controladores_IO IS

    COMPONENT keyboard_controller is
        Port (clk        : in    STD_LOGIC;
              reset      : in    STD_LOGIC;
              ps2_clk    : inout STD_LOGIC;
              ps2_data   : inout STD_LOGIC;
              read_char  : out   STD_LOGIC_VECTOR (7 downto 0);
              clear_char : in    STD_LOGIC;
              data_ready : out   STD_LOGIC);
    end COMPONENT;

    TYPE Mat IS ARRAY (255 DOWNTO 0) OF std_logic_vector(15 DOWNTO 0);
    SIGNAL registers : Mat := (OTHERS => (OTHERS => '0'));

    SIGNAL s_ps2_ascii_code : std_logic_vector(7 downto 0);
    SIGNAL s_ps2_clear_char : std_logic;
    SIGNAL s_ps2_data_ready : std_logic;
BEGIN

    PROCESS (CLOCK_50) IS
    BEGIN
        IF rising_edge(CLOCK_50) THEN
            registers(PORT_KEY)(3 downto 0) <= KEY(3 DOWNTO 0);
            registers(PORT_SW)(7 downto 0) <= SW(7 DOWNTO 0);

            IF wr_out = '1' AND addr_io /= PORT_KEY AND addr_io /= PORT_SW THEN
                registers(conv_integer(addr_io)) <= wr_io;
            END IF;

            IF s_ps2_data_ready = '1' THEN
                registers(PORT_PS2_DATA)(7 downto 0) <= s_ps2_ascii_code;
                registers(PORT_PS2_DATA_VALID)(0) <= '1';
                s_ps2_clear_char <= '1';
            ELSE
                s_ps2_clear_char <= '0';
            END IF;
        END IF;
    END PROCESS;

    -- Read con enable
    rd_io <= registers(conv_integer(addr_io)) WHEN rd_in = '1' ELSE x"0000";

    hex <= registers(PORT_HEX)(15 downto 0);
    hex_off <= registers(PORT_HEX_OFF)(3 downto 0);
    led_verdes <= registers(PORT_GREEN_LEDS)(7 downto 0);
    led_rojos <= registers(PORT_RED_LEDS)(7 downto 0);



    keyboard_controller0: keyboard_controller PORT MAP(
        clk         => CLOCK_50,
        reset       => boot,
        ps2_clk     => ps2_clk,
        ps2_data    => ps2_data,
        read_char   => s_ps2_ascii_code,
        clear_char  => s_ps2_clear_char,
        data_ready  => s_ps2_data_ready
    );

END Structure;
