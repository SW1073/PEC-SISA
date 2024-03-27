LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE work.package_alu.all;

ENTITY alu IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  f  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          z  : OUT STD_LOGIC);
END alu;


ARCHITECTURE Structure OF alu IS

	COMPONENT alu_arit_log IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT; -- op_arit_log

	COMPONENT alu_comp IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT; -- op_comp

	COMPONENT alu_ext_arit IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT; -- op_ext_arit

	COMPONENT alu_misc IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT; -- op_misc

	signal s_w_arit_log: std_logic_vector(15 downto 0);
	signal s_w_comp: std_logic_vector(15 downto 0);
	signal s_w_ext_arit: std_logic_vector(15 downto 0);
	signal s_w_immed: std_logic_vector(15 downto 0);
	signal s_w_movs: std_logic_vector(15 downto 0);

    signal s_immed_ext: std_logic_vector(15 downto 0);
    signal s_y_arit_log: std_logic_vector(15 downto 0);
    signal s_f_arit_log: std_logic_vector(2 downto 0);

BEGIN

    -- Check if y is 0
    z <= '1' when y = x"0000" else '0';

    -- extend immediate value
    s_y_arit_log <= std_logic_vector(resize(signed(y(7 downto 0)), s_y_arit_log'length)) when op = OP_IMMED else y;
    s_f_arit_log <= F_ARIT_LOG_ADD when op = OP_IMMED else f;

	arit_log: alu_arit_log port map (
		x => x,
        y => s_y_arit_log,
        op => s_f_arit_log,
		w => s_w_arit_log
	);

	comp: alu_comp port map (
		x => x,
		y => y,
		op => f,
		w => s_w_comp
	);

	ext_arit: alu_ext_arit port map (
		x => x,
		y => y,
		op => f,
		w => s_w_ext_arit
	);

	movs: alu_misc port map (
		x => x,
		y => y,
		op => f,
		w => s_w_movs
	);

	with op select w <=
		s_w_arit_log        when OP_ARIT_LOG,
		s_w_arit_log        when OP_IMMED,
		s_w_comp            when OP_CMPS,
		s_w_ext_arit        when OP_EXT_ARIT,
		s_w_movs            when OP_MOVS,
		s_w_arit_log        when others;

END Structure;
