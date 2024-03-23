LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY alu IS
	PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
		  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu;


ARCHITECTURE Structure OF alu IS

	COMPONENT op_arit_log IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT; -- op_arit_log

	COMPONENT op_comp IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT; -- op_comp

	COMPONENT op_ext_arit IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT; -- op_ext_arit

	COMPONENT op_immed IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT; -- op_immed

	COMPONENT op_movs IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT; -- op_movs

	signal s_op: std_logic_vector(2 downto 0);
	signal s_sub_op: std_logic_vector(2 downto 0);

	signal s_w_arit_log: std_logic_vector(15 downto 0);
	signal s_w_comp: std_logic_vector(15 downto 0);
	signal s_w_ext_arit: std_logic_vector(15 downto 0);
	signal s_w_immed: std_logic_vector(15 downto 0);
	signal s_w_movs: std_logic_vector(15 downto 0);

BEGIN

	s_op <= op(5 downto 3);
	s_sub_op <= op(2 downto 0);

	arit_log: op_arit_log port map (
		x => x,
		y => y,
		op => s_sub_op,
		w => s_w_arit_log
	);

	comp: op_comp port map (
		x => x,
		y => y,
		op => s_sub_op,
		w => s_w_comp
	);

	ext_arit: op_ext_arit port map (
		x => x,
		y => y,
		op => s_sub_op,
		w => s_w_ext_arit
	);

	immeds: op_immed port map (
		x => x,
		y => y,
		op => s_sub_op,
		w => s_w_immed
	);

	movs: op_movs port map (
		x => x,
		y => y,
		op => s_sub_op,
		w => s_w_movs
	);

	with s_op select w <=
		s_w_arit_log        when "000",
		s_w_comp            when "001",
		s_w_ext_arit        when "010",
		s_w_immed           when "011",
		s_w_movs            when "100",
		y                   when others;

END Structure;
