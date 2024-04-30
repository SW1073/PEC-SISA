LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY proc IS
	PORT (
		clk       : IN  std_logic;
		boot      : IN  std_logic;
        inta      : OUT  std_logic;
        intr      : IN  std_logic;
		datard_m  : IN  std_logic_vector(15 DOWNTO 0);
		addr_m    : OUT std_logic_vector(15 DOWNTO 0);
		data_wr   : OUT std_logic_vector(15 DOWNTO 0);
		wr_m      : OUT std_logic;
		word_byte : OUT std_logic;
		dbg_pc    : OUT std_logic_vector(15 DOWNTO 0);
        addr_io   : OUT STD_LOGIC_VECTOR(7  DOWNTO 0);
        rd_io     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        wr_out    : OUT STD_LOGIC;
        rd_in     : OUT STD_LOGIC);
END proc;
ARCHITECTURE Structure OF proc IS

	-- Aqui iria la declaracion de las entidades que vamos a usar
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades

	COMPONENT datapath IS
		PORT (
			clk        : IN  std_logic;
			op         : IN  std_logic_vector(2 DOWNTO 0);
			f          : IN  std_logic_vector(2 DOWNTO 0);
			wrd        : IN  std_logic;
            d_sys      : IN  std_logic;
			addr_a     : IN  std_logic_vector(2 DOWNTO 0);
			addr_b     : IN  std_logic_vector(2 DOWNTO 0);
			addr_d     : IN  std_logic_vector(2 DOWNTO 0);
			immed      : IN  std_logic_vector(15 DOWNTO 0);
			immed_x2   : IN  std_logic;
			datard_m   : IN  std_logic_vector(15 DOWNTO 0);
			ins_dad    : IN  std_logic;
			pc         : IN  std_logic_vector(15 DOWNTO 0);
			in_d       : IN  std_logic_vector(1 DOWNTO 0);
			b_or_immed : IN  std_logic;
            a_sys      : IN  std_logic;
            b_sys      : IN  std_logic;
            rd_io      : IN  std_logic_vector(15 downto 0);
            system     : IN  std_logic;
			addr_m     : OUT std_logic_vector(15 DOWNTO 0);
			data_wr    : OUT std_logic_vector(15 DOWNTO 0);
			regout_a   : OUT std_logic_vector(15 DOWNTO 0);
            int_enabled : OUT std_logic;
			z          : OUT std_logic);
	END COMPONENT;

	COMPONENT unidad_control IS
		PORT (
			boot       : IN  std_logic;
			clk        : IN  std_logic;
			z          : IN  std_logic;
			datard_m   : IN  std_logic_vector(15 DOWNTO 0);
			regout_a   : IN  std_logic_vector(15 DOWNTO 0);
            int_enabled : IN std_logic;
            intr       : IN std_logic;
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
            addr_io    : OUT STD_LOGIC_VECTOR(7  DOWNTO 0);
            wr_out     : OUT STD_LOGIC;
            rd_in      : OUT STD_LOGIC;
            system     : OUT STD_LOGIC);
	END COMPONENT;

	SIGNAL s_op         : std_logic_vector (2 DOWNTO 0);
	SIGNAL s_f          : std_logic_vector (2 DOWNTO 0);
	SIGNAL s_wrd        : std_logic;
    SIGNAL s_d_sys      : std_logic;
	SIGNAL s_addr_a     : std_logic_vector (2 DOWNTO 0);
	SIGNAL s_addr_b     : std_logic_vector (2 DOWNTO 0);
	SIGNAL s_addr_d     : std_logic_vector (2 DOWNTO 0);
	SIGNAL s_immed      : std_logic_vector (15 DOWNTO 0);
	SIGNAL s_pc         : std_logic_vector(15 DOWNTO 0);
	SIGNAL s_ins_dad    : std_logic;
	SIGNAL s_in_d       : std_logic_vector(1 DOWNTO 0);
	SIGNAL s_immed_x2   : std_logic;
	SIGNAL s_b_or_immed : std_logic;
    SIGNAL s_a_sys      : std_logic;
    SIGNAL s_b_sys      : std_logic;
	SIGNAL s_z          : std_logic;
    SIGNAL s_int_enabled : std_logic;
    SIGNAL s_system     : std_logic;
	SIGNAL s_regout_a   : std_logic_vector(15 DOWNTO 0);

BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0

	dp : datapath PORT MAP(
		-- inpus
		clk        => clk,
		op         => s_op,
		f          => s_f,
		wrd        => s_wrd,
        d_sys      => s_d_sys,
		addr_a     => s_addr_a,
		addr_b     => s_addr_b,
		addr_d     => s_addr_d,
		immed      => s_immed,
		immed_x2   => s_immed_x2,
		datard_m   => datard_m,
		ins_dad    => s_ins_dad,
		pc         => s_pc,
		in_d       => s_in_d,
		b_or_immed => s_b_or_immed,
        a_sys      => s_a_sys,
        b_sys      => s_b_sys,
        rd_io      => rd_io,
        system     => s_system,
		-- outputs
		addr_m     => addr_m,
		data_wr    => data_wr,
		regout_a   => s_regout_a,
        int_enabled => s_int_enabled,
		z          => s_z
	);

	uc : unidad_control PORT MAP(
		-- inputs
		boot       => boot,
		clk        => clk,
		datard_m   => datard_m,
		regout_a   => s_regout_a,
		z          => s_z,
        int_enabled => s_int_enabled,
        intr       => intr,
		-- outputs
		op         => s_op,
		f          => s_f,
		wrd        => s_wrd,
        d_sys      => s_d_sys,
		addr_a     => s_addr_a,
		addr_b     => s_addr_b,
		addr_d     => s_addr_d,
		immed      => s_immed,
		pc         => s_pc,
		ins_dad    => s_ins_dad,
		in_d       => s_in_d,
		immed_x2   => s_immed_x2,
		wr_m       => wr_m,
		word_byte  => word_byte,
		b_or_immed => s_b_or_immed,
        a_sys      => s_a_sys,
        b_sys      => s_b_sys,
        addr_io    => addr_io,
        wr_out     => wr_out,
        rd_in      => rd_in,
        system     => s_system
	);

	dbg_pc <= s_pc;
    inta <= '0';

END Structure;

