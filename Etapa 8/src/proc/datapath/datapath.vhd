LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.package_control.ALL;
USE work.package_records.ALL;

ENTITY datapath IS
	PORT (
		clk         : IN  std_logic;
        boot        : IN  std_logic;
		op          : IN  std_logic_vector(2 DOWNTO 0);
		f           : IN  std_logic_vector(2 DOWNTO 0);
		wrd         : IN  std_logic;
        d_sys       : IN  std_logic;
		addr_a      : IN  std_logic_vector(2 DOWNTO 0);
		addr_b      : IN  std_logic_vector(2 DOWNTO 0);
		addr_d      : IN  std_logic_vector(2 DOWNTO 0);
		immed       : IN  std_logic_vector(15 DOWNTO 0);
		immed_x2    : IN  std_logic;
		datard_m    : IN  std_logic_vector(15 DOWNTO 0);
		ins_dad     : IN  std_logic;
		pc          : IN  std_logic_vector(15 DOWNTO 0);
		in_d        : IN  std_logic_vector(1 DOWNTO 0);
        a_sys       : IN  std_logic;
        b_sys       : IN  std_logic;
		b_or_immed  : IN  std_logic;
        rd_io       : IN  std_logic_vector(15 downto 0);
        system      : IN  std_logic;
        exception   : IN  t_exception_record;
        tlb_we      : IN  std_logic;
        tlb_we_sel  : IN  std_logic;
        tlb_is_we_instr : IN std_logic;
        privileged  : OUT std_logic;
		addr_m      : OUT std_logic_vector(15 DOWNTO 0);
		data_wr     : OUT std_logic_vector(15 DOWNTO 0);
		regout_a    : OUT std_logic_vector(15 DOWNTO 0);
        int_enabled : OUT std_logic;
		z           : OUT std_logic;
        div_by_zero : OUT std_logic;
        tlb_status_out : OUT t_tlb_status_out);
END datapath;

ARCHITECTURE Structure OF datapath IS

	-- Aqui iria la declaracion de las entidades que vamos a usar
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades

	COMPONENT alu IS
		PORT (
			x  : IN  std_logic_vector(15 DOWNTO 0);
			y  : IN  std_logic_vector(15 DOWNTO 0);
			op : IN  std_logic_vector(2 DOWNTO 0);
			f  : IN  std_logic_vector(2 DOWNTO 0);
			w  : OUT std_logic_vector(15 DOWNTO 0);
			z  : OUT std_logic;
            div_by_zero : OUT std_logic);
	END COMPONENT;
	COMPONENT regfile IS
		PORT (
			clk    : IN  std_logic;
			boot   : IN  std_logic;
			wrd    : IN  std_logic;
			d      : IN  std_logic_vector(15 DOWNTO 0);
            d_sys  : IN  std_logic;
			addr_a : IN  std_logic_vector(2 DOWNTO 0);
			addr_b : IN  std_logic_vector(2 DOWNTO 0);
			addr_d : IN  std_logic_vector(2 DOWNTO 0);
            a_sys  : IN  std_logic;
            b_sys  : IN  std_logic;
            system : IN  std_logic;
            pc     : IN  std_logic_vector(15 DOWNTO 0);
            exception : IN t_exception_record;
            addr_m : IN std_logic_vector(15 DOWNTO 0);
			a      : OUT std_logic_vector(15 DOWNTO 0);
			b      : OUT std_logic_vector(15 DOWNTO 0);
            int_enabled : OUT std_logic;
            privileged :  OUT std_logic);
	END COMPONENT;

    COMPONENT tlb IS
    PORT (
        -- INPUT
        clk         : IN  std_logic;
        boot        : IN  std_logic;
        vtag        : IN  std_logic_vector(3 DOWNTO 0);
        tag_addr    : IN  std_logic_vector(2 DOWNTO 0);
        we          : IN  std_logic;
        we_sel      : IN  std_logic;
        tag_d       : IN  std_logic_vector(5 DOWNTO 0);
        flush       : IN  std_logic;
        -- OUTPUT
        tlb_miss    : OUT std_logic;
        ptag        : OUT std_logic_vector(3 DOWNTO 0);
        v           : OUT std_logic;
        r           : OUT std_logic);
    END COMPONENT;

	SIGNAL s_sys_regout_a : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_regout_a : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_regout_b : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_aluout   : std_logic_vector(15 DOWNTO 0);

	SIGNAL s_data       : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_immed_real : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_y          : std_logic_vector(15 DOWNTO 0);

	SIGNAL s_pc : std_logic_vector(15 DOWNTO 0);

    SIGNAL s_addr_m : std_logic_vector(15 DOWNTO 0);

    SIGNAL s_tlb_ptag   : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_tlb_ptag_i : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_tlb_ptag_d : std_logic_vector(3 DOWNTO 0);

    SIGNAL s_tlb_miss_i : std_logic;
    SIGNAL s_tlb_vi     : std_logic;
    SIGNAL s_tlb_ri     : std_logic;

    SIGNAL s_tlb_miss_d : std_logic;
    SIGNAL s_tlb_vd     : std_logic;
    SIGNAL s_tlb_rd     : std_logic;

    SIGNAL s_tlb_we_i     : std_logic;
    SIGNAL s_tlb_we_d     : std_logic;

BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del banco de registros le hemos llamado reg0 y a la de la alu le hemos llamado alu0

	s_pc <= pc + x"0002";

	WITH in_d SELECT
        s_data <= s_aluout WHEN IN_D_ALUOUT,
                  datard_m WHEN IN_D_DATAMEM,
                  s_pc     WHEN IN_D_PC,
                  rd_io    WHEN IN_D_IO,
                  s_aluout WHEN others;

	-- s_data <= datard_m when in_d = '1' else s_aluout;
	s_immed_real <= immed WHEN immed_x2 = '0' ELSE (immed(14 DOWNTO 0) & '0');
	s_y          <= s_regout_b WHEN b_or_immed = BIMM_B_OUT ELSE s_immed_real;
	regout_a     <= s_regout_a;

	reg : regfile PORT MAP(
		clk    => clk,
        boot   => boot,
		wrd    => wrd,
		d      => s_data,
        d_sys  => d_sys,
		addr_a => addr_a,
		addr_b => addr_b,
		addr_d => addr_d,
        a_sys  => a_sys,
        b_sys  => b_sys,
        system => system,
        pc     => pc,
        exception => exception,
        addr_m => s_addr_m,
		a      => s_regout_a,
        b      => s_regout_b,
        int_enabled => int_enabled,
        privileged => privileged
	);

	al : alu PORT MAP(
		op => op,
		f  => f,
		x  => s_regout_a,
		y  => s_y,
		w  => s_aluout,
		z  => z,
        div_by_zero => div_by_zero
	);

	s_addr_m  <= s_aluout WHEN ins_dad = '1' ELSE pc;

	data_wr <= s_regout_b;

    s_tlb_we_i <= tlb_we WHEN tlb_is_we_instr = '1' ELSE '0';
    s_tlb_we_d <= tlb_we WHEN tlb_is_we_instr = '0' ELSE '0';

    tlbi: tlb PORT MAP(
        -- INPUT
        clk     => clk,
        boot    => boot,
        vtag    => s_addr_m(15 DOWNTO 12),
        tag_addr=> s_regout_a(2 DOWNTO 0),
        we      => s_tlb_we_i,
        we_sel  => tlb_we_sel,
        tag_d   => s_regout_b(5 DOWNTO 0),
        flush   => '0',
        -- OUTPUT
        tlb_miss=> s_tlb_miss_i,
        ptag    => s_tlb_ptag_i,
        v       => s_tlb_vi,
        r       => s_tlb_ri
    );

    tlbd: tlb PORT MAP(
        -- INPUT
        clk     => clk,
        boot    => boot,
        vtag    => s_addr_m(15 DOWNTO 12),
        tag_addr=> s_regout_a(2 DOWNTO 0),
        we      => s_tlb_we_d,
        we_sel  => tlb_we_sel,
        tag_d   => s_regout_b(5 DOWNTO 0),
        flush   => '0',
        -- OUTPUT
        tlb_miss=> s_tlb_miss_d,
        ptag    => s_tlb_ptag_d,
        v       => s_tlb_vd,
        r       => s_tlb_rd
    );

    tlb_status_out.v_addr_msb <= s_addr_m(15);
    tlb_status_out.v_addr_lsb <= s_addr_m(0);

    tlb_status_out.tlb_miss_i <= s_tlb_miss_i;
    tlb_status_out.tlb_valid_i <= s_tlb_vi;

    tlb_status_out.tlb_miss_d <= s_tlb_miss_d;
    tlb_status_out.tlb_valid_d <= s_tlb_vd;
    tlb_status_out.tlb_readonly_d <= s_tlb_rd;

    s_tlb_ptag <= s_tlb_ptag_i    WHEN ins_dad = '0' ELSE s_tlb_ptag_d;

    addr_m <= s_tlb_ptag & s_addr_m (11 downto 0);

END Structure;

