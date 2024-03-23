LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_l IS
	PORT (ir				: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            op		        : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			ldpc			: OUT STD_LOGIC;
			wrd 			: OUT STD_LOGIC;
			addr_a 		    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b 		    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d 		    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed 		    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_m 			: OUT STD_LOGIC;
			in_d 			: OUT STD_LOGIC;
			immed_x2 	    : OUT STD_LOGIC;
			word_byte 	    : OUT STD_LOGIC);
END control_l;


ARCHITECTURE Structure OF control_l IS
	signal s_opcode: std_logic_vector(3 downto 0);
	signal s_sub_op: std_logic_vector(2 downto 0);
	signal s_first_reg:  std_logic_vector(2 downto 0);
	signal s_second_reg: std_logic_vector(2 downto 0);
	signal s_short_immed: signed(5 downto 0);
	signal s_long_immed: signed(7 downto 0);
	signal s_op: std_logic;
BEGIN

	s_opcode <= ir(15 downto 12);
	s_sub_op <= ir(5 downto 3);
	s_first_reg <= ir(11 downto 9);
	s_second_reg <= ir(8 downto 6);
	s_short_immed <= signed(ir(5 downto 0));
	s_long_immed <= signed(ir(7 downto 0));
	s_op <= ir(8);

	-- Aqui iria la generacion de las senales de control del datapath

	-- Operacion de ALU

    with s_opcode select op(5 downto 3) <=
        "000"   when "0000",    -- ARITMETICO LOGICAS
        "000"   when "1011",    -- LD
        "000"   when "1100",    -- ST
        "000"   when "1101",    -- LDB
        "000"   when "1110",    -- STB
        "001"   when "0001",    -- COMPARACIONES
        "010"   when "1000",    -- MULS Y DIVS
        "011"   when "0010",    -- IMMED (addi)
        "100"   when "0101",    -- MOVS
        "000"   when others;

    op(2 downto 0) <= "00"&s_op when s_opcode = "0101"
                        else "100" when s_opcode = "0011" or s_opcode = "0100" or s_opcode = "1101" or s_opcode = "1110"
                        else s_sub_op;
	-- op <= ("0" & s_op) when s_opcode = "0101" else "10"; -- Se suma solo si no son MoviS

	-- Enable de incremento de PC
	ldpc <= '0' when ir = x"FFFF" else '1';

	-- Permiso de escritura en el Banco de registros
	wrd <= '1' when s_opcode = "0101" or s_opcode = "0011" or s_opcode = "1101"  -- movis y Loads
                    or s_opcode = "0000" or s_opcode = "0001" or s_opcode = "0010" or s_opcode = "1000"  -- aritmeticologicas, comps, muls y divs
                else '0';

	-- Direcciones de registros
	with s_opcode select	addr_a <=
		s_first_reg when "0101",
		s_second_reg when others;

	addr_b <= s_first_reg; -- Realmente solo se usa su valor cuando STx
	addr_d <= s_first_reg; -- Realmente solo se uaa su valor cuando LDx o MOVxI

	-- Valor inmediato con extension de signo extraido de la instruccion.
	immed <= std_logic_vector(resize(s_long_immed, immed'length)) when s_opcode = "0101" else
				std_logic_vector(resize(s_short_immed, immed'length));

	-- Permiso de escritura en la memoria si es una instrucción ST o STB
	with s_opcode select wr_m <=
        '1' when "0100", -- Cuando ST o STB
        '1' when "1110", -- Cuando ST o STB
		'0' when others;

	-- 1 when MEM, 0 when ALU (permiso para el banco de registros)
	with s_opcode select in_d <=
        '1' when "0011", -- Cuando LD o LDB
        '1' when "1101", -- Cuando LD o LDB
		'0' when others;

	-- La señal que determina si hay que desplazar el inmediato o no
	with s_opcode select immed_x2 <=
        '1' when "0011", -- Cuando LD o ST
        '1' when "0100", -- Cuando LD o ST
		'0' when others;

	-- La señal indica si el acceso a memoria es a nivel de byte o word
	with s_opcode select word_byte <=
        '1' when "1101", -- Cuando LDB o STB
        '1' when "1110", -- Cuando LDB o STB
		'0' when others;

END Structure;
