LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE work.package_alu.all;

ENTITY unidad_control IS
	PORT (boot		: IN STD_LOGIC;
		  clk		: IN STD_LOGIC;
		  datard_m	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          z         : IN STD_LOGIC;
          regout_a  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  op		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
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
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

	-- Declaracion de las entidades que vamos a usar
	-- Control Logic
    COMPONENT control_l IS
        PORT (ir            : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              z             : IN STD_LOGIC;
              op            : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              f				: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              ldpc			: OUT STD_LOGIC;
              wrd 			: OUT STD_LOGIC;
              addr_a        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_b        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_d        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              immed         : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              wr_m 			: OUT STD_LOGIC;
              in_d 			: OUT STD_LOGIC;
              immed_x2 	    : OUT STD_LOGIC;
              word_byte     : OUT STD_LOGIC;
              tknbr         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
              b_or_immed    : OUT STD_LOGIC);
    END COMPONENT;

	-- Multi
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

	-- Senales para conectar control_l con multi
	signal s_ldpc: std_logic;
	signal s_word_byte: std_logic;
	signal s_wr_m: std_logic;
	signal s_wrd: std_logic;

	-- Senales utiles que salen del multi y usamos dentro de la uc
	signal s_multi_ldpc: std_logic;
	signal s_multi_ldir: std_logic;

    signal s_immed: std_logic_vector(15 downto 0);
    signal s_tknbr: std_logic_vector(1 downto 0);
    signal s_pc_mas_dos: std_logic_vector(15 downto 0);
    signal s_immed_multiplicado_por_2: std_logic_vector(15 downto 0);
    signal s_pc_mas_immed: std_logic_vector(15 downto 0);

	-- Registros de valores que tienen que mantenerse entre clock cycles
	signal s_reg_pc: std_logic_vector(15 downto 0); -- pc register
	signal s_reg_ir: std_logic_vector(15 downto 0); -- instruction register
BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
	-- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC
    s_pc_mas_dos <= s_reg_pc + 2;
    s_immed_multiplicado_por_2 <= s_immed(14 downto 0) & '0';
    s_pc_mas_immed <= s_immed_multiplicado_por_2 + s_pc_mas_dos;

	control_l0: control_l port map(
		-- input
		ir			=> s_reg_ir, -- instruction register
        z           => z,
		-- ouputs
		op			=> op,
        f           => f,
		ldpc		=> s_ldpc,
		wrd			=> s_wrd,
		addr_a		=> addr_a,
		addr_b		=> addr_b,
		addr_d		=> addr_d,
		immed		=> s_immed,
		wr_m		=> s_wr_m,
		in_d		=> in_d,
		immed_x2 	=> immed_x2,
		word_byte 	=> s_word_byte,
        b_or_immed  => b_or_immed,
        tknbr		=> s_tknbr
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
                    case s_tknbr is
                        when TKNBR_NOT_TAKEN =>
                            s_reg_pc <= s_pc_mas_dos;
                        when TKNBR_BRANCH =>
                            s_reg_pc <= s_pc_mas_immed;
                        when TKNBR_JUMP =>
                            s_reg_pc <= regout_a;
                        when others =>
                            s_reg_pc <= s_pc_mas_dos;
                    end case;
				end if;

				-- Sumamos al IR solo cuando ldir que sale del multi = 1
				if s_multi_ldir = '1' then
					s_reg_ir <= datard_m;
				end if;
			else
				-- Valores default cuando en boot
				s_reg_pc <= x"C000";
				s_reg_ir <= x"0000";
			end if;
		end if;
	end process; -- cp_and_ir

	pc <= s_reg_pc;
    immed <= s_immed;

END Structure;
