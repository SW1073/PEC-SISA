LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_io.ALL;

ENTITY key_sw_int_ctrl IS
    GENERIC (
        n_bits : INTEGER);
    PORT (
        clk         : IN std_logic;
        boot        : IN std_logic;
        inta        : IN std_logic;
        data        : IN std_logic_vector(n_bits-1 DOWNTO 0);
        --
        intr        : OUT std_logic;
        read_data   : OUT std_logic_vector(n_bits-1 DOWNTO 0));
END key_sw_int_ctrl;

ARCHITECTURE Structure OF key_sw_int_ctrl IS

    SIGNAL sending_intr : std_logic;
    SIGNAL current_data : std_logic_vector(n_bits-1 DOWNTO 0);

    SIGNAL changed : boolean;
BEGIN

    changed <= current_data /= data;

    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN

            IF boot = '1' THEN
                current_data <= data;
                sending_intr <= '0';
            ELSE

                IF changed AND sending_intr = '0' THEN
                    sending_intr <= '1';
                    current_data <= data;
                ELSIF sending_intr = '1' AND inta = '1' THEN
                    sending_intr <= '0';
                END IF;

            END IF;
        END IF;
    END PROCESS;

    intr <= sending_intr;
    read_data <= current_data;

END Structure;
