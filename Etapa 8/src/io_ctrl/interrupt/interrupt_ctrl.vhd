LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_io.ALL;

ENTITY interrupt_ctrl IS
    PORT (
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

    SIGNAL current_iid : std_logic_vector(1 DOWNTO 0) := "00";

BEGIN

    PROCESS (inta) IS
    BEGIN
        -- FIXME: treure aixo si dones problemes inta.
        -- Actualitzar una senyal i mostrejar-la per
        -- un altre cable pot crear glitches.
        -- Al MODELSIM, funciona amb i sense comprovació.
        IF rising_edge(inta) THEN
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

    -- Mantenir la senyal intr alta entre interrupcio i interrupcio
    -- no afecta en res el funcionament. Si de cas, el simplifica.
    intr <= timer_intr or key_intr or switch_intr or ps2_intr;

    -- Nomes enviem inta a 1 dels 4 moduls d'interrupcions cada cop.
    timer_inta  <= inta WHEN current_iid = "00" ELSE '0';
    key_inta    <= inta WHEN current_iid = "01" ELSE '0';
    switch_inta <= inta WHEN current_iid = "10" ELSE '0';
    ps2_inta    <= inta WHEN current_iid = "11" ELSE '0';

    iid <= current_iid;

END Structure;
