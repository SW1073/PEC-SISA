LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY unidad_control IS
	PORT (boot   : IN  STD_LOGIC;
		  clk    : IN  STD_LOGIC;
		  ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		  wrd    : OUT STD_LOGIC;
		  addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		  addr_b : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		  addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		  immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  pc     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

	-- Aqui iria la declaracion de las entidades que vamos a usar
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	-- Aqui iria la definicion del program counter

	COMPONENT control_l IS
		PORT (ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              op     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			  ldpc   : OUT STD_LOGIC;
			  wrd    : OUT STD_LOGIC;
			  addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			  addr_b : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			  addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			  immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT multi IS
    PORT(clk       : IN  STD_LOGIC;
         boot      : IN  STD_LOGIC;
         ldpc_l    : IN  STD_LOGIC;
         wrd_l     : IN  STD_LOGIC;
         wr_m_l    : IN  STD_LOGIC;
         w_b       : IN  STD_LOGIC;
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
         wr_m      : OUT STD_LOGIC;
         ldir      : OUT STD_LOGIC;
         ins_dad   : OUT STD_LOGIC;
         word_byte : OUT STD_LOGIC);
	END COMPONENT;

	signal s_ldpc: std_logic;
	signal s_pc: std_logic_vector(15 downto 0) := (others => '0');
BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
	-- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

	cl: control_l port map(
		ir => ir,
		op => op,
		ldpc => s_ldpc,
		wrd => wrd,
		addr_a => addr_a,
		addr_b => addr_a,
		addr_d => addr_d,
		immed => immed
	);
	
	-- TODO: Conectar bien
	multi0: multi port map (
		clk => clk,
		boot => boot,
		ldpc_l => '1',
		wrd_l => '1',
		wr_m_l => '1',
		w_b => '1'
		-- ldpc => ,
		-- wrd => ,
		-- wr_m => ,
		-- ldir => ,
		-- ins_dad => ,
		-- word_byte =>
	);

	cp: process(clk) is
	begin
		if rising_edge(clk) then

			if boot = '0' then
				if s_ldpc = '1' then
					s_pc <= s_pc + 2;
				end if;
			else
				s_pc <= x"C000";
			end if;

		end if;
	end process; -- cp

	pc <= s_pc;

END Structure;
