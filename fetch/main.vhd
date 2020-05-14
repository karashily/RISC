library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY main IS PORT(
    A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
    clk: in std_logic;
    reset: in std_logic;
    int: in std_logic


);
END main;

ARCHITECTURE main_arch OF main IS
signal prediction_bit : std_logic;
signal Rdst_val: std_logic_vector(31 downto 0);
signal PC_flags_mem: std_logic_vector(31 downto 0);
signal unpredicted_PC_E: std_logic_vector(31 downto 0);
signal load_ret_PC: std_logic := '0';
signal wrong_prediction_bit: std_logic := '0';
signal PC_load: std_logic;
signal PC: std_logic_vector(31 downto 0);
signal opcode_FD: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal opcode_DE: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal opcode_EM: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal opcode_MW: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal Rdst_FD_code: STD_LOGIC_VECTOR (2 DOWNTO 0);
signal Rdst_DE_code: STD_LOGIC_VECTOR (2 DOWNTO 0);
signal Rdst_EM_code: STD_LOGIC_VECTOR (2 DOWNTO 0);
signal Rdst_MW_code: STD_LOGIC_VECTOR (2 DOWNTO 0);
signal Rsrc1_DE_code: STD_LOGIC_VECTOR (2 DOWNTO 0);
signal Rsrc1_EM_code: STD_LOGIC_VECTOR (2 DOWNTO 0);
signal Rsrc1_MW_code: STD_LOGIC_VECTOR (2 DOWNTO 0);
signal Rsrc2_DE_code: STD_LOGIC_VECTOR (2 DOWNTO 0);
signal ZF: STD_LOGIC;
signal INT_EM: STD_LOGIC;
signal RESET_EM: STD_LOGIC;
signal control_unit_mux: STD_LOGIC;
signal fetch_stall: STD_LOGIC;


signal IR: std_logic_vector(31 downto 0) := (others => '0');


-- signals for memory 
signal memo_control_signals : std_logic_vector(6 downto 0);
signal intr_mem: std_logic;
signal intr_wb : std_logic;
signal pc_reg : std_logic_vector(31 downto 0);
signal pc_flags : std_logic_vector(31 downto 0);
signal Rsrc : std_logic_vector(31 downto 0);
signal EA : std_logic_vector(10 downto 0);
signal RAM_INS_ADDR: std_logic_vector(10 downto 0);
signal RAM_INS_WR: std_logic := '0';
signal RAM_INS_IN: std_logic_vector(15 downto 0) := (others => '0');
signal RAM_INS_OUT: std_logic_vector(15 downto 0 ) := (others => '0');
signal mem_out : std_logic_vector(31 downto 0 ) := (others => '0');



constant zeros : std_logic_vector(15 downto 0) := (others => '0');

-- signals for pipeline registers
signal FDRegOut:  std_logic_vector(63 downto 0) :=  (others => '0');
signal FDRegIn:  std_logic_vector(63 downto 0) :=  (others => '0');


component fetch is
    port(
        A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
        clk: in std_logic;
        reset: in std_logic;
        Rdst_val: in std_logic_vector(31 downto 0);
        PC_flags_mem: in std_logic_vector(31 downto 0);
        unpredicted_PC_E: in std_logic_vector(31 downto 0);
        load_ret_PC: in std_logic;
        wrong_prediction_bit: in std_logic;
        PC_load: in std_logic;

        prediction_bit_out: out std_logic;
        PC_to_fetch: out std_logic_vector(31 downto 0)
      );
end component;

component hazard_detection_unit is
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
end component;

component memo_stage is
  port(
    clk ,rst :in std_logic;
    memo_control_signals : in std_logic_vector(6 downto 0);
    intr_mem ,intr_wb :in std_logic;
    pc ,pc_flags, Rsrc : in std_logic_vector(31 downto 0);
    EA : in std_logic_vector(10 downto 0);
    RAM_INS_ADDR: in std_logic_vector(10 downto 0);
    RAM_INS_WR:in std_logic;
    RAM_INS_IN:in std_logic_vector(15 downto 0);
    RAM_INS_OUT:out std_logic_vector(15 downto 0 );
    mem_out :out std_logic_vector(31 downto 0 )
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

BEGIN
  fetch_component: fetch port map (A,clk,reset,Rdst_val,PC_flags_mem,unpredicted_PC_E,load_ret_PC,wrong_prediction_bit,PC_load,prediction_bit,PC);
  hazard_unit: hazard_detection_unit port map (A,
                                               clk,
                                               reset,
                                               prediction_bit,
                                               opcode_FD,
                                               opcode_DE,
                                               opcode_EM,
                                               opcode_MW,
                                               Rdst_FD_code,
                                               Rdst_DE_code,
                                               Rdst_EM_code,
                                               Rdst_MW_code,
                                               Rsrc1_DE_code,
                                               Rsrc1_EM_code,
                                               Rsrc1_MW_code,
                                               Rsrc2_DE_code,
                                               ZF,
                                               INT,
                                               INT_EM,
                                               RESET_EM,
                                               wrong_prediction_bit,
                                               load_ret_PC,
                                               PC_load,
                                               control_unit_mux,
                                               fetch_stall
                                               );


  RAM_INS_ADDR <= PC(10 downto 0); 
  memory: memo_stage port map (clk,reset,memo_control_signals,intr_mem,intr_wb,pc_reg,pc_flags,Rsrc,EA,RAM_INS_ADDR,RAM_INS_WR,RAM_INS_IN,RAM_INS_OUT,mem_out);
  IR <= (RAM_INS_OUT & zeros) when fetch_stall = '0' else (FDRegOut(15 downto 0) & RAM_INS_OUT);
  FDRegIn <= IR & PC;
  FDReg: regi generic map (64) port map (FDRegIn, '1',reset,clk,FDRegOut);
END main_arch;