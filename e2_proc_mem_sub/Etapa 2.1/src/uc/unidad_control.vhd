LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY unidad_control IS
	PORT (boot		: IN STD_LOGIC;
		  clk		: IN STD_LOGIC;
		  datard_m	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
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
		  word_byte : OUT STD_LOGIC);
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

	-- Aqui iria la declaracion de las entidades que vamos a usar
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	-- Aqui iria la definicion del program counter

	COMPONENT control_l IS
		PORT(ir			: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 op			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			 ldpc		: OUT STD_LOGIC;
			 wrd		: OUT STD_LOGIC;
			 addr_a		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			 addr_b		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			 addr_d		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			 immed		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 wr_m		: OUT STD_LOGIC;
			 in_d		: OUT STD_LOGIC;
			 immed_x2 	: OUT STD_LOGIC;
			 word_byte 	: OUT STD_LOGIC);
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

	-- Señales para conectar control_l con multi
	signal s_ldpc: std_logic;
	signal s_word_byte: std_logic;
	signal s_wr_m: std_logic;
	signal s_wrd: std_logic;

	-- Señales útiles que salen del multi
	signal s_multi_ldpc: std_logic;
	signal s_multi_ldir: std_logic;

	-- Registros de valores que tienen que mantenerse entre clock cycles
	signal s_pc: std_logic_vector(15 downto 0) := (others => '0'); -- pc register
	signal s_ir: std_logic_vector(15 downto 0); -- instruction register
BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
	-- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

	control_l0: control_l port map(
		-- input
		ir			=> s_ir, -- instruction register
		-- ouputs
		op			=> op,
		ldpc		=> s_ldpc,
		wrd			=> s_wrd,
		addr_a		=> addr_a,
		addr_b		=> addr_b,
		addr_d		=> addr_d,
		immed		=> immed,
		wr_m		=> s_wr_m,
		in_d		=> in_d,
		immed_x2 	=> immed_x2,
		word_byte 	=> s_word_byte
	);

	multi0: multi port map(
		-- inputs
		clk			=> clk,
		boot		=> boot,
		ldpc_l		=> s_ldpc,
		wrd_l		=> s_wrd,
		wr_m_l		=> s_wr_m,
		w_b			=> s_word_byte,
		-- outputs
		ldpc		=> s_multi_ldpc,
		wrd			=> wrd,
		wr_m		=> wr_m,
		ldir		=> s_multi_ldir,
		ins_dad		=> ins_dad,
		word_byte	=> word_byte
	);

	-- Program Counter and Instruction Register
	cp_and_ir: process(clk) is
	begin
		if rising_edge(clk) then
			if boot = '0' then
				-- Sumamos al PC solo cuando ldpc que sale del multi = 1
				if s_multi_ldpc = '1' then
					s_pc <= s_pc + 2;
				end if;

				-- Sumamos al IR solo cuando ldir que sale del multi = 1
				if s_multi_ldir = '1' then
					s_ir <= datard_m;
				end if;
			else
				-- Valores default cuando en boot
				s_pc <= x"C000";
				s_ir <= x"0000";
			end if;
		end if;
	end process; -- cp_and_ir

	pc <= s_pc;

END Structure;
