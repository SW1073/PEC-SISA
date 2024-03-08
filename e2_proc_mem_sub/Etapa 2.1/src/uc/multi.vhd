library ieee;
USE ieee.std_logic_1164.all;

entity multi is
    port(clk       : IN  STD_LOGIC;
         boot      : IN  STD_LOGIC;
         ldpc_l    : IN  STD_LOGIC;
         wrd_l     : IN  STD_LOGIC;
         wr_m_l    : IN  STD_LOGIC;
         w_b       : IN  STD_LOGIC;
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
         wr_m      : OUT STD_LOGIC;
         ldir      : OUT STD_LOGIC;
         ins_dad   : OUT STD_LOGIC;
         word_byte : OUT STD_LOGIC);
end entity;

architecture Structure of multi is

    -- Aqui iria la declaracion de las los estados de la maquina de estados
	 signal s_estado: std_logic := '0'; -- 0 si FETCH, 1 si DEMW
begin

    -- Aqui iria la maquina de estados del modelos de Moore que gestiona el multiciclo
    -- Aqui irian la generacion de las senales de control que su valor depende del ciclo en que se esta.
		process (clk) is
		begin
			if rising_edge(clk) then
				if boot = '1' then
					s_estado <= '0'; -- FETCH
				else
					s_estado <= not s_estado;		
				end if;
			end if;
		end process;
		
		-- Señal que, o bien vale el valor de ldpc generado por la lógica de control cuando se está en el ciclo
		--de DEMW o 0 en otro caso (hasta que implementemos las instrucciones de salto).
		ldpc <= ldpc_l when s_estado = '1' else '0';
		
		-- Señal que, o bien vale el valor de wrd generado por la lógica de control cuando se está en el ciclo 
		-- de DEMW o 0 en otro caso.
		wrd <= wrd_l when s_estado = '1' else '0';
		
		-- Señal que, o bien vale el valor de wr_m generado por la lógica de control cuando se está en el
		-- ciclo de DEMW o 0 en otro caso.
		wr_m <= wr_m_l when s_estado = '1' else '0';
		
		-- Señal word_byte generada por la lógica de control y que sólo debe dejarse pasar en el ciclo de
		-- DEMW. En el ciclo F debe valer 0 ya que el acceso a la memoria,
		-- para traerse una instrucción, es a nivel de word
		word_byte <= w_b when s_estado = '1' else '0';
		 
		-- Esta señal a 1 le indicará al datapath que en el bus de direcciones de la memoria deberá poner la
		-- salida de la ALU y si vale 0 deberá poner el PC. Básicamente nos dice si estamos al ciclo F o DEMW
		ins_dad <= not s_estado; -- s_estado es 0 si FETCH, 1 cuando DEMW
		
		-- Es la señal que indica que cargaremos un nuevo valor en el IR, sólo se activa en el ciclo F
		ldir <= not s_estado;
	 
end Structure;
