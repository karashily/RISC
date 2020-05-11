library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard_detection_unit is
    port(
        A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
        clk: in STD_LOGIC;
        reset: in std_logic;

        -- branch_hazard
        prediction_bit: in STD_LOGIC;
        opcode_FD: in STD_LOGIC_VECTOR (4 DOWNTO 0);
        opcode_DE: in STD_LOGIC_VECTOR (4 DOWNTO 0);
        opcode_EM: in STD_LOGIC_VECTOR (4 DOWNTO 0);
        opcode_MW: in STD_LOGIC_VECTOR (4 DOWNTO 0);
        Rdst_FD_code: in STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rdst_DE_code: in STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rdst_EM_code: in STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rdst_MW_code: in STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rsrc1_DE_code: in STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rsrc1_EM_code: in STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rsrc1_MW_code: in STD_LOGIC_VECTOR (2 DOWNTO 0);
        --load use hazard
        Rsrc2_DE_code: in STD_LOGIC_VECTOR (2 DOWNTO 0);
        -- wrong prediction
        ZF: in STD_LOGIC;
        -- RET-RTI-Reset-INT
        INT: in STD_LOGIC;
        INT_MW: in STD_LOGIC;
        RESET_MW: in STD_LOGIC;
        
        -- outputs
        wrong_prediction_bit: out STD_LOGIC;
        load_ret_PC: out STD_LOGIC;
        PC_write: out STD_LOGIC;
        control_unit_mux: out STD_LOGIC
      );
  end hazard_detection_unit;

architecture hazard_detection_unit_arch of hazard_detection_unit is
    signal stall_bit_1: std_logic := '0';
    signal stall_bit_2: std_logic := '0';
    signal stall_bit_3: std_logic := '0';
    signal stall_bit_4: std_logic := '0';
    signal stall_bit_5: std_logic := '0';
    signal stall_bit_6: std_logic := '0';
    signal stall_bit_7: std_logic := '0';


    component fetch_hazard is
        port(
          A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
          clk: in std_logic;
          reset: in std_logic;
          result: out STD_LOGIC
          );
    end component;

begin
    PC_write <= not( 
                stall_bit_1 or 
                stall_bit_3 or 
                stall_bit_5 or 
                stall_bit_6 or 
                stall_bit_7);
    
    control_unit_mux <= stall_bit_1 or 
                        stall_bit_2 or 
                        stall_bit_3 or 
                        stall_bit_4 or 
                        stall_bit_5 or 
                        stall_bit_6 or 
                        stall_bit_7;

    wrong_prediction_bit <= stall_bit_4;

    long_fetch_hazard : fetch_hazard port map (A,clk,reset,stall_bit_2);

    process(stall_bit_5)
        begin
            if falling_edge(stall_bit_5) then
                load_ret_PC <= '1';
            else
                load_ret_PC <= '0';
            end if;
        end process;

end hazard_detection_unit_arch; 

