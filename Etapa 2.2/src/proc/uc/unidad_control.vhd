LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY unidad_control IS
	PORT (
		boot      : IN  std_logic;
		clk       : IN  std_logic;
		datard_m  : IN  std_logic_vector(15 DOWNTO 0);
		op        : OUT std_logic_vector(1 DOWNTO 0);
		wrd       : OUT std_logic;
		addr_a    : OUT std_logic_vector(2 DOWNTO 0);
		addr_b    : OUT std_logic_vector(2 DOWNTO 0);
		addr_d    : OUT std_logic_vector(2 DOWNTO 0);
		immed     : OUT std_logic_vector(15 DOWNTO 0);
		pc        : OUT std_logic_vector(15 DOWNTO 0);
		ins_dad   : OUT std_logic;
		in_d      : OUT std_logic;
		immed_x2  : OUT std_logic;
		wr_m      : OUT std_logic;
		word_byte : OUT std_logic);
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

	-- Declaracion de las entidades que vamos a usar
	-- Control Logic
	COMPONENT control_l IS
		PORT (
			ir        : IN  std_logic_vector(15 DOWNTO 0);
			op        : OUT std_logic_vector(1 DOWNTO 0);
			ldpc      : OUT std_logic;
			wrd       : OUT std_logic;
			addr_a    : OUT std_logic_vector(2 DOWNTO 0);
			addr_b    : OUT std_logic_vector(2 DOWNTO 0);
			addr_d    : OUT std_logic_vector(2 DOWNTO 0);
			immed     : OUT std_logic_vector(15 DOWNTO 0);
			wr_m      : OUT std_logic;
			in_d      : OUT std_logic;
			immed_x2  : OUT std_logic;
			word_byte : OUT std_logic);
	END COMPONENT;

	-- Multi
	COMPONENT multi IS
		PORT (
			clk       : IN  std_logic;
			boot      : IN  std_logic;
			ldpc_l    : IN  std_logic;
			wrd_l     : IN  std_logic;
			wr_m_l    : IN  std_logic;
			w_b       : IN  std_logic;
			ldpc      : OUT std_logic;
			wrd       : OUT std_logic;
			wr_m      : OUT std_logic;
			ldir      : OUT std_logic;
			ins_dad   : OUT std_logic;
			word_byte : OUT std_logic);
	END COMPONENT;

	-- Señales para conectar control_l con multi
	SIGNAL s_ldpc       : std_logic;
	SIGNAL s_word_byte  : std_logic;
	SIGNAL s_wr_m       : std_logic;
	SIGNAL s_wrd        : std_logic;

	-- Señales útiles que salen del multi y usamos dentro de la uc
	SIGNAL s_multi_ldpc : std_logic;
	SIGNAL s_multi_ldir : std_logic;

	-- Registros de valores que tienen que mantenerse entre clock cycles
	SIGNAL s_reg_pc     : std_logic_vector(15 DOWNTO 0); -- pc register
	SIGNAL s_reg_ir     : std_logic_vector(15 DOWNTO 0); -- instruction register
BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
	-- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

	control_l0 : control_l PORT MAP(
		-- input
		ir        => s_reg_ir, -- instruction register
		-- ouputs
		op        => op,
		ldpc      => s_ldpc,
		wrd       => s_wrd,
		addr_a    => addr_a,
		addr_b    => addr_b,
		addr_d    => addr_d,
		immed     => immed,
		wr_m      => s_wr_m,
		in_d      => in_d,
		immed_x2  => immed_x2,
		word_byte => s_word_byte
	);

	multi0 : multi PORT MAP(
		-- inputs
		clk       => clk,
		boot      => boot,
		ldpc_l    => s_ldpc,
		wrd_l     => s_wrd,
		wr_m_l    => s_wr_m,
		w_b       => s_word_byte,
		-- outputs
		ldpc      => s_multi_ldpc,
		wrd       => wrd,
		wr_m      => wr_m,
		ldir      => s_multi_ldir,
		ins_dad   => ins_dad,
		word_byte => word_byte
	);

	-- Program Counter and Instruction Register
	cp_and_ir : PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			IF boot = '0' THEN
				-- Sumamos al PC solo cuando ldpc que sale del multi = 1
				IF s_multi_ldpc = '1' THEN
					s_reg_pc <= s_reg_pc + 2;
				END IF;

				-- Sumamos al IR solo cuando ldir que sale del multi = 1
				IF s_multi_ldir = '1' THEN
					s_reg_ir <= datard_m;
				END IF;
			ELSE
				-- Valores default cuando en boot
				s_reg_pc <= x"C000";
				s_reg_ir <= x"0000";
			END IF;
		END IF;
	END PROCESS; -- cp_and_ir

	pc <= s_reg_pc;

END Structure;

