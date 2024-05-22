LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_io.ALL;

ENTITY timer_int_ctrl IS
    PORT (
        clk         : IN std_logic;
        boot        : IN std_logic;
        inta        : IN std_logic;
        --
        intr        : OUT std_logic);
END timer_int_ctrl;

ARCHITECTURE Structure OF timer_int_ctrl IS

    SIGNAL sending_intr : std_logic;

    -- 0.05 s. a 50MHz (20 ns) = 25 x10^5 clock events
    CONSTANT counter_objective : integer := 2500000;
    SIGNAL counter : integer range 0 to counter_objective := 0;
    SIGNAL s_prev_inta : std_logic := '0';
BEGIN

    reloj: PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF boot = '1' THEN
                counter <= 0;
            ELSE
                IF counter < counter_objective THEN
                    counter <= counter + 1;
                ELSE
                    -- HAN PASADO 0.05 SEGUNDOS
                    counter <= 0;
                END IF;
            END IF;
        END IF;
    END PROCESS; -- reloj

    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF boot = '1' THEN
                sending_intr <= '0';
            ELSE
                IF sending_intr = '0' and counter = counter_objective THEN
                    sending_intr <= '1';
                ELSIF sending_intr = '1' AND (s_prev_inta = '0' AND inta = '1') THEN
                    sending_intr <= '0';
                END IF;
            END IF;
            s_prev_inta <= inta;
        END IF;
    END PROCESS;

    intr <= sending_intr;

END Structure;
