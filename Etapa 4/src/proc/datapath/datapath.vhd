LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY datapath IS
    PORT (clk:         IN STD_LOGIC;
          op:          IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          f:           IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          wrd:         IN STD_LOGIC;
          addr_a:      IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b:      IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d:      IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed:       IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed_x2:    IN STD_LOGIC;
          datard_m:    IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad:     IN STD_LOGIC;
          pc:          IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          in_d:        IN STD_LOGIC;
          addr_m:      OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr:     OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b_or_immed:  IN  STD_LOGIC);
END datapath;

ARCHITECTURE Structure OF datapath IS

	-- Aqui iria la declaracion de las entidades que vamos a usar
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades

	COMPONENT alu IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  f  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;


	COMPONENT regfile IS
		PORT (clk    : IN  STD_LOGIC;
			  wrd    : IN  STD_LOGIC;
			  d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			  b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;

	signal s_regout_a: std_logic_vector(15 downto 0);
	signal s_regout_b: std_logic_vector(15 downto 0);
	signal s_aluout: std_logic_vector(15 downto 0);

	signal s_data: std_logic_vector(15 downto 0);
	signal s_immed_real: std_logic_vector(15 downto 0);
	signal s_y: std_logic_vector(15 downto 0);

BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del banco de registros le hemos llamado reg0 y a la de la alu le hemos llamado alu0

    s_data <= datard_m when in_d = '1' else s_aluout;
    s_immed_real <= immed when immed_x2 = '0' else (immed(14 DOWNTO 0) & '0');
    s_y <= s_regout_b when b_or_immed = '1' else s_immed_real;

	reg: regfile port map(
		clk => clk,
		wrd => wrd,
		d => s_data,
		addr_a => addr_a,
		addr_b => addr_b,
		addr_d => addr_d,
		a => s_regout_a,
		b => s_regout_b
	);

	al: alu port map(
		op => op,
        f => f,
		x => s_regout_a,
		y => s_y,
		w => s_aluout
	);

	addr_m <= s_aluout when ins_dad = '1' else pc;
	data_wr <= s_regout_b;

END Structure;
