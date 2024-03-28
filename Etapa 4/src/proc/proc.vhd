LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
	PORT (	clk			: IN STD_LOGIC;
			boot		: IN STD_LOGIC;
			datard_m	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_wr		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_m		: OUT STD_LOGIC;
			word_byte	: OUT STD_LOGIC;
			dbg_pc		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END proc;


ARCHITECTURE Structure OF proc IS

	-- Aqui iria la declaracion de las entidades que vamos a usar
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades

	COMPONENT datapath IS
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
              b_or_immed:  IN  STD_LOGIC;
			  addr_m:      OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			  data_wr:     OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              regout_a:    OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              z:           OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT unidad_control IS
	PORT (boot		: IN STD_LOGIC;
		  clk		: IN STD_LOGIC;
          z         : IN STD_LOGIC;
		  datard_m	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          regout_a  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          f         : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		  wrd		: OUT STD_LOGIC;
		  addr_a	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		  addr_b	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		  addr_d	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		  immed		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  pc		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  ins_dad	: OUT STD_LOGIC;
		  in_d		: OUT STD_LOGIC;
		  immed_x2	: OUT STD_LOGIC;
		  wr_m		: OUT STD_LOGIC;
		  word_byte : OUT STD_LOGIC;
          b_or_immed: OUT STD_LOGIC);
	END COMPONENT;

	signal s_op: std_logic_vector (2 downto 0);
	signal s_f: std_logic_vector (2 downto 0);
	signal s_wrd: std_logic;
	signal s_addr_a: std_logic_vector (2 downto 0);
	signal s_addr_b: std_logic_vector (2 downto 0);
	signal s_addr_d: std_logic_vector (2 downto 0);
	signal s_immed: std_logic_vector (15 downto 0);
	signal s_pc: std_logic_vector(15 downto 0);
	signal s_ins_dad: std_logic;
	signal s_in_d: std_logic;
	signal s_immed_x2: std_logic;
    signal s_b_or_immed: std_logic;
    signal s_z: std_logic;
    signal s_regout_a: std_logic_vector(15 downto 0);

BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0

	dp: datapath port map (
		-- inpus
		clk         => clk,
		op          => s_op,
        f           => s_f,
		wrd         => s_wrd,
		addr_a      => s_addr_a,
		addr_b      => s_addr_b,
		addr_d      => s_addr_d,
		immed       => s_immed,
		immed_x2    => s_immed_x2,
		datard_m    => datard_m,
		ins_dad     => s_ins_dad,
		pc          => s_pc,
		in_d        => s_in_d,
        b_or_immed  => s_b_or_immed,
		-- outputs
		addr_m      => addr_m,
		data_wr		=> data_wr,
        regout_a    => s_regout_a,
        z           => s_z
	);

	uc: unidad_control port map(
		-- inputs
		boot		=> boot,
		clk			=> clk,
		datard_m	=> datard_m,
        regout_a    => s_regout_a,
        z           => s_z,
		-- outputs
		op			=> s_op,
        f           => s_f,
		wrd			=> s_wrd,
		addr_a		=> s_addr_a,
		addr_b		=> s_addr_b,
		addr_d		=> s_addr_d,
		immed		=> s_immed,
		pc			=> s_pc,
		ins_dad		=> s_ins_dad,
		in_d		=> s_in_d,
		immed_x2	=> s_immed_x2,
		wr_m		=> wr_m,
		word_byte	=> word_byte,
        b_or_immed  => s_b_or_immed
	);

	dbg_pc <= s_pc;

END Structure;
