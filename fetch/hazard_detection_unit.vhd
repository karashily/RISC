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
        INT_EM: in STD_LOGIC;
        RESET_EM: in STD_LOGIC;
        
        -- outputs
        wrong_prediction_bit: out STD_LOGIC;
        load_ret_PC: out STD_LOGIC;
        PC_write: out STD_LOGIC;
        control_unit_mux: out STD_LOGIC;
        fetch_stall: out STD_LOGIC
      );
  end hazard_detection_unit;

architecture hazard_detection_unit_arch of hazard_detection_unit is
    signal stall_bit_1: std_logic := '0';
    signal stall_bit_2: std_logic := '0';
    signal stall_bit_3: std_logic := '0';
    signal stall_bit_4: std_logic := '0';
    signal stall_bit_5: std_logic := '0';
    signal stall_bit_5_delayed: std_logic := '0';
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

    component  RET_RTI_RESET_INT_unit IS PORT(
        A: in std_logic_vector(15 downto 0);
        opcode_EM: in std_logic_vector(4 downto 0);
        INT: in std_logic;
        INT_EM: in std_logic;
        RESET: in std_logic;
        RESET_EM: in std_logic;
        clk: in std_logic;

        output: out std_logic
        );
    END  component;

    component wrong_prediction_unit is
        port(opcode_DE : in std_logic_vector(4 downto 0);
              prediction_bit : in std_logic;
              ZF : in std_logic;
            q: out std_logic);
    end component;

    component register1 IS PORT(
    d   : IN STD_LOGIC;
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC -- output.
    );
    END component;

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
    RET_RTI_RESET_INT_hazard : RET_RTI_RESET_INT_unit port map (A,opcode_EM,INT,INT_EM,RESET,RESET_EM,clk,stall_bit_5);
    -- reset_reg: register1 port map (stall_bit_5,'1','0',clk,stall_bit_5_delayed);
    -- load_ret_PC <= '1' when stall_bit_5_delayed = 
    -- load_ret_PC <= stall_bit_5;

    fetch_stall <= stall_bit_2;

    wrong_prediction_hazard : wrong_prediction_unit port map (opcode_DE,prediction_bit,ZF,stall_bit_4);
    process(clk,stall_bit_5)
        begin
            if rising_edge(clk) then 
            if (stall_bit_5 = '1') then
                load_ret_PC <= '1';
            else
                load_ret_PC <= '0';
            end if;
            end if;
            
        end process;

end hazard_detection_unit_arch; 

