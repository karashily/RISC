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
        RESET_DE: in STD_LOGIC;
        regCode_in_dec: in STD_LOGIC;
        regcode_in_exec:in std_logic;
        ex_instr_flushed: in std_logic;

        
        -- outputs
        wrong_prediction_bit: out STD_LOGIC;
        load_ret_PC: out STD_LOGIC;
        load_ret_PC_int: out STD_LOGIC;
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
    signal stall_bit_5_delayed_delayed: std_logic := '0';
    signal stall_bit_6: std_logic := '0';
    signal stall_bit_6_delayed: std_logic := '0';
    signal stall_bit_6_delayed_delayed: std_logic := '0';
    signal stall_bit_7: std_logic := '0';
    signal stall_bit_8: std_logic := '0';
    signal stall_bit_8_bef: std_logic := '0';
    signal reset_stall_pc: std_logic := '0';
    signal reset_stall_control: std_logic := '0';
    signal int_stall_pc: std_logic := '0';
    signal int_stall_control: std_logic := '0';
    signal ret_rti_stall_pc: std_logic := '0';
    signal ret_rti_stall_control: std_logic := '0';


    signal reg_exec_en: std_logic := '0';

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
        RESET_DE: in std_logic;
        clk: in std_logic;

        output: out std_logic
        );
    END  component;

    component wrong_prediction_unit is
        port(opcode_DE : in std_logic_vector(4 downto 0);
              prediction_bit : in std_logic;
              ZF : in std_logic;
              ex_instr_flushed: in std_logic;
            q: out std_logic);
    end component;

    component  prediction_in_decode_unit IS PORT(
        A: in std_logic_vector(15 downto 0);
        regCode_in_dec: in std_logic;
        clk: in std_logic;
        reset: in std_logic;
        output: out std_logic
    );
    END  component;

    component  swap_unit IS PORT(
        A: in std_logic_vector(15 downto 0);
        opcode_FD: in std_logic_vector(4 downto 0);
        clk: in std_logic;
    
        output: out std_logic
    );
    END component;

    component register1 IS PORT(
    d   : IN STD_LOGIC;
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC -- output.
    );
    END component;

    component  RESET_unit IS PORT(
        RESET: in std_logic;
        RESET_DE: in std_logic;
        clk: in std_logic;
        output_pc: out std_logic;
        output_control: out std_logic
        );
    END  component;

    component  INT_unit IS PORT(
        INT: in std_logic;
        INT_EM: in std_logic;
        clk: in std_logic;
        output_pc: out std_logic;
        output_control: out std_logic
        );
    END  component;

    component  RTI_RET_unit IS PORT(
        A: in std_logic_vector(15 downto 0);
        opcode_DE: in std_logic_vector(4 downto 0);
        clk: in std_logic;
        output_pc: out std_logic;
        output_control: out std_logic);
    END  component;

begin

    reg_exec_en <= '1' when (A(15 downto 11) = "11000" or A(15 downto 11) = "11001" or A(15 downto 11) = "11010") and stall_bit_2 = '0' else '0';

    PC_write <= not( 
                stall_bit_1 or 
                stall_bit_3 or 
                -- stall_bit_5 or 
                stall_bit_6 or 
                stall_bit_7 or
                stall_bit_8_bef or 
                (regcode_in_exec and reg_exec_en) or
                reset_stall_pc or
                int_stall_pc or
                ret_rti_stall_pc
                );
    
    control_unit_mux <= stall_bit_1 or 
                        stall_bit_2 or 
                        stall_bit_3 or 
                        stall_bit_4 or 
                        -- stall_bit_5_delayed or 
                        stall_bit_6_delayed_delayed or 
                        stall_bit_7 or
                        stall_bit_8 or
                        reset_stall_control or 
                        int_stall_control or
                        ret_rti_stall_control
                        ;

    wrong_prediction_bit <= stall_bit_4;

    long_fetch_hazard : fetch_hazard port map (A,clk,reset,stall_bit_2);
    -- RET_RTI_RESET_INT_hazard : RET_RTI_RESET_INT_unit port map (A,opcode_EM,INT,INT_EM,RESET,RESET_DE,clk,stall_bit_5);
    reset_reg: register1 port map (stall_bit_5,'1','0',clk,stall_bit_5_delayed);
    reset_reg_2: register1 port map (stall_bit_5_delayed,'1','0',clk,stall_bit_5_delayed_delayed);
    -- load_ret_PC <= '1' when stall_bit_5_delayed = 
    -- load_ret_PC <= stall_bit_5;
    prediction_still_in_decode_hazard: prediction_in_decode_unit port map (A,regCode_in_dec,clk,RESET,stall_bit_8_bef);
    reg_delay_stall_bit_8: register1 port map (stall_bit_8_bef,'1',reset,clk,stall_bit_8);

    fetch_stall <= stall_bit_2;

    wrong_prediction_hazard : wrong_prediction_unit port map (opcode_DE,prediction_bit,ZF,ex_instr_flushed,stall_bit_4);
    swap_hazard: swap_unit port map (A,opcode_FD,clk,stall_bit_6);
    swap_reg: register1 port map (stall_bit_6,'1','0',clk,stall_bit_6_delayed);
    swap_reg_2: register1 port map (stall_bit_6_delayed,'1','0',clk,stall_bit_6_delayed_delayed);

    -- reset
    reset_hazard: RESET_unit port map (RESET,RESET_DE,clk,reset_stall_pc,reset_stall_control);
    interrupt_hazard: INT_unit port map (INT,INT_EM,clk,int_stall_pc,int_stall_control);
    rti_ret_hazard: RTI_RET_unit port map (A,opcode_DE,clk,ret_rti_stall_pc,ret_rti_stall_control);


    process(clk,stall_bit_5)
        begin
            if rising_edge(clk) then 
                if (reset_stall_pc = '1'  or int_stall_pc = '1' or ret_rti_stall_pc = '1' ) then
                    load_ret_PC <= '1';
                else
                    load_ret_PC <= '0';
                end if;

                if (int_stall_pc = '1')then
                    load_ret_PC_int <= '1';
                else
                    load_ret_PC_int <= '0';

                end if;
            end if;
            
        end process;

end hazard_detection_unit_arch; 

