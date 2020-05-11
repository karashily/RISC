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
        wrong_prediction_bit: in std_logic;
        PC_load: in std_logic;

        prediction_bit_out: out std_logic;
        PC_to_fetch: out std_logic_vector(31 downto 0)
      );
  end fetch;

architecture fetch_arch of fetch is
    signal PC_predicted : std_logic_vector(31 downto 0);
    signal PC_unpredicted : std_logic_vector(31 downto 0);
    signal PC : std_logic_vector(31 downto 0);
    signal PC_mem : std_logic_vector(31 downto 0);
    signal prediction_bit : std_logic := '0';
    signal PC_reg_in : std_logic_vector(31 downto 0);
    constant PC_start : std_logic_vector(31 downto 0) := "10101010101010101010101010101010";
    
    component PC_predictor is
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

begin
    PC_mem(19 downto 0) <= PC_flags_mem(19 downto 0);
    PC_mem(31 downto 20) <= (others => '0');
    PC_pred : PC_predictor port map (A,Rdst_val,PC,PC_mem,unpredicted_PC_E,prediction_bit,load_ret_PC,wrong_prediction_bit,clk,PC_predicted,PC_unpredicted);
    PC_reg_in <= PC_predicted when reset = '0' else PC_start;
    PC_reg : regi generic map (32) port map (PC_reg_in,PC_load,'0',clk,PC);
    prediction_bit_out <= prediction_bit;
    PC_to_fetch <= PC;
    
end fetch_arch; 

