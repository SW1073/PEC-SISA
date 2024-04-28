LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_io.ALL;

ENTITY interrupt_ctrl IS
    PORT (
        clk         : IN std_logic;
        boot        : IN std_logic;
        inta        : IN std_logic;
        key_intr    : IN std_logic;
        ps2_intr    : IN std_logic;
        switch_intr : IN std_logic;
        timer_intr  : IN std_logic;
        --
        intr        : OUT std_logic;
        key_inta    : OUT std_logic;
        ps2_inta    : OUT std_logic;
        switch_inta : OUT std_logic;
        timer_inta  : OUT std_logic;
        iid         : OUT std_logic_vector(1 DOWNTO 0));
END interrupt_ctrl;

ARCHITECTURE Structure OF interrupt_ctrl IS

    SIGNAL current_iid : std_logic_vector(1 DOWNTO 0);

BEGIN

    PROCESS (clk) IS
    BEGIN

        IF rising_edge(clk) THEN

            IF timer_intr = '1' THEN
                current_iid <= "00";
            ELSIF key_intr = '1' THEN
                current_iid <= "01";
            ELSIF switch_intr = '1' THEN
                current_iid <= "10";
            ELSIF ps2_intr = '1' THEN
                current_iid <= "11";
            END IF;
        END IF;
    END PROCESS;

    with current_iid select
        intr    <=  timer_intr WHEN "00",
                    key_intr WHEN "01",
                    switch_intr WHEN "10",
                    ps2_intr WHEN OTHERS;

    timer_inta <= inta WHEN current_iid = "00" ELSE '0';
    key_inta   <= inta WHEN current_iid = "01" ELSE '0';
    switch_inta <= inta WHEN current_iid = "10" ELSE '0';
    ps2_inta   <= inta WHEN current_iid = "11" ELSE '0';

    iid <= current_iid;

END Structure;
