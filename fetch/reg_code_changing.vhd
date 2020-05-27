library ieee;
use ieee.std_logic_1164.all;

entity reg_code_changing is
  port(opcode : in std_logic_vector(4 downto 0);
      src1, src2, dst: in std_logic_vector(2 downto 0);
      flush: in std_logic;
      is_execute_changing: out std_logic;
      q: out std_logic_vector(1 downto 0));

end reg_code_changing;

architecture arch of reg_code_changing is
    -- src1 
    constant NOT_opcode: std_logic_vector(4 downto 0) := "01001";
    constant INC_opcode: std_logic_vector(4 downto 0) := "01010";
    constant DEC_opcode: std_logic_vector(4 downto 0) := "01011";
    constant IN_opcode: std_logic_vector(4 downto 0) := "01101";
    constant SWAP_opcode: std_logic_vector(4 downto 0) := "00111";
    constant SHL_opcode: std_logic_vector(4 downto 0) := "00101";
    constant SHR_opcode: std_logic_vector(4 downto 0) := "00110";

    -- dst
    constant ADD_opcode: std_logic_vector(4 downto 0) := "00000";
    constant SUB_opcode: std_logic_vector(4 downto 0) := "00001";
    constant IADD_opcode: std_logic_vector(4 downto 0) := "00010";
    constant AND_opcode: std_logic_vector(4 downto 0) := "00011";
    constant OR_opcode: std_logic_vector(4 downto 0) := "00100";

    signal qq: std_logic_vector(1 downto 0) := (others => '0');
    
                   

  begin
    -- src1
    qq <= "01" when(  (opcode = ADD_opcode) or
                    (opcode = SUB_opcode) or
                    (opcode = IADD_opcode) or
                    (opcode = AND_opcode) or
                    (opcode = OR_opcode))
                else "00" when((opcode = NOT_opcode) or
                   (opcode = INC_opcode) or
                   (opcode = DEC_opcode) or
                   (opcode = IN_opcode) or
                   ((opcode = SWAP_opcode) and (flush = '0')) or
                   (opcode = SHL_opcode) or
                   (opcode = SHR_opcode)) 
                else "11" when ((opcode = SWAP_opcode) and (flush = '1'));
    

    -- -- dst
    -- qq <= "01" when(  (opcode = ADD_opcode) or
    --                 (opcode = SUB_opcode) or
    --                 (opcode = IADD_opcode) or
    --                 (opcode = AND_opcode) or
    --                 (opcode = OR_opcode));

    -- -- src2
    -- qq <= "11" when ((opcode = SWAP_opcode) and (flush = '1'));

    q <= qq;

    is_execute_changing <= '1' when ((opcode = NOT_opcode) or
                                    (opcode = INC_opcode) or
                                    (opcode = DEC_opcode) or
                                    (opcode = IN_opcode) or
                                    (opcode = SWAP_opcode) or
                                    (opcode = SHL_opcode) or
                                    (opcode = SHR_opcode) or
                                    (opcode = ADD_opcode) or
                                    (opcode = SUB_opcode) or
                                    (opcode = IADD_opcode) or
                                    (opcode = AND_opcode) or
                                    (opcode = OR_opcode)
                                    ) else '0';

  end architecture;
