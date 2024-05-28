LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.package_records.ALL;
use work.package_exceptions.ALL;

ENTITY multi IS
	PORT (
		clk       : IN  std_logic;
		boot      : IN  std_logic;
		ldpc_l    : IN  std_logic;
		wrd_l     : IN  std_logic;
		wr_m_l    : IN  std_logic;
        rd_in_l   : IN  std_logic;
        wr_out_l  : IN  std_logic;
        exception_l : IN t_exception_record;
		w_b       : IN  std_logic;
		ldpc      : OUT std_logic;
		wrd       : OUT std_logic;
		wr_m      : OUT std_logic;
        rd_in     : OUT std_logic;
        wr_out    : OUT std_logic;
		ldir      : OUT std_logic;
		ins_dad   : OUT std_logic;
		word_byte : OUT std_logic;
        system    : OUT std_logic;
        exception : OUT t_exception_record);
END ENTITY;

ARCHITECTURE Structure OF multi IS

	-- Aqui iria la declaracion de las los estados de la maquina de estados
	TYPE StateType IS (FETCH, DEMW, SYS);

	SIGNAL s_estado : StateType := FETCH; -- 0 si FETCH, 1 si DEMW

    CONSTANT c_INIT_EXCEPTION : t_exception_record := (is_exception => '0', code => (OTHERS => '0'));

    SIGNAL s_recorded_exception : t_exception_record := c_INIT_EXCEPTION;

    SIGNAL s_should_goto_sys    : std_logic := '0';
    SIGNAL s_smoke_demw         : std_logic := '0';
BEGIN

    s_should_goto_sys <= s_recorded_exception.is_exception OR exception_l.is_exception;

    s_smoke_demw <=  '1' WHEN   (exception_l.is_exception = '1' AND s_recorded_exception.is_exception = '0')
                                OR
                                (s_recorded_exception.is_exception = '1' AND s_recorded_exception.code /= EX_INTERRUPT_CODE)
                ELSE '0';

	-- Aqui iria la maquina de estados del modelos de Moore que gestiona el multiciclo
	-- Aqui irian la generacion de las senales de control que su valor depende del ciclo en que se esta.
	prx_estado : PROCESS (clk, boot) IS
	BEGIN
		IF boot = '1' THEN
			s_estado <= FETCH;
		ELSIF rising_edge(clk) THEN
			CASE s_estado IS
				WHEN FETCH => s_estado <= DEMW;
				WHEN DEMW  =>
                    IF s_should_goto_sys = '1' THEN
                        s_estado  <= SYS;
                    ELSE
                        s_estado  <= FETCH;
                    END IF;
                WHEN SYS => s_estado <= FETCH;
			END CASE; -- s_estado
		END IF;
	END PROCESS; -- prx_estado

    exception_handler: PROCESS (clk, boot) IS
    BEGIN
        IF boot = '1' THEN
            s_recorded_exception.is_exception <= '0';
        ELSE
            CASE s_estado IS
                WHEN FETCH =>
                    s_recorded_exception <= exception_l;
                WHEN DEMW =>
                    -- IF s_recorded_exception.is_exception = '0' THEN
                    --     IF exception.is_exception = '1' THEN
                    --         s_recorded_exception <= exception;
                    --     ELSE
                    --         s_recorded_exception.is_exception <= '0';
                    --     END IF;
                    -- END IF;

                    IF    exception_l.is_exception = '0' AND s_recorded_exception.is_exception = '0' THEN
                        -- No han habído exceptiones
                        s_recorded_exception.is_exception <= '0';

                    -- ELSIF exception_l.is_exception = '0' AND s_recorded_exception.is_exception = '1' THEN
                        -- Ha habido una excepción en FETCH
                        -- No se actualiza la excepción guardada

                    ELSIF exception_l.is_exception = '1' AND s_recorded_exception.is_exception = '0' THEN
                        -- Ha habido una excepción en DEMW
                        s_recorded_exception <= exception_l;

                    -- ELSE -- exception_l.is_exception = '1' AND s_recorded_exception.is_exception = '1' THEN
                        -- Ha habido una excepción en FETCH y en DEMW.
                        -- Le hacemos caso a la de fetch, pues la de DEMW es invalida
                        -- (podría ser un artefacto de la previa excepción)
                    END IF;
                WHEN SYS =>
                    s_recorded_exception.is_exception <= '0';
            END CASE;
        END IF;
    END PROCESS; -- exception_handler

	-- Señal que, o bien vale el valor de ldpc generado por la lógica de control cuando se está en el ciclo
	--de DEMW o 0 en otro caso
	ldpc <= ldpc_l WHEN s_estado = DEMW OR s_estado = SYS ELSE '0';

	-- Señal que, o bien vale el valor de wrd generado por la lógica de control cuando se está en el ciclo
	-- de DEMW o 0 en otro caso.
    wrd <=  '1'     WHEN s_estado = SYS ELSE
            wrd_l   WHEN s_estado = DEMW AND s_smoke_demw = '0'
       ELSE '0';

	-- Señal que, o bien vale el valor de wr_m generado por la lógica de control cuando se está en el
	-- ciclo de DEMW o 0 en otro caso.
    wr_m <=  wr_m_l WHEN s_estado = DEMW AND s_smoke_demw = '0'
        ELSE '0';

	-- Señal word_byte generada por la lógica de control y que sólo debe dejarse pasar en el ciclo de
	-- DEMW. En el ciclo F debe valer 0 ya que el acceso a la memoria,
	-- para traerse una instrucción, es a nivel de word
	word_byte <= w_b WHEN s_estado = DEMW ELSE '0';

    rd_in <= rd_in_l WHEN s_estado = DEMW ELSE '0';
    wr_out <=  wr_out_l WHEN s_estado = DEMW AND s_smoke_demw = '0'
          ELSE '0';

	-- Esta señal a 1 le indicará al datapath que en el bus de direcciones de la memoria deberá poner la
	-- salida de la ALU y si vale 0 deberá poner el PC. Básicamente nos dice si estamos al ciclo F o DEMW
	ins_dad <= '0' WHEN s_estado = FETCH ELSE '1'; -- s_estado es 0 si FETCH, 1 cuando DEMW

	-- Es la señal que indica que cargaremos un nuevo valor en el IR, solo se activa en el ciclo F
	ldir <= '1' WHEN s_estado = FETCH ELSE '0';

    system <= '1' WHEN s_estado = SYS ELSE '0';

    exception <= s_recorded_exception;

END Structure;

