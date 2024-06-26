LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.package_opcodes.all;
USE work.package_alu.all;

ENTITY control_l IS
	PORT (ir				: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            op		        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            f				: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			ldpc			: OUT STD_LOGIC;
			wrd 			: OUT STD_LOGIC;
			addr_a 		    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b 		    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d 		    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed 		    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_m 			: OUT STD_LOGIC;
			in_d 			: OUT STD_LOGIC;
			immed_x2 	    : OUT STD_LOGIC;
			word_byte 	    : OUT STD_LOGIC;
            b_or_immed      : OUT STD_LOGIC);
END control_l;


ARCHITECTURE Structure OF control_l IS
	signal s_opcode: std_logic_vector(3 downto 0);
	signal s_f: std_logic_vector(2 downto 0);
	signal s_first_reg:  std_logic_vector(2 downto 0);
	signal s_second_reg: std_logic_vector(2 downto 0);
	signal s_third_reg: std_logic_vector(2 downto 0);
	signal s_short_immed: signed(5 downto 0);
	signal s_long_immed: signed(7 downto 0);
	signal s_op: std_logic;
BEGIN

	s_opcode <= ir(15 downto 12);
	s_f <= ir(5 downto 3);
	s_first_reg <= ir(11 downto 9);
	s_second_reg <= ir(8 downto 6); -- Esto siempre corresponde a Ra
    s_third_reg <= ir(2 downto 0);
	s_short_immed <= signed(ir(5 downto 0));
	s_long_immed <= signed(ir(7 downto 0));
	s_op <= ir(8);

	-- Aqui iria la generacion de las senales de control del datapath

	-- Operacion de ALU

    with s_opcode select op <=
        OP_ARIT_LOG     when OPCODE_ARIT_LOG,   -- ARITMETICO LOGICAS
        OP_ARIT_LOG     when OPCODE_LOAD,       -- LD
        OP_ARIT_LOG     when OPCODE_STORE,      -- ST
        OP_ARIT_LOG     when OPCODE_LOADB,      -- LDB
        OP_ARIT_LOG     when OPCODE_STOREB,     -- STB
        OP_CMPS         when OPCODE_CMPS,       -- COMPARACIONES
        OP_EXT_ARIT     when OPCODE_EXT_ARIT,   -- MULS Y DIVS
        OP_IMMED        when OPCODE_IMMED,      -- IMMED (addi)
        OP_MOVS         when OPCODE_MOVS,       -- MOVS
        OP_ARIT_LOG     when others;

    -- f <= "00"&s_op when s_opcode = "0101"
                        -- else "100" when s_opcode = "0011" or s_opcode = "0100" or s_opcode = "1101" or s_opcode = "1110"
                        -- else s_f;

    with s_opcode select f <=
        "00"&s_op           when OPCODE_MOVS,
        F_ARIT_LOG_ADD      when OPCODE_LOAD,
        F_ARIT_LOG_ADD      when OPCODE_STORE,
        F_ARIT_LOG_ADD      when OPCODE_LOADB,
        F_ARIT_LOG_ADD      when OPCODE_STOREB,
        F_ARIT_LOG_ADD      when OPCODE_IMMED,
        s_f                 when others;

	-- op <= ("0" & s_op) when s_opcode = "0101" else "10"; -- Se suma solo si no son MoviS

	-- Enable de incremento de PC
	ldpc <= '0' when ir = x"FFFF" else '1';

	-- Permiso de escritura en el Banco de registros
    with s_opcode select wrd <=
        '1' when OPCODE_MOVS, -- Cuando MOVS
        '1' when OPCODE_LOAD, -- Cuando LD
        '1' when OPCODE_LOADB, -- Cuando LDB
        '1' when OPCODE_ARIT_LOG,
        '1' when OPCODE_CMPS,
        '1' when OPCODE_EXT_ARIT,
        '1' when OPCODE_IMMED,
        '0' when others;

	-- wrd <= '1' when s_opcode = "0101" or s_opcode = "0011" or s_opcode = "1101"  -- movis y Loads
                --     or s_opcode = "0000" or s_opcode = "0001" or s_opcode = "0010" or s_opcode = "1000"  -- aritmeticologicas, comps, muls y divs
                -- else '0';

	-- Direcciones de registros
	with s_opcode select
        addr_a <= s_first_reg when OPCODE_MOVS,
                  s_second_reg when others;

    with s_opcode select
        addr_b <= s_first_reg when OPCODE_STORE,
                  s_first_reg when OPCODE_STOREB,
                  s_third_reg when others;

	addr_d <= s_first_reg; -- Realmente solo se uaa su valor cuando LDx o MOVxI

    with s_opcode select
        b_or_immed <= '1' when OPCODE_CMPS,
                      '1' when OPCODE_ARIT_LOG,
                      '1' when OPCODE_EXT_ARIT,
                      '0' when others;


	-- Valor inmediato con extension de signo extraido de la instruccion.
	immed <= std_logic_vector(resize(s_long_immed, immed'length)) when s_opcode = OPCODE_MOVS else
				std_logic_vector(resize(s_short_immed, immed'length));

	-- Permiso de escritura en la memoria si es una instrucci�n ST o STB
	with s_opcode select wr_m <=
        '1' when OPCODE_STORE, -- Cuando ST o STB
        '1' when OPCODE_STOREB, -- Cuando ST o STB
		'0' when others;

	-- 1 when MEM, 0 when ALU (permiso para el banco de registros)
	with s_opcode select in_d <=
        '1' when OPCODE_LOAD, -- Cuando LD o LDB
        '1' when OPCODE_LOADB, -- Cuando LD o LDB
		'0' when others;

	-- La se�al que determina si hay que desplazar el inmediato o no
	with s_opcode select immed_x2 <=
        '1' when OPCODE_LOAD, -- Cuando LD o ST
        '1' when OPCODE_STORE, -- Cuando LD o ST
		'0' when others;

	-- La se�al indica si el acceso a memoria es a nivel de byte o word
	with s_opcode select word_byte <=
        '1' when OPCODE_LOADB, -- Cuando LDB o STB
        '1' when OPCODE_STOREB, -- Cuando LDB o STB
		'0' when others;

END Structure;
