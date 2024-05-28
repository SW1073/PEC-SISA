LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
USE ieee.std_logic_unsigned.ALL; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE work.package_control.ALL;
USE work.package_records.ALL;
USE work.package_exceptions.ALL;

ENTITY regfile IS
	PORT (
		clk    : IN  std_logic;
		wrd    : IN  std_logic;
        d_sys  : IN  std_logic;
		d      : IN  std_logic_vector(15 DOWNTO 0);
		addr_a : IN  std_logic_vector(2 DOWNTO 0);
		addr_b : IN  std_logic_vector(2 DOWNTO 0);
		addr_d : IN  std_logic_vector(2 DOWNTO 0);
        a_sys  : IN  std_logic;
        b_sys  : IN  std_logic;
        system : IN  std_logic;
        pc     : IN  std_logic_vector(15 DOWNTO 0);
        exception : IN t_exception_record;
        addr_m : IN  std_logic_vector(15 DOWNTO 0);
		a      : OUT std_logic_vector(15 DOWNTO 0);
		b      : OUT std_logic_vector(15 DOWNTO 0);
        int_enabled : OUT std_logic);
END regfile;

ARCHITECTURE Structure OF regfile IS
	-- Aqui iria la definicion de los registros
	TYPE Mat IS ARRAY (7 DOWNTO 0) OF std_logic_vector(15 DOWNTO 0);

	SIGNAL registers : Mat := (OTHERS => (OTHERS => '0'));
    SIGNAL sys_registers : Mat := (OTHERS => (OTHERS => '0'));

    SIGNAL s_wrd        : std_logic;
    SIGNAL s_sys_wrd    : std_logic;

    SIGNAL reg_a        : std_logic_vector(15 DOWNTO 0);
    SIGNAL sys_reg_a    : std_logic_vector(15 DOWNTO 0);

    SIGNAL reg_b        : std_logic_vector(15 DOWNTO 0);
    SIGNAL sys_reg_b    : std_logic_vector(15 DOWNTO 0);
BEGIN

    s_wrd <= '0' WHEN d_sys = '1' ELSE wrd;
    s_sys_wrd <= wrd AND d_sys;

	-- Aqui iria la definicion del comportamiento del banco de registros
	-- Os puede ser util usar la funcion "conv_integer" o "to_integer"
	-- Una buena (y limpia) implementacion no deberia ocupar más de 7 o 8 lineas

	PROCESS (clk) IS
        VARIABLE v_prev_is_exception : std_logic := '0';
	BEGIN
		IF rising_edge(clk) THEN
            IF system = '1' THEN
                sys_registers(7)(1) <= '0';
                sys_registers(1) <= pc;
            END IF;

            IF v_prev_is_exception = '0' AND exception.is_exception = '1' THEN
                sys_registers(2) <= x"000" & exception.code;
                IF exception.code = EX_BAD_ALIGNMENT THEN
                    sys_registers(3) <= addr_m;
                END IF;
            END IF;

            IF s_wrd = '1' THEN
                registers(conv_integer(addr_d)) <= d;
            END IF;

            IF s_sys_wrd = '1' THEN
                sys_registers(conv_integer(addr_d)) <= d;
            END IF;

            v_prev_is_exception := exception.is_exception;
		END IF;
	END PROCESS;

    reg_a <= registers(conv_integer(addr_a));
    sys_reg_a <= sys_registers(conv_integer(addr_a));
	a <= sys_reg_a WHEN a_sys = SYS_OUT_SYS ELSE reg_a;

    reg_b <= registers(conv_integer(addr_b));
    sys_reg_b <= sys_registers(conv_integer(addr_b));
	b <= sys_reg_b WHEN b_sys = SYS_OUT_SYS ELSE reg_b;

    -- bit 1 de S7
    int_enabled <= sys_registers(7)(1);

END Structure;

