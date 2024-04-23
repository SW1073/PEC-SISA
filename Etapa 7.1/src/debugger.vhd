LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.package_records.ALL;

ENTITY debugger IS
	PORT (
		i_dbg      : IN t_dbg;
        i_selector : IN std_logic_vector(1 downto 0);
		o_data     : OUT std_logic_vector(15 downto 0));
END debugger;

ARCHITECTURE Structure OF debugger IS
BEGIN

    WITH i_selector SELECT
        o_data <= i_dbg.pc       when "00",
                  i_dbg.ir       when "01",
                  i_dbg.mem_addr when "10",
                  i_dbg.mem_data when "11",
                  i_dbg.pc       when others;

END Structure;

