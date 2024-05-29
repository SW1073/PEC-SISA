LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.package_control.ALL;
USE work.package_opcodes.ALL;
USE work.package_alu.ALL;
USE work.package_tlb.ALL;

ENTITY control_l IS
	PORT (
		ir         : IN  std_logic_vector(15 DOWNTO 0);
        system     : IN std_logic;
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
        addr_io    : OUT STD_LOGIC_VECTOR(7  DOWNTO 0);
        wr_out     : OUT STD_LOGIC;
        rd_in      : OUT STD_LOGIC;
        inta       : OUT STD_LOGIC;
        is_illegal_ir       : OUT std_logic;
        is_mem_access       : OUT std_logic;
        is_protected_ir     : OUT std_logic;
        calls               : OUT std_logic;
        tlb_we              : OUT std_logic;
        tlb_we_sel          : OUT std_logic;
        tlb_is_we_instr     : OUT std_logic);
END control_l;

ARCHITECTURE Structure OF control_l IS

    COMPONENT illegal_ir IS
        PORT (
            ir              : IN std_logic_vector(15 DOWNTO 0);
            is_illegal      : OUT std_logic);
    END COMPONENT;

	SIGNAL s_opcode         : std_logic_vector(3 DOWNTO 0);
	SIGNAL s_f              : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_f_jumps        : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_f_sys          : std_logic_vector(5 DOWNTO 0);
	SIGNAL s_first_reg      : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_second_reg     : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_third_reg      : std_logic_vector(2 DOWNTO 0);
	SIGNAL s_short_immed    : signed(5 DOWNTO 0);
	SIGNAL s_long_immed     : signed(7 DOWNTO 0);
	SIGNAL s_op             : std_logic;
	SIGNAL s_wrd_jump       : std_logic;
	SIGNAL s_wrd_io         : std_logic;
    SIGNAL s_wrd_sys        : std_logic;
    SIGNAL s_f_alu_sys      : std_logic_vector(2 DOWNTO 0);
    SIGNAL s_f_addra_sys    : std_logic_vector(2 DOWNTO 0);
    SIGNAL s_f_immed_sys    : std_logic_vector(15 DOWNTO 0);
    SIGNAL s_op_sys         : std_logic_vector(2 downto 0);
    SIGNAL s_d_sys          : std_logic;
    SIGNAL s_b_or_immed_sys : std_logic;
    SIGNAL s_in_d_sys       : std_logic_vector(1 DOWNTO 0);
    SIGNAL s_in_d_jumps     : std_logic_vector(1 DOWNTO 0);
    SIGNAL s_wurpidurpi    : std_logic;
    SIGNAL s_wurpidurpi_d    : std_logic;
