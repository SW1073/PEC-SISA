LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_alu.ALL;
USE work.package_control.ALL;

ENTITY unidad_control IS
	PORT (
        boot       : IN  std_logic;
        clk        : IN  std_logic;
        z          : IN  std_logic;
        datard_m   : IN  std_logic_vector(15 DOWNTO 0);
        regout_a   : IN  std_logic_vector(15 DOWNTO 0);
        int_enabled: IN  std_logic;
        intr       : IN  std_logic;
        div_by_zero : IN  std_logic;
        bad_allignment : IN std_logic;
        op         : OUT std_logic_vector(2 DOWNTO 0);
        f          : OUT std_logic_vector(2 DOWNTO 0);
        wrd        : OUT std_logic;
        d_sys      : OUT std_logic;
        addr_a     : OUT std_logic_vector(2 DOWNTO 0);
        addr_b     : OUT std_logic_vector(2 DOWNTO 0);
        addr_d     : OUT std_logic_vector(2 DOWNTO 0);
        immed      : OUT std_logic_vector(15 DOWNTO 0);
        pc         : OUT std_logic_vector(15 DOWNTO 0);
        ins_dad    : OUT std_logic;
        in_d       : OUT std_logic_vector(1 DOWNTO 0);
        immed_x2   : OUT std_logic;
        wr_m       : OUT std_logic;
        word_byte  : OUT std_logic;
        b_or_immed : OUT std_logic;
        a_sys      : OUT std_logic;
        b_sys      : OUT std_logic;
        addr_io    : OUT std_logic_vector(7  DOWNTO 0);
        wr_out     : OUT std_logic;
        rd_in      : OUT std_logic;
        system     : OUT std_logic;
        inta       : OUT std_logic;
        exception_code : OUT std_logic_vector(3 DOWNTO 0));
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

	-- Declaracion de las entidades que vamos a usar
	-- Control Logic
	COMPONENT control_l IS
		PORT (
			ir         : IN  std_logic_vector(15 DOWNTO 0);
            system     : IN  std_logic;
			z          : IN  std_logic;
			op         : OUT std_logic_vector(2 DOWNTO 0);
			f          : OUT std_logic_vector(2 DOWNTO 0);
			ldpc       : OUT std_logic;
			wrd        : OUT std_logic;
            d_sys      : OUT std_logic;
			addr_a     : OUT std_logic_vector(2 DOWNTO 0);
			addr_b     : OUT std_logic_vector(2 DOWNTO 0);
			addr_d     : OUT std_logic_vector(2 DOWNTO 0);
			immed      : OUT std_logic_vector(15 DOWNTO 0);
			wr_m       : OUT std_logic;
			in_d       : OUT std_logic_vector(1 DOWNTO 0);
			immed_x2   : OUT std_logic;
			word_byte  : OUT std_logic;
			tknbr      : OUT std_logic_vector(1 DOWNTO 0);
            b_or_immed : OUT std_logic;
            a_sys      : OUT std_logic;
            b_sys      : OUT std_logic;
            addr_io    : OUT std_logic_vector(7  DOWNTO 0);
            wr_out     : OUT std_logic;
            rd_in      : OUT std_logic;
            inta       : OUT std_logic);
	END COMPONENT;

	-- Multi
	COMPONENT multi IS
		PORT (
            clk       : IN  std_logic;
            boot      : IN  std_logic;
            ldpc_l    : IN  std_logic;
            wrd_l     : IN  std_logic;
            wr_m_l    : IN  std_logic;
            rd_in_l   : IN  std_logic;
            wr_out_l  : IN  std_logic;
            w_b       : IN  std_logic;
            int_enabled : IN std_logic;
            intr      : IN std_logic;
            exception : IN std_logic;
            ldpc      : OUT std_logic;
            wrd       : OUT std_logic;
            wr_m      : OUT std_logic;
            rd_in     : OUT std_logic;
            wr_out    : OUT std_logic;
            ldir      : OUT std_logic;
            ins_dad   : OUT std_logic;
            word_byte : OUT std_logic;
            system    : OUT std_logic);
	END COMPONENT;

    COMPONENT exception_ctrl IS
	PORT (
		clk             : IN  std_logic;
        ir              : IN  std_logic_vector(15 DOWNTO 0);
        int_enabled     : IN std_logic;
        intr            : IN std_logic;
        bad_allignment  : IN std_logic;
        exception       : OUT std_logic;
        exception_code  : OUT std_logic_vector(3 DOWNTO 0));
    END COMPONENT;

	-- Senales para conectar control_l con multi
	SIGNAL s_ldpc      : std_logic;
	SIGNAL s_word_byte : std_logic;
	SIGNAL s_wr_m      : std_logic;
	SIGNAL s_wrd       : std_logic;

	-- Senales utiles que salen del multi y usamos dentro de la uc
	SIGNAL s_multi_ldpc : std_logic;
	SIGNAL s_multi_ldir : std_logic;

	SIGNAL s_immed                    : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_tknbr                    : std_logic_vector(1 DOWNTO 0);
	SIGNAL s_pc_mas_dos               : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_immed_multiplicado_por_2 : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_pc_mas_immed             : std_logic_vector(15 DOWNTO 0);

	-- Registros de valores que tienen que mantenerse entre clock cycles
	SIGNAL s_reg_pc : std_logic_vector(15 DOWNTO 0); -- pc register
	SIGNAL s_reg_ir : std_logic_vector(15 DOWNTO 0); -- instruction register

    SIGNAL s_rd_in  : std_logic;
    SIGNAL s_wr_out : std_logic;

    SIGNAl s_system : std_logic;
    SIGNAL s_exception : std_logic;
BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
	-- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC
	s_pc_mas_dos               <= s_reg_pc + 2;
	s_immed_multiplicado_por_2 <= s_immed(14 DOWNTO 0) & '0';
	s_pc_mas_immed             <= s_immed_multiplicado_por_2 + s_pc_mas_dos;

	control_l0 : control_l PORT MAP(
		-- input
		ir => s_reg_ir, -- instruction register
        system => s_system,
		z  => z,
		-- ouputs
		op         => op,
		f          => f,
		ldpc       => s_ldpc,
		wrd        => s_wrd,
        d_sys      => d_sys,
		addr_a     => addr_a,
		addr_b     => addr_b,
		addr_d     => addr_d,
		immed      => s_immed,
		wr_m       => s_wr_m,
		in_d       => in_d,
		immed_x2   => immed_x2,
		word_byte  => s_word_byte,
		tknbr      => s_tknbr,
		b_or_immed => b_or_immed,
        a_sys      => a_sys,
        b_sys      => b_sys,
        addr_io    => addr_io,
        wr_out     => s_wr_out,
        rd_in      => s_rd_in,
        inta       => inta
	);

	multi0 : multi PORT MAP(
		-- inputs
		clk    => clk,
		boot   => boot,
		ldpc_l => s_ldpc,
		wrd_l  => s_wrd,
		wr_m_l => s_wr_m,
        rd_in_l => s_rd_in,
        wr_out_l => s_wr_out,
		w_b    => s_word_byte,
        int_enabled => int_enabled,
        intr   => intr,
        exception => s_exception,
		-- outputs
		ldpc      => s_multi_ldpc,
		wrd       => wrd,
		wr_m      => wr_m,
        rd_in     => rd_in,
        wr_out    => wr_out,
		ldir      => s_multi_ldir,
		ins_dad   => ins_dad,
		word_byte => word_byte,
        system    => s_system
	);

    ex_ctrl : exception_ctrl PORT MAP(
        clk            => clk,
        ir             => s_reg_ir,
        int_enabled    => int_enabled,
        intr           => intr,
        bad_allignment => bad_allignment,
        exception      => s_exception,
        exception_code => exception_code
    );

	-- Program Counter and Instruction Register
	cp_and_ir : PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			IF boot = '0' THEN
				-- Sumamos al PC solo cuando ldpc que sale del multi = 1
				IF s_multi_ldpc = '1' THEN
					CASE s_tknbr IS
						WHEN TKNBR_NOT_TAKEN =>
							s_reg_pc <= s_pc_mas_dos;
						WHEN TKNBR_BRANCH =>
							s_reg_pc <= s_pc_mas_immed;
						WHEN TKNBR_JUMP =>
							s_reg_pc <= regout_a;
						WHEN OTHERS =>
							s_reg_pc <= s_pc_mas_dos;
					END CASE;
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

	pc    <= s_reg_pc;
	immed <= s_immed;
    system <= s_system;

END Structure;

