library ieee;
use ieee.std_logic_1164.all;

package package_records is

    CONSTANT RUN_MODE_NORMAL : std_logic := '0';
    CONSTANT RUN_MODE_DEBUG  : std_logic := '1';

    type t_dbg is record
        pc       : std_logic_vector(15 downto 0);
        ir       : std_logic_vector(15 downto 0);
        mem_addr : std_logic_vector(15 downto 0);
        mem_data : std_logic_vector(15 downto 0);
    end record t_dbg;

    constant c_DBG_INIT : t_dbg := (
        pc       => (others => '0'),
        ir       => (others => '0'),
        mem_addr => (others => '0'),
        mem_data => (others => '0')
    );

end package_records;
