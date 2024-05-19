LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_alu.ALL;

ENTITY alu IS
	PORT (
		x  : IN  std_logic_vector(15 DOWNTO 0);
		y  : IN  std_logic_vector(15 DOWNTO 0);
		op : IN  std_logic_vector(2 DOWNTO 0);
		f  : IN  std_logic_vector(2 DOWNTO 0);
		w  : OUT std_logic_vector(15 DOWNTO 0);
		z  : OUT std_logic);
END alu;
ARCHITECTURE Structure OF alu IS

	COMPONENT alu_arit_log IS
		PORT (
			x  : IN  std_logic_vector(15 DOWNTO 0);
			y  : IN  std_logic_vector(15 DOWNTO 0);
			op : IN  std_logic_vector(2 DOWNTO 0);
			w  : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT; -- op_arit_log

	COMPONENT alu_comp IS
		PORT (
			x  : IN  std_logic_vector(15 DOWNTO 0);
			y  : IN  std_logic_vector(15 DOWNTO 0);
			op : IN  std_logic_vector(2 DOWNTO 0);
			w  : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT; -- op_comp

	COMPONENT alu_ext_arit IS
		PORT (
			x  : IN  std_logic_vector(15 DOWNTO 0);
			y  : IN  std_logic_vector(15 DOWNTO 0);
			op : IN  std_logic_vector(2 DOWNTO 0);
			w  : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT; -- op_ext_arit

	COMPONENT alu_misc IS
		PORT (
			x  : IN  std_logic_vector(15 DOWNTO 0);
			y  : IN  std_logic_vector(15 DOWNTO 0);
			op : IN  std_logic_vector(2 DOWNTO 0);
			w  : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT; -- op_misc

	SIGNAL s_w_arit_log : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_w_comp     : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_w_ext_arit : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_w_immed    : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_w_misc     : std_logic_vector(15 DOWNTO 0);

	SIGNAL s_immed_ext  : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_y_arit_log : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_f_arit_log : std_logic_vector(2 DOWNTO 0);

BEGIN

	-- Check if y is 0
	z <= '1' WHEN y = x"0000" ELSE '0';

	-- extend immediate value
	s_y_arit_log <= std_logic_vector(resize(signed(y(7 DOWNTO 0)), s_y_arit_log'length)) WHEN op = OP_IMMED ELSE y;
	s_f_arit_log <= F_ARIT_LOG_ADD WHEN op = OP_IMMED ELSE f;

	arit_log : alu_arit_log PORT MAP(
		x  => x,
		y  => s_y_arit_log,
		op => s_f_arit_log,
		w  => s_w_arit_log
	);

	comp : alu_comp PORT MAP(
		x  => x,
		y  => y,
		op => f,
		w  => s_w_comp
	);

	ext_arit : alu_ext_arit PORT MAP(
		x  => x,
		y  => y,
		op => f,
		w  => s_w_ext_arit
	);

	misc : alu_misc PORT MAP(
		x  => x,
		y  => y,
		op => f,
		w  => s_w_misc
	);

	WITH op SELECT
        w <= s_w_arit_log WHEN OP_ARIT_LOG,
             s_w_arit_log WHEN OP_IMMED,
             s_w_comp     WHEN OP_CMPS,
             s_w_ext_arit WHEN OP_EXT_ARIT,
             s_w_misc     WHEN OP_MISC,
             s_w_arit_log WHEN OTHERS;

END Structure;

