LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY control_l IS
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
END control_l;
ARCHITECTURE Structure OF control_l IS
	SIGNAL s_opcode      : std_logic_vector(3 DOWNTO 0);
	SIGNAL s_first_reg   : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_second_reg  : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_short_immed : signed(5 DOWNTO 0);
	SIGNAL s_long_immed  : signed(7 DOWNTO 0);
	SIGNAL s_op          : std_logic;
BEGIN

	s_opcode      <= ir(15 DOWNTO 12);
	s_first_reg   <= ir(11 DOWNTO 9);
	s_second_reg  <= ir(8 DOWNTO 6);
	s_short_immed <= signed(ir(5 DOWNTO 0));
	s_long_immed  <= signed(ir(7 DOWNTO 0));
	s_op          <= ir(8);

	-- Aqui iria la generacion de las senales de control del datapath

	-- Operacion de ALU
	op <= ('0' & s_op) WHEN s_opcode = "0101" ELSE "10"; -- Se suma solo si no son MoviS

	-- Enable de incremento de PC
	ldpc <= '0' WHEN ir = x"FFFF" ELSE '1';

	-- Permiso de escritura en el Banco de registros
	wrd <= '1' WHEN s_opcode = "0101" OR s_opcode = "0011" OR s_opcode = "1101" ELSE '0';

	-- Direcciones de registros
	WITH s_opcode SELECT addr_a <=
		s_first_reg WHEN "0101",
		s_second_reg WHEN OTHERS;

	addr_b <= s_first_reg; -- Realmente solo se usa su valor cuando STx
	addr_d <= s_first_reg; -- Realmente solo se uaa su valor cuando LDx o MOVxI

	-- Valor inmediato con extension de signo extraido de la instruccion.
	immed <= std_logic_vector(resize(s_long_immed, immed'length)) WHEN s_opcode = "0101" ELSE
		std_logic_vector(resize(s_short_immed, immed'length));

	-- Permiso de escritura en la memoria si es una instrucción ST o STB
	WITH s_opcode SELECT wr_m <=
		'1' WHEN "0100", -- Cuando ST o STB
		'1' WHEN "1110", -- Cuando ST o STB
		'0' WHEN OTHERS;

	-- 1 when MEM, 0 when ALU (permiso para el banco de registros)
	WITH s_opcode SELECT in_d <=
		'1' WHEN "0011", -- Cuando LD o LDB
		'1' WHEN "1101", -- Cuando LD o LDB
		'0' WHEN OTHERS;

	-- La señal que determina si hay que desplazar el inmediato o no
	WITH s_opcode SELECT immed_x2 <=
		'1' WHEN "0011", -- Cuando LD o ST
		'1' WHEN "0100", -- Cuando LD o ST
		'0' WHEN OTHERS;

	-- La señal indica si el acceso a memoria es a nivel de byte o word
	WITH s_opcode SELECT word_byte <=
		'1' WHEN "1101", -- Cuando LDB o STB
		'1' WHEN "1110", -- Cuando LDB o STB
		'0' WHEN OTHERS;

END Structure;

