LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.package_control.ALL;
USE work.package_opcodes.ALL;
USE work.package_alu.ALL;

ENTITY control_l IS
	PORT (
		ir         : IN  std_logic_vector(15 DOWNTO 0);
		z          : IN  std_logic;
		op         : OUT std_logic_vector(2 DOWNTO 0);
		f          : OUT std_logic_vector(2 DOWNTO 0);
		ldpc       : OUT std_logic;
		wrd        : OUT std_logic;
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
        addr_io    : OUT STD_LOGIC_VECTOR(7  DOWNTO 0);
        wr_out     : OUT STD_LOGIC;
        rd_in      : OUT STD_LOGIC);
END control_l;

ARCHITECTURE Structure OF control_l IS
	SIGNAL s_opcode      : std_logic_vector(3 DOWNTO 0);
	SIGNAL s_f           : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_f_jumps     : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_first_reg   : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_second_reg  : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_third_reg   : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_short_immed : signed(5 DOWNTO 0);
	SIGNAL s_long_immed  : signed(7 DOWNTO 0);
	SIGNAL s_op          : std_logic;
	SIGNAL s_wrd_jump    : std_logic;
	SIGNAL s_wrd_io      : std_logic;
BEGIN

	s_opcode      <= ir(15 DOWNTO 12);
	s_f           <= ir(5 DOWNTO 3);
	s_f_jumps     <= ir(2 DOWNTO 0);
	s_first_reg   <= ir(11 DOWNTO 9);
	s_second_reg  <= ir(8 DOWNTO 6); -- Esto siempre corresponde a Ra
	s_third_reg   <= ir(2 DOWNTO 0);
	s_short_immed <= signed(ir(5 DOWNTO 0));
	s_long_immed  <= signed(ir(7 DOWNTO 0));
	s_op          <= ir(8);

	-- Operacion de ALU
	WITH s_opcode SELECT
        op <= OP_ARIT_LOG WHEN OPCODE_ARIT_LOG, -- ARITMETICO LOGICAS
              OP_ARIT_LOG WHEN OPCODE_LOAD,     -- LD
              OP_ARIT_LOG WHEN OPCODE_STORE,    -- ST
              OP_ARIT_LOG WHEN OPCODE_LOADB,    -- LDB
              OP_ARIT_LOG WHEN OPCODE_STOREB,   -- STB
              OP_CMPS     WHEN OPCODE_CMPS,     -- COMPARACIONES
              OP_EXT_ARIT WHEN OPCODE_EXT_ARIT, -- MULS Y DIVS
              OP_IMMED    WHEN OPCODE_IMMED,    -- IMMED (addi)
              OP_MOVS     WHEN OPCODE_MOVS,     -- MOVS
              OP_ARIT_LOG WHEN OTHERS;

	WITH s_opcode SELECT
        f <= "00" & s_op     WHEN OPCODE_MOVS,
             F_ARIT_LOG_ADD  WHEN OPCODE_LOAD,
             F_ARIT_LOG_ADD  WHEN OPCODE_STORE,
             F_ARIT_LOG_ADD  WHEN OPCODE_LOADB,
             F_ARIT_LOG_ADD  WHEN OPCODE_STOREB,
             F_ARIT_LOG_ADD  WHEN OPCODE_IMMED,
             s_f             WHEN OTHERS;

	-- falta el 11 para cuando falla el TLB
	tknbr <= TKNBR_BRANCH   WHEN s_opcode = OPCODE_BRANCHES AND s_op = F_BRANCH_BZ AND z = '1' ELSE
             TKNBR_BRANCH   WHEN s_opcode = OPCODE_BRANCHES AND s_op = F_BRANCH_BNZ AND z = '0' ELSE
             TKNBR_JUMP     WHEN s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_JZ AND z = '1' ELSE
             TKNBR_JUMP     WHEN s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_JNZ AND z = '0' ELSE
             TKNBR_JUMP     WHEN s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_JMP ELSE
             TKNBR_JUMP     WHEN s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_JAL ELSE
             TKNBR_NOT_TAKEN;

	-- op <= ("0" & s_op) when s_opcode = "0101" else "10"; -- Se suma solo si no son MoviS

	-- Enable de incremento de PC
	ldpc <= '0' WHEN ir = x"FFFF" ELSE '1';

	-- Permiso de escritura en el Banco de registros
	s_wrd_jump <= '1' WHEN (s_f_jumps = F_JUMP_JAL OR s_f_jumps = F_JUMP_CALLS) ELSE
                  '0';

    s_wrd_io <= '1' when s_op = F_INPUT else '0';

	WITH s_opcode SELECT
        wrd <= '1'         WHEN OPCODE_MOVS,  -- Cuando MOVS
               '1'         WHEN OPCODE_LOAD,  -- Cuando LD
               '1'         WHEN OPCODE_LOADB, -- Cuando LDB
               '1'         WHEN OPCODE_ARIT_LOG,
               '1'         WHEN OPCODE_CMPS,
               '1'         WHEN OPCODE_EXT_ARIT,
               '1'         WHEN OPCODE_IMMED,
               s_wrd_jump  WHEN OPCODE_JUMPS,
               s_wrd_io    WHEN OPCODE_IO,
               '0'         WHEN OTHERS;

	-- Direcciones de registros
	WITH s_opcode SELECT
		addr_a <= s_first_reg  WHEN OPCODE_MOVS,
                  s_second_reg WHEN OTHERS;

	WITH s_opcode SELECT
		addr_b <= s_first_reg WHEN OPCODE_STORE,
                  s_first_reg WHEN OPCODE_STOREB,
                  s_first_reg WHEN OPCODE_BRANCHES,
                  s_first_reg WHEN OPCODE_JUMPS,
                  s_first_reg WHEN OPCODE_IO,
                  s_third_reg WHEN OTHERS;

	-- siempre pasa esto
	addr_d <= s_first_reg;

	WITH s_opcode SELECT
        b_or_immed <= '1' WHEN OPCODE_CMPS,
                      '1' WHEN OPCODE_ARIT_LOG,
                      '1' WHEN OPCODE_EXT_ARIT,
                      '1' WHEN OPCODE_BRANCHES,
                      '1' WHEN OPCODE_JUMPS,
                      '0' WHEN OTHERS;

	-- Valor inmediato con extension de signo extraido de la instruccion.
	WITH s_opcode SELECT
		immed <= std_logic_vector(resize(s_long_immed, immed'length))  WHEN OPCODE_MOVS,
                 std_logic_vector(resize(s_long_immed, immed'length))  WHEN OPCODE_BRANCHES,
                 std_logic_vector(resize(s_short_immed, immed'length)) WHEN OTHERS;

	-- Permiso de escritura en la memoria si es una instrucción ST o STB
	WITH s_opcode SELECT
        wr_m <= '1' WHEN OPCODE_STORE,  -- Cuando ST o STB
                '1' WHEN OPCODE_STOREB, -- Cuando ST o STB
                '0' WHEN OTHERS;

	-- 1 when MEM, 0 when ALU (permiso para el banco de registros)
	WITH s_opcode SELECT
        in_d <= IN_D_DATAMEM WHEN OPCODE_LOAD,  -- Cuando LD o LDB
                IN_D_DATAMEM WHEN OPCODE_LOADB, -- Cuando LD o LDB
                IN_D_PC      WHEN OPCODE_JUMPS, -- ESTO IGNORA SI ES JAL O CALLS, LE ENTRA PC+2 AL BANCO DE REGS SIEMPRE.
                IN_D_IO      WHEN OPCODE_IO,    -- Cuando operamos con IO
                IN_D_ALUOUT  WHEN OTHERS;

	-- La señal que determina si hay que desplazar el inmediato o no
	WITH s_opcode SELECT
        immed_x2 <= '1' WHEN OPCODE_LOAD,  -- Cuando LD o ST
                    '1' WHEN OPCODE_STORE, -- Cuando LD o ST
                    '0' WHEN OTHERS;

	-- La señal indica si el acceso a memoria es a nivel de byte o word
	WITH s_opcode SELECT
        word_byte <= '1' WHEN OPCODE_LOADB,  -- Cuando LDB o STB
                     '1' WHEN OPCODE_STOREB, -- Cuando LDB o STB
                     '0' WHEN OTHERS;

    -- Dirección del modulo de input output
    addr_io <= std_logic_vector(resize(s_long_immed, addr_io'length));

    -- Enable de excritura en el módulo io
    wr_out <= '1' when s_opcode = OPCODE_IO and s_op = F_OUTPUT else '0';

    -- Enable de lectura en el módulo io
    rd_in  <= '1' when s_opcode = OPCODE_IO and s_op = F_INPUT else '0';

END Structure;