BEGIN

	s_opcode      <= ir(15 DOWNTO 12);
	s_f           <= ir(5 DOWNTO 3);
	s_f_jumps     <= ir(2 DOWNTO 0);
	s_f_sys       <= ir(5 DOWNTO 0);
	s_first_reg   <= ir(11 DOWNTO 9);
	s_second_reg  <= ir(8 DOWNTO 6); -- Esto siempre corresponde a Ra
	s_third_reg   <= ir(2 DOWNTO 0);
	s_short_immed <= signed(ir(5 DOWNTO 0));
	s_long_immed  <= signed(ir(7 DOWNTO 0));
	s_op          <= ir(8);

    illegal_ir0 : illegal_ir PORT MAP (ir, is_illegal_ir);

    inta <= '1' WHEN s_opcode = OPCODE_SYS AND s_f_sys = F_SYS_GETIID ELSE
            '0';

    s_op_sys <= OP_ARIT_LOG WHEN (s_f_sys = F_SYS_EI or s_f_sys = F_SYS_DI) ELSE
                OP_MISC;

	-- Operacion de ALU
    op <= OP_MISC     WHEN system = '1'               ELSE -- ETAPA DE ENTRADA A SISTEMA
          OP_ARIT_LOG WHEN s_opcode = OPCODE_ARIT_LOG ELSE -- ARITMETICO LOGICAS
          OP_ARIT_LOG WHEN s_opcode = OPCODE_LOAD     ELSE -- LD
          OP_ARIT_LOG WHEN s_opcode = OPCODE_STORE    ELSE -- ST
          OP_ARIT_LOG WHEN s_opcode = OPCODE_LOADB    ELSE -- LDB
          OP_ARIT_LOG WHEN s_opcode = OPCODE_STOREB   ELSE -- STB
          OP_CMPS     WHEN s_opcode = OPCODE_CMPS     ELSE -- COMPARACIONES
          OP_EXT_ARIT WHEN s_opcode = OPCODE_EXT_ARIT ELSE -- MULS Y DIVS
          OP_IMMED    WHEN s_opcode = OPCODE_IMMED    ELSE -- IMMED (addi)
          OP_MISC     WHEN s_opcode = OPCODE_MOVS     ELSE -- MOVS Y MISC
          s_op_sys    WHEN s_opcode = OPCODE_SYS      ELSE -- SISTEMA. Dependen de F
          OP_MISC     WHEN s_opcode = OPCODE_JUMPS    ELSE -- JUMPS
          OP_ARIT_LOG ; -- DEFAULT

    s_f_alu_sys <= F_MISC_X_OUT     WHEN (s_f_sys = F_SYS_RDS OR s_f_sys = F_SYS_WRS) ELSE
                   F_MISC_Y_OUT     WHEN (s_f_sys = F_SYS_RETI) ELSE
                   F_ARIT_LOG_AND   WHEN (s_f_sys = F_SYS_DI) ELSE
                   F_ARIT_LOG_OR    WHEN (s_f_sys = F_SYS_EI) ELSE
                   F_MISC_X_OUT;

    f <= F_MISC_Y_OUT    WHEN system = '1'              ELSE
         "00" & s_op     WHEN s_opcode = OPCODE_MOVS    ELSE
         F_ARIT_LOG_ADD  WHEN s_opcode = OPCODE_LOAD    ELSE
         F_ARIT_LOG_ADD  WHEN s_opcode = OPCODE_STORE   ELSE
         F_ARIT_LOG_ADD  WHEN s_opcode = OPCODE_LOADB   ELSE
         F_ARIT_LOG_ADD  WHEN s_opcode = OPCODE_STOREB  ELSE
         F_ARIT_LOG_ADD  WHEN s_opcode = OPCODE_IMMED   ELSE
         s_f_alu_sys     WHEN s_opcode = OPCODE_SYS     ELSE
         F_MISC_X_OUT    WHEN s_opcode = OPCODE_JUMPS   ELSE
         s_f ;

	-- falta el 11 para cuando falla el TLB
	tknbr <= TKNBR_JUMP     WHEN system = '1' ELSE -- pilla el registro que le llega por regout_a
	         TKNBR_BRANCH   WHEN s_opcode = OPCODE_BRANCHES AND s_op = F_BRANCH_BZ AND z = '1' ELSE
             TKNBR_BRANCH   WHEN s_opcode = OPCODE_BRANCHES AND s_op = F_BRANCH_BNZ AND z = '0' ELSE
             TKNBR_JUMP     WHEN s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_JZ AND z = '1' ELSE
             TKNBR_JUMP     WHEN s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_JNZ AND z = '0' ELSE
             TKNBR_JUMP     WHEN s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_JMP ELSE
             TKNBR_JUMP     WHEN s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_JAL ELSE
             TKNBR_JUMP     WHEN s_opcode = OPCODE_SYS AND s_f_sys = F_SYS_RETI ELSE
             TKNBR_NOT_TAKEN;

	-- Enable de incremento de PC
	ldpc <= '0' WHEN ir = x"FFFF" ELSE '1';

	-- Permiso de escritura en el Banco de registros
    s_wrd_jump <= '1' WHEN (s_f_jumps = F_JUMP_JAL OR s_f_jumps = F_JUMP_CALLS) ELSE
                  '0';

    -- Permiso de escritura en el Banco de IO
    s_wrd_io <= '1' WHEN s_op = F_INPUT ELSE '0';

    -- Señal de selección d_sys. Indica en cual de los 2 bancos de registros se escribe el dato d
    WITH s_f_sys SELECT
        s_d_sys <= '1' WHEN F_SYS_WRS,
                   '1' WHEN F_SYS_RETI,
                   '1' WHEN F_SYS_EI,
                   '1' WHEN F_SYS_DI,
                   '0' WHEN F_SYS_RDS,  -- Cuando RDS, escribimos, pero en el banco de regs regular, no en el otro
                   '0' WHEN others;

    d_sys <= '1'     WHEN system = '1'          ELSE
             s_d_sys WHEN s_opcode = OPCODE_SYS ELSE
             '1'     WHEN (s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_CALLS) ELSE
             '0';

    -- Señal de esritura wrd cuando instruccion de sistema.
    -- De momento, todas las instrucciones de sistema implementadas, escriben (a un banco, o al otro)
    WITH s_f_sys SELECT
        s_wrd_sys <= '1' WHEN F_SYS_WRS,
                     '1' WHEN F_SYS_RETI,
                     '1' WHEN F_SYS_EI,
                     '1' WHEN F_SYS_DI,
                     '1' WHEN F_SYS_RDS,
                     '1' WHEN F_SYS_GETIID,
                     '0' WHEN others;

    -- Señal de escritura en banco de registros
    wrd <= '1'         WHEN system = '1'                ELSE
           '1'         WHEN s_opcode = OPCODE_MOVS      ELSE -- Cuando MOVS
           '1'         WHEN s_opcode = OPCODE_LOAD      ELSE -- Cuando LD
           '1'         WHEN s_opcode = OPCODE_LOADB     ELSE -- Cuando LDB
           '1'         WHEN s_opcode = OPCODE_ARIT_LOG  ELSE
           '1'         WHEN s_opcode = OPCODE_CMPS      ELSE
           '1'         WHEN s_opcode = OPCODE_EXT_ARIT  ELSE
           '1'         WHEN s_opcode = OPCODE_IMMED     ELSE
           s_wrd_jump  WHEN s_opcode = OPCODE_JUMPS     ELSE
           s_wrd_io    WHEN s_opcode = OPCODE_IO        ELSE
           s_wrd_sys   WHEN s_opcode = OPCODE_SYS       ELSE
           '0'         ;

    -- Seleccion de la salida del primer puerto de lectura
    -- Sale lo leido en el banco regular, o el de sisetma
    -- Puerto A
    a_sys <= SYS_OUT_SYS  WHEN system = '1' ELSE
             SYS_OUT_SYS  WHEN s_opcode = OPCODE_SYS and
                             ( s_f_sys = F_SYS_RDS OR s_f_sys = F_SYS_EI OR
                               s_f_sys = F_SYS_DI OR s_f_sys = F_SYS_RETI ) ELSE
             SYS_OUT_REG;

    -- Puerto B
    b_sys <= SYS_OUT_SYS WHEN system = '1'                                          ELSE
             SYS_OUT_SYS WHEN s_opcode = OPCODE_SYS and ( s_f_sys = F_SYS_RETI )    ELSE
             SYS_OUT_REG;

    -- Registro que se lee cuando estamos en ops de sistema.
    -- Hardcoded para algunas instrucciones que siempre leen del mismo reg
     s_f_addra_sys <="111" WHEN (s_f_sys = F_SYS_EI OR s_f_sys = F_SYS_DI)  ELSE
                     "001" WHEN (s_f_sys = F_SYS_RETI)                      ELSE
                     s_second_reg;

	-- Dirección del primer puerto de lectura
    addr_a <= "101"         WHEN system = '1'           ELSE
              s_first_reg   WHEN s_opcode = OPCODE_MOVS ELSE
              s_f_addra_sys WHEN s_opcode = OPCODE_SYS  ELSE
              s_second_reg  ;

    -- Direccion del segundo puerto de lectura

    s_wurpidurpi <= '1' WHEN s_opcode = OPCODE_SYS AND (s_f_sys = F_SYS_WRPI OR s_f_sys = F_SYS_WRVI)
                    ELSE '0';

    s_wurpidurpi_d <= '1' WHEN s_opcode = OPCODE_SYS AND (s_f_sys = F_SYS_WRPD OR s_f_sys = F_SYS_WRVD)
                    ELSE '0';

    tlb_we <= '1' WHEN s_wurpidurpi = '1' OR s_wurpidurpi_d = '1'
              ELSE '0';

    tlb_we_sel <= W_SEL_PHYSICAL WHEN s_f_sys = F_SYS_WRPI OR s_f_sys = F_SYS_WRPD
              ELSE W_SEL_VIRTUAL;


    -- Señal que indica si la instrucción actual es una instrucción de escritura en la TLB
    tlb_is_we_instr <= '1' WHEN s_wurpidurpi = '1'   ELSE
                       '0' WHEN s_wurpidurpi_d = '1' ELSE
                       '0';

    addr_b <= "111"       WHEN system = '1'                 ELSE
              s_first_reg WHEN s_opcode = OPCODE_STORE      ELSE
              s_first_reg WHEN s_opcode = OPCODE_STOREB     ELSE
              s_first_reg WHEN s_opcode = OPCODE_BRANCHES   ELSE
              s_first_reg WHEN s_opcode = OPCODE_JUMPS      ELSE
              s_first_reg WHEN s_opcode = OPCODE_IO         ELSE
              s_first_reg WHEN s_wurpidurpi = '1' OR s_wurpidurpi_d = '1' ELSE
              "000"       WHEN s_opcode = OPCODE_SYS        ELSE
              s_third_reg;

    -- Direccion del puerto de escritura
    addr_d <= "000" WHEN system = '1' ELSE
              "111" WHEN (s_opcode = OPCODE_SYS AND (s_f_sys = F_SYS_EI OR s_f_sys = F_SYS_DI OR
                          s_f_sys = F_SYS_RETI)) ELSE
              "011" WHEN (s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_CALLS) ELSE
              s_first_reg;

    s_b_or_immed_sys <= BIMM_IMMED_OUT WHEN s_f_sys = F_SYS_DI or s_f_sys = F_SYS_EI ELSE
                        BIMM_B_OUT;

    -- Selección de dato de entrada para segundo puerto de la alu
    b_or_immed <= BIMM_B_OUT        WHEN system = '1'               ELSE
                  BIMM_B_OUT        WHEN s_opcode = OPCODE_CMPS     ELSE
                  BIMM_B_OUT        WHEN s_opcode = OPCODE_ARIT_LOG ELSE
                  BIMM_B_OUT        WHEN s_opcode = OPCODE_EXT_ARIT ELSE
                  BIMM_B_OUT        WHEN s_opcode = OPCODE_BRANCHES ELSE
                  BIMM_B_OUT        WHEN s_opcode = OPCODE_JUMPS    ELSE
                  s_b_or_immed_sys  WHEN s_opcode = OPCODE_SYS      ELSE
                  BIMM_IMMED_OUT;

    s_f_immed_sys <= x"0002" WHEN (s_f_sys = F_SYS_EI) ELSE
                     x"FFFD" WHEN (s_f_sys = F_SYS_DI) ELSE
                     x"0000";

	-- Valor inmediato con extension de signo extraido de la instruccion.
	WITH s_opcode SELECT
		immed <= std_logic_vector(resize(s_long_immed, immed'length))  WHEN OPCODE_MOVS,
                 std_logic_vector(resize(s_long_immed, immed'length))  WHEN OPCODE_BRANCHES,
                 s_f_immed_sys                                         WHEN OPCODE_SYS,
                 std_logic_vector(resize(s_short_immed, immed'length)) WHEN OTHERS;

    is_mem_access <= '1' WHEN s_opcode = OPCODE_STORE   OR
                              s_opcode = OPCODE_STOREB  OR
                              s_opcode = OPCODE_LOAD    OR
                              s_opcode = OPCODE_LOADB   ELSE
                     '0';

	-- Permiso de escritura en la memoria si es una instrucción ST o STB
    wr_m <= '0' WHEN system = '1'               ELSE -- Entrada a sistema
            '1' WHEN s_opcode = OPCODE_STORE    ELSE -- Cuando ST
            '1' WHEN s_opcode = OPCODE_STOREB   ELSE -- Cuando STB
            '0' ;

    s_in_d_sys <= IN_D_IO when s_f_sys = F_SYS_GETIID ELSE
                  IN_D_ALUOUT;

    s_in_d_jumps <= IN_D_ALUOUT WHEN s_f_jumps = F_JUMP_CALLS ELSE IN_D_PC;

    -- Señal que decide que dato entra al puerto de escritura del regfile (d)
    in_d <= IN_D_ALUOUT  WHEN system = '1'              ELSE -- Entrada a sistema
            IN_D_DATAMEM WHEN s_opcode = OPCODE_LOAD    ELSE -- Cuando LD
            IN_D_DATAMEM WHEN s_opcode = OPCODE_LOADB   ELSE -- Cuando LDB
            s_in_d_jumps WHEN s_opcode = OPCODE_JUMPS   ELSE
            IN_D_IO      WHEN s_opcode = OPCODE_IO      ELSE -- Cuando operamos con IO
            s_in_d_sys   WHEN s_opcode = OPCODE_SYS     ELSE -- Cuando operamos con instrucciones de acceso a registros especiales
            IN_D_ALUOUT  ;

	-- La señal que determina si hay que desplazar el inmediato o no
	WITH s_opcode SELECT
        immed_x2 <= '1' WHEN OPCODE_LOAD,  -- Cuando LD
                    '1' WHEN OPCODE_STORE, -- Cuando ST
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

    -- Nos dice si la instruccion es protegida
    is_protected_ir <= '1' WHEN s_opcode = OPCODE_SYS and ir /= x"FFFF" ELSE '0';

    -- Nos dice si la instrucción es una entrada a sistema por software (syscall)
    calls <= '1' WHEN s_opcode = OPCODE_JUMPS AND s_f_jumps = F_JUMP_CALLS ELSE '0';

END Structure;

