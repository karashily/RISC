library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_hazard is
    port(
        A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
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
        prediction_bit: in std_logic;
        
        clk: in std_logic;
        result: out STD_LOGIC
      );
  end branch_hazard;

architecture branch_hazard_arch of branch_hazard is
    signal stall: std_logic;
    signal res: std_logic;
    signal clr: std_logic;

    signal current_opcode :std_logic;
    signal worrying_instr : std_logic;

    signal case1 : std_logic;
    signal case2 : std_logic;
    signal case3 : std_logic;

    signal two_op_instr : std_logic;
    signal one_op_instr : std_logic;

    

    constant jz_opcode : std_logic_vector(4 downto 0) := "11000";
    constant jmp_opcode : std_logic_vector(4 downto 0) := "11001";
    constant call_opcode : std_logic_vector(4 downto 0) := "11010";


    constant LDM_opcode : std_logic_vector(4 downto 0) := "10010";
    constant LDD_opcode : std_logic_vector(4 downto 0) := "10011";
    constant POP_opcode : std_logic_vector(4 downto 0) := "10001";




    constant ADD_opcode : std_logic_vector(4 downto 0) := "00000";
    constant SUB_opcode : std_logic_vector(4 downto 0) := "00001";
    constant IADD_opcode : std_logic_vector(4 downto 0) := "00010";
    constant AND_opcode : std_logic_vector(4 downto 0) := "00011";
    constant OR_opcode : std_logic_vector(4 downto 0) := "00100";
    constant SHL_opcode : std_logic_vector(4 downto 0) := "00101";
    constant SHR_opcode : std_logic_vector(4 downto 0) := "00110";
    constant SWAP_opcode : std_logic_vector(4 downto 0) := "00111";

    signal current_Rdst : std_logic_vector(2 downto 0);
    signal current_Rsrc_swap : std_logic_vector(2 downto 0);
    
    component register1 IS PORT(
        d   : IN STD_LOGIC;
        ld  : IN STD_LOGIC; -- load/enable.
        clr : IN STD_LOGIC; -- async. clear.
        clk : IN STD_LOGIC; -- clock.
        q   : OUT STD_LOGIC -- output.
    );
    END component;


begin
    -- third
    -- second
    -- first
    -- instr.

    current_opcode <= A(4 downto 0);

    worrying_instr <= '1' when ((current_opcode = jz_opcode) and prediction_bit = '1')
    or (current_opcode = jmp_opcode)
    or (current_opcode = call_opcode)
    else '0';

    current_Rdst <= A(7 downto 5);
    case1 <= (current_Rdst = Rdst_FD_code) and ()










    current_Rdst <= A(13 downto 11) when (current_opcode = ADD_opcode
                                         or current_opcode = SUB_opcode
                                         or current_opcode = IADD_opcode
                                         or current_opcode = AND_opcode
                                         or current_opcode = OR_opcode)
                                    else A(7 downto 5) when 
                                         (current_opcode = SHL_opcode
                                         or current_opcode = SHR_opcode
                                         or current_opcode = SWAP_opcode)
                                         or (current_opcode(1 downto 0) = "01" and not(current_opcode = "01000"))
                                         or current_opcode = LDM_opcode
                                         or current_opcode = LDD_opcode
                                         or current_opcode = POP_opcode)
                                    else "000";                                   
                                         
    current_Rsrc_swap <= A(10 downto 8);
                
    case1 <= '1' when 
             ((opcode_FD(1 downto 0) = "00"
             or (opcode_FD(1 downto 0) = "01" and not(opcode_FD = "01000"))
             or opcode_FD = LDM_opcode
             or opcode_FD = LDD_opcode
             or opcode_FD = POP_opcode)
             and (current_Rdst = Rdst_FD_code))
            else '0';

    case2 <= '1' when 
             ((opcode_DE = LDM_opcode
             or opcode_DE = LDD_opcode
             or opcode_DE = POP_opcode)
             and (current_Rdst = Rdst_DE_code))
            else '0';
    
    case3 <= '1' when
             (opcode_FD = SWAP_opcode and (current_Rsrc_swap = Rdst_FD_code)) or
             (opcode_DE = SWAP_opcode and (current_Rsrc_swap = Rdst_DE_code)) or
             (opcode_EM = SWAP_opcode and (current_Rsrc_swap = Rdst_EM_code))
        else '0';




    u0 : register1 port map (stall,'1','0',clk,res);

   

end branch_hazard_arch; 

