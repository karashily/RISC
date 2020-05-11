library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_predictor is
    port(
      A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
      Rdst_val: in std_logic_vector(31 downto 0);
      PC: in std_logic_vector(31 downto 0);
      PC_mem: in std_logic_vector(31 downto 0);
      unpredicted_PC_E: in std_logic_vector(31 downto 0);
      prediction_bit: in std_logic;

      load_ret_PC: in std_logic;
      wrong_prediction_bit: in std_logic;

      clk: in std_logic;

      PC_predicted: out std_logic_vector(31 downto 0);
      PC_unpredicted: out std_logic_vector(31 downto 0)
      );
  end PC_predictor;

architecture PC_predictor_arch of PC_predictor is
    signal opcode: std_logic_vector(4 downto 0);

    constant jz_opcode : std_logic_vector(4 downto 0) := "11000";
    constant jmp_opcode : std_logic_vector(4 downto 0) := "11001";
    constant call_opcode : std_logic_vector(4 downto 0) := "11010";

begin
    opcode <= A(4 downto 0);

    PC_predicted <= Rdst_val when (wrong_prediction_bit = '0' and load_ret_PC = '0') and (( (opcode = jz_opcode) and (prediction_bit = '1') ) or  (opcode = jmp_opcode) or  (opcode = call_opcode))
    else std_logic_vector( unsigned(PC) + 1 ) when (wrong_prediction_bit = '0' and load_ret_PC = '0')
    else unpredicted_PC_E when (wrong_prediction_bit = '1')
    else std_logic_vector( unsigned(PC_Mem) + 1 ) when (load_ret_PC = '1');

    PC_unpredicted <= std_logic_vector( unsigned(PC) + 1 ) when (wrong_prediction_bit = '0' and load_ret_PC = '0') and (( (opcode = jz_opcode) and (prediction_bit = '1') ) or  (opcode = jmp_opcode) or  (opcode = call_opcode))
    else Rdst_val when  (wrong_prediction_bit = '0' and load_ret_PC = '0') and ((opcode = jz_opcode) and (prediction_bit = '0'))
    else std_logic_vector( unsigned(PC) + 1 );

    -- process(clk)
    -- begin
    --     if falling_edge(clk) then


    --         if (wrong_prediction_bit = '0' and load_ret_PC = '0') then
    --             if ( (opcode = jz_opcode) and (prediction_bit = '1') ) or  (opcode = jmp_opcode) or  (opcode = call_opcode) then
    --                 PC_predicted <= Rdst_val;
    --                 PC_unpredicted <= std_logic_vector( unsigned(PC) + 1 );
    --             elsif  (opcode = jz_opcode) and (prediction_bit = '0') then
    --                 PC_predicted <= std_logic_vector( unsigned(PC) + 1 );
    --                 PC_unpredicted <= Rdst_val;
    --             else
    --                 PC_predicted <= std_logic_vector( unsigned(PC) + 1 );
    --                 PC_unpredicted <= std_logic_vector( unsigned(PC) + 1 );
    --             end if;

    --         elsif (wrong_prediction_bit = '1') then
    --             PC_predicted <= unpredicted_PC_E;
    --             PC_unpredicted <= std_logic_vector( unsigned(PC) + 1 );

    --         elsif (load_ret_PC = '1') then
    --             PC_predicted <= std_logic_vector( unsigned(PC_Mem) + 1 );
    --             PC_unpredicted <= std_logic_vector( unsigned(PC) + 1 );
    --         end if;



    --     end if;
    -- end process;

    


   

end PC_predictor_arch; 

