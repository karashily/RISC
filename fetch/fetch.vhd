library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
    port(
        A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
        clk: in std_logic;
        reset: in std_logic;
        Rdst_val: in std_logic_vector(31 downto 0);
        PC_flags_mem :in std_logic_vector(31 downto 0);
        unpredicted_PC_E: in std_logic_vector(31 downto 0);
        load_ret_PC: in std_logic;
        load_ret_PC_int: in std_logic;
        wrong_prediction_bit: in std_logic;
        PC_load: in std_logic;
        opcode_E: in std_logic_vector(4 downto 0);
        ZF: in std_logic;
        prediction_bit_out: out std_logic;
        PC_to_fetch: out std_logic_vector(31 downto 0);
        PC_unpredicted_out: out std_logic_vector(31 downto 0);
        PC_predict: out std_logic_vector(31 downto 0)
      );
  end fetch;

architecture fetch_arch of fetch is
    signal PC_predicted : std_logic_vector(31 downto 0);
    signal PC_unpredicted : std_logic_vector(31 downto 0);
    signal PC : std_logic_vector(31 downto 0);
    signal PC_mem : std_logic_vector(31 downto 0);
    signal prediction_bit : std_logic := '1';
    signal PC_reg_in : std_logic_vector(31 downto 0);
    constant PC_start : std_logic_vector(31 downto 0) := "01000000000000000000000000000000"; -- location of nop
    signal prediction_correct : std_logic;
    signal prediction_load : std_logic;
    constant jz_opcode : std_logic_vector(4 downto 0) := "11000";

    component PC_predictor is
        port(
          A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
          Rdst_val: in std_logic_vector(31 downto 0);
          PC: in std_logic_vector(31 downto 0);
          PC_mem: in std_logic_vector(31 downto 0);
          unpredicted_PC_E: in std_logic_vector(31 downto 0);
          prediction_bit: in std_logic;
    
          load_ret_PC: in std_logic;
          load_ret_PC_int: in std_logic;

          wrong_prediction_bit: in std_logic;
    
          clk: in std_logic;
    
          PC_predicted: out std_logic_vector(31 downto 0);
          PC_unpredicted: out std_logic_vector(31 downto 0)
          );
      end component;

    component regi IS
        generic( Nbits : positive := 16 );
        PORT(
            d   : IN std_logic_vector(Nbits-1 DOWNTO 0);
            ld  : IN std_logic; -- load/enable.
            clr : IN std_logic; -- async. clear.
            clk : IN std_logic; -- clock.
            q   : OUT std_logic_vector(Nbits-1 DOWNTO 0) -- output
        );
    END component;

    component prediction_state_machine is    
    port (
        input,clk,load,rst:in std_logic;
        output:out std_logic);
    end component ;

begin
    PC_mem(19 downto 0) <= PC_flags_mem(19 downto 0);
    PC_mem(31 downto 20) <= (others => '0');
    PC_pred : PC_predictor port map (A,Rdst_val,PC,PC_mem,unpredicted_PC_E,prediction_bit,load_ret_PC,load_ret_PC_int,wrong_prediction_bit,clk,PC_predicted,PC_unpredicted);
    -- PC_reg_in <= PC_predicted when reset = '0' else PC_start;
    PC_reg_in <= PC_predicted;
    PC_reg : regi generic map (32) port map (PC_reg_in,PC_load,'0',clk,PC);
    -- PC_unpred_reg : regi generic map (32) port map (PC_unpredicted,PC_load,'0',clk,PC_unpredicted_out);
    PC_unpredicted_out <= PC_unpredicted;
    prediction_correct <= not wrong_prediction_bit;
    prediction_load <= '1' when opcode_E = jz_opcode else '0';
    prediction_state_machine_map: prediction_state_machine port map (ZF,clk,prediction_load,reset,prediction_bit);
    prediction_bit_out <= prediction_bit;
    PC_to_fetch <= PC;
    PC_predict <= PC_predicted;
    
end fetch_arch; 

