LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY datapath IS
	PORT (
		clk      : IN  std_logic;
		op       : IN  std_logic_vector(1 DOWNTO 0);
		wrd      : IN  std_logic;
		addr_a   : IN  std_logic_vector(2 DOWNTO 0);
		addr_b   : IN  std_logic_vector(2 DOWNTO 0);
		addr_d   : IN  std_logic_vector(2 DOWNTO 0);
		immed    : IN  std_logic_vector(15 DOWNTO 0);
		immed_x2 : IN  std_logic;
		datard_m : IN  std_logic_vector(15 DOWNTO 0);
		ins_dad  : IN  std_logic;
		pc       : IN  std_logic_vector(15 DOWNTO 0);
		in_d     : IN  std_logic;
		addr_m   : OUT std_logic_vector(15 DOWNTO 0);
		data_wr  : OUT std_logic_vector(15 DOWNTO 0));
END datapath;

ARCHITECTURE Structure OF datapath IS

	-- Aqui iria la declaracion de las entidades que vamos a usar
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades

	COMPONENT alu IS
		PORT (
			x  : IN  std_logic_vector(15 DOWNTO 0);
			y  : IN  std_logic_vector(15 DOWNTO 0);
			op : IN  std_logic_vector(1 DOWNTO 0);
			w  : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT;
	COMPONENT regfile IS
		PORT (
			clk    : IN  std_logic;
			wrd    : IN  std_logic;
			d      : IN  std_logic_vector(15 DOWNTO 0);
			addr_a : IN  std_logic_vector(2 DOWNTO 0);
			addr_b : IN  std_logic_vector(2 DOWNTO 0);
			addr_d : IN  std_logic_vector(2 DOWNTO 0);
			a      : OUT std_logic_vector(15 DOWNTO 0);
			b      : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT;

	SIGNAL s_regout_a : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_regout_b : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_aluout   : std_logic_vector(15 DOWNTO 0);

	SIGNAL s_data : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_y    : std_logic_vector(15 DOWNTO 0);

BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del banco de registros le hemos llamado reg0 y a la de la alu le hemos llamado alu0

	s_data <= datard_m WHEN in_d = '1' ELSE s_aluout;
	s_y    <= immed WHEN immed_x2 = '0' ELSE (immed(14 DOWNTO 0) & '0');

	reg : regfile PORT MAP(
		clk    => clk,
		wrd    => wrd,
		d      => s_data,
		addr_a => addr_a,
		addr_b => addr_b,
		addr_d => addr_d,
		a      => s_regout_a,
		b      => s_regout_b
	);

	al : alu PORT MAP(
		op => op,
		x  => s_regout_a,
		y  => s_y,
		w  => s_aluout
	);

	addr_m  <= s_aluout WHEN ins_dad = '1' ELSE pc;
	data_wr <= s_regout_b;

END Structure;

