library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY main IS 
GENERIC (n : integer := 32);
PORT(
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
signal pc_flags : std_logic_vector(31 downto 0);
signal RAM_INS_ADDR: std_logic_vector(10 downto 0);
signal RAM_INS_WR: std_logic := '0';
signal RAM_INS_IN: std_logic_vector(15 downto 0) := (others => '0');
signal RAM_INS_OUT: std_logic_vector(15 downto 0 ) := (others => '0');
signal mem_out : std_logic_vector(31 downto 0 ) := (others => '0');



constant zeros : std_logic_vector(15 downto 0) := (others => '0');


-- signals for pipeline registers
signal FDRegOut:  std_logic_vector(97 downto 0) :=  (others => '0');
signal FD_unpred_pc_out: std_logic_vector(31 downto 0) := (others => '0');
signal FD_pc_out, FD_ir_out : std_logic_vector(31 downto 0) := (others => '0');
signal FD_rst_out, FD_intr_out : std_logic := '0';
signal FDRegIn:  std_logic_vector(97 downto 0) :=  (others => '0');
signal unpred_pc : std_logic_vector(31 downto 0) := (others => '0');

-- signal between decode and id_ex
signal dec_src1_code, dec_src2_code, dec_dst_code: std_logic_vector(2 downto 0);
signal dec_Rsrc1_val, dec_Rsrc2_val, dec_extended_imm: std_logic_vector(31 downto 0);
signal dec_ea: std_logic_vector (19 downto 0);
signal dec_ex_cs: std_logic_vector(2 downto 0);
signal dec_mem_cs: std_logic_vector(6 downto 0);
signal dec_wb_cs: std_logic_vector(3 downto 0);
signal dec_PC_out: std_logic_vector(31 downto 0);
signal dec_unpred_PC_out: std_logic_vector(31 downto 0);
signal dec_opcode: std_logic_vector(4 downto 0);
signal dec_rst_out, dec_intr_out: std_logic;

-- id_ex signals
signal idex_ex_cs_out : std_logic_vector(2 downto 0);
signal idex_mem_cs_out : std_logic_vector(6 downto 0);
signal idex_wb_cs_out : std_logic_vector(3 downto 0);
signal idex_opcode_out : std_logic_vector(4 downto 0);
signal idex_src1_val_out : std_logic_vector(31 downto 0);
signal idex_src2_val_out : std_logic_vector(31 downto 0);
signal idex_src1_code_out : std_logic_vector(2 downto 0);
signal idex_src2_code_out : std_logic_vector(2 downto 0);
signal idex_dst_code_out : std_logic_vector(2 downto 0);
signal idex_extended_imm_out : std_logic_vector(31 downto 0);
signal idex_ea_out : std_logic_vector(19 downto 0);
signal idex_pc_out : std_logic_vector(31 downto 0);
signal idex_unpred_pc_out : std_logic_vector(31 downto 0);
signal idex_reset_out : std_logic;
signal idex_intr_out : std_logic;
--ex_mem register input signals
signal  ex_mem_flags_in: std_logic_vector(3 downto 0);
signal	ex_mem_output_in: std_logic_vector(31 downto 0);
signal  ex_mem_src1_code_in :  std_logic_vector(2 downto 0);
signal  ex_mem_src2_code_in :  std_logic_vector(2 downto 0);
signal  ex_mem_dst_code_in :  std_logic_vector(2 downto 0);
signal  ex_mem_ea_in :  std_logic_vector(19 downto 0);
signal	ex_mem_intr_mem_in :  std_logic;
signal	ex_mem_reset_mem_in :  std_logic;
signal  ex_mem_pc_in :  std_logic_vector(31 downto 0);
signal  ex_mem_unpred_pc_in :  std_logic_vector(31 downto 0);
signal flag_reg_out:std_logic_vector(3 downto 0);
signal flag_reg_in:std_logic_vector(3 downto 0);
signal ex_flag_reg_out:std_logic_vector(3 downto 0);
signal ex_swap_flag_in: std_logic;
signal ex_src1_value_in: std_logic_vector(31 downto 0);
--ex_mem register out signals
 signal ex_mem_cs_out :  std_logic_vector(6 downto 0);
 signal ex_wb_cs_out :  std_logic_vector(3 downto 0);
 signal ex_opcode_out :  std_logic_vector(4 downto 0);
 signal ex_flags_out: std_logic_vector(3 downto 0);
 signal ex_output_out: std_logic_vector(31 downto 0);
 signal ex_src1_code_out :  std_logic_vector(2 downto 0);
 signal ex_src2_code_out :  std_logic_vector(2 downto 0);
 signal ex_dst_code_out :  std_logic_vector(2 downto 0);
 signal ex_mem_extended_imm_out:std_logic_vector(31 downto 0);
 signal ex_ea_out :  std_logic_vector(19 downto 0);
 signal ex_intr_mem_out :  std_logic;
 signal ex_reset_mem_out :  std_logic;
 signal ex_pc_out :  std_logic_vector(31 downto 0);
 signal ex_unpred_pc_out :  std_logic_vector(31 downto 0);
 signal ex_swap_flag_out: std_logic;
 signal ex_src1_value_out: std_logic_vector(31 downto 0);

--mem_wb register out signals
 signal mem_wb_cs_out : std_logic_vector(3 downto 0);
 signal mem_opcode_out : std_logic_vector(4 downto 0);
 signal mem_result_out : std_logic_vector(31 downto 0);
 signal mem_exe_out : std_logic_vector(31 downto 0);
 signal mem_src_val_out : std_logic_vector(31 downto 0);
 signal mem_src1_code_out : std_logic_vector(2 downto 0);
 signal mem_src2_code_out : std_logic_vector(2 downto 0);
 signal mem_dst_code_out : std_logic_vector(2 downto 0);   
 signal mem_swap_flag_out : std_logic;
 signal mem_intr_wb_out : std_logic;
 signal mem_reset_wb_out : std_logic;

-- wb out signals
signal wb_val_out : std_logic_vector(31 downto 0) := (others=>'0');
signal wb_addr_out : std_logic_vector(2 downto 0) := (others=>'0');
--WB outputs needed by excute
signal WB_src1_val_out :  std_logic_vector(31 downto 0);
signal WB_src2_val_out :  std_logic_vector(31 downto 0);
--mem outputs needed by excute
signal mem_src1_val_out :  std_logic_vector(31 downto 0);
signal mem_src2_val_out :  std_logic_vector(31 downto 0);


--excute signals
 signal IO_IN: std_logic_vector(n-1 downto 0);
signal  IO_OUT:  std_logic_vector(n-1 downto 0);
signal ALU_output_selector: std_logic;
signal IO_output_selector:std_logic;
signal ForwardUnit_src1_sel,ForwardUnit_src2_sel:std_logic_vector(1 downto 0);
signal src1_sel,src2_sel:std_logic;
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


component excute is 
GENERIC (n : integer := 32);
	PORT(clk:std_logic;
			 Rsrc1,Rsrc2,imm,Rsrc1_mem,Rsrc2_mem,Rsrc1_WB,Rsrc2_WB: IN std_logic_vector(n-1 downto 0);
			 opcode_in: IN std_logic_vector(4 downto 0);
			 IO_IN:IN std_logic_vector(n-1 downto 0);
			 IO_OUT: OUT std_logic_vector(n-1 downto 0);
			 OUT_SEL:IN std_logic;
			 IO_ALU_SEL:IN std_logic;
			 Rsrc2_sel:IN std_logic;       -- 0=rsrc2    1 = imm
			 Rsrc1_sel_forward,Rsrc2_sel_forward:IN std_logic_vector(1 downto 0); -- 00 = src value  01=mem value  10=wb value
			 Rst:IN std_logic;
			 flag_reg_in:IN std_logic_vector(3 downto 0);
			 flag_reg_out:OUT std_logic_vector(3 downto 0);
       ALU_OUTPUT: INOUT  std_logic_vector(n-1 downto 0);
       swap_flag:OUT std_logic;
       Rsrc1_value:OUT std_logic_vector(n-1 downto 0)
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

--memory stage
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

component dec is
  port( clk, rst_in, rst_out, intr_in, intr_out: std_logic;
      ir: in std_logic_vector(31 downto 0);
      PC_in: in std_logic_vector(31 downto 0);
      Unpred_PC_in: in std_logic_vector(31 downto 0);
      wb_val: in std_logic_vector(31 downto 0);
      wb_addr: in std_logic_vector(2 downto 0);
      src1_code, src2_code, dst_code: out std_logic_vector(2 downto 0);
      Rsrc1_val, Rsrc2_val, extended_imm: out std_logic_vector(31 downto 0);
      ea: out std_logic_vector (19 downto 0);
      ex_cs: out std_logic_vector(2 downto 0);
      mem_cs: out std_logic_vector(6 downto 0);
      wb_cs: out std_logic_vector(3 downto 0);
      PC_out: out std_logic_vector(31 downto 0);
      unpred_PC_out: out std_logic_vector(31 downto 0);
      opcode: out std_logic_vector(4 downto 0));
end component;

component id_ex is
  port(clk: in std_logic;
        -- in
        ex_cs_in : in std_logic_vector(2 downto 0);
        mem_cs_in : in std_logic_vector(6 downto 0);
        wb_cs_in : in std_logic_vector(3 downto 0);
        opcode_in : in std_logic_vector(4 downto 0);
        src1_val_in : in std_logic_vector(31 downto 0);
        src2_val_in : in std_logic_vector(31 downto 0);
        src1_code_in : in std_logic_vector(2 downto 0);
        src2_code_in : in std_logic_vector(2 downto 0);
        dst_code_in : in std_logic_vector(2 downto 0);
        extended_imm_in : in std_logic_vector(31 downto 0);
        ea_in : in std_logic_vector(19 downto 0);
        pc_in : in std_logic_vector(31 downto 0);
        unpred_pc_in : in std_logic_vector(31 downto 0);
        reset_in : in std_logic;
        intr_in : in std_logic;
        -- out
        ex_cs_out : out std_logic_vector(2 downto 0);
        mem_cs_out : out std_logic_vector(6 downto 0);
        wb_cs_out : out std_logic_vector(3 downto 0);
        opcode_out : out std_logic_vector(4 downto 0);
        src1_val_out : out std_logic_vector(31 downto 0);
        src2_val_out : out std_logic_vector(31 downto 0);
        src1_code_out : out std_logic_vector(2 downto 0);
        src2_code_out : out std_logic_vector(2 downto 0);
        dst_code_out : out std_logic_vector(2 downto 0);
        extended_imm_out : out std_logic_vector(31 downto 0);
        ea_out : out std_logic_vector(19 downto 0);
        pc_out : out std_logic_vector(31 downto 0);
        unpred_pc_out : out std_logic_vector(31 downto 0);
        reset_out : out std_logic;
        intr_out : out std_logic
      );
end component;
component flagRegster is
port(C,PRE,RST : in std_logic;  
        D : in  std_logic_vector (3 downto 0);  
        Q : out std_logic_vector (3 downto 0));  
end component;


component ex_mem is
	port(clk: in std_logic;
  -- in
  mem_cs_in : in std_logic_vector(6 downto 0);
  wb_cs_in : in std_logic_vector(3 downto 0);
  opcode_in : in std_logic_vector(4 downto 0);
  flags_in:in std_logic_vector(3 downto 0);
  output_in:in std_logic_vector(31 downto 0);
  src1_code_in : in std_logic_vector(2 downto 0);
  src2_code_in : in std_logic_vector(2 downto 0);
  dst_code_in : in std_logic_vector(2 downto 0);
  extended_imm_in:out std_logic_vector (31 downto 0);
  ea_in : in std_logic_vector(19 downto 0);
  intr_mem_in : in std_logic;
  reset_mem_in : in std_logic;
  pc_in : in std_logic_vector(31 downto 0);
  unpred_pc_in : in std_logic_vector(31 downto 0);
  swap_flag_in:in std_logic;
  src1_value_in:in std_logic_vector(31 downto 0);
  -- out
  mem_cs_out : out std_logic_vector(6 downto 0);
  wb_cs_out : out std_logic_vector(3 downto 0);
  opcode_out : out std_logic_vector(4 downto 0);
  flags_out:out std_logic_vector(3 downto 0);
  output_out:out std_logic_vector(31 downto 0);
  src1_code_out : out std_logic_vector(2 downto 0);
  src2_code_out : out std_logic_vector(2 downto 0);
  dst_code_out : out std_logic_vector(2 downto 0);
  extended_imm_out:out std_logic_vector (31 downto 0);
  ea_out : out std_logic_vector(19 downto 0);
  intr_mem_out : out std_logic;
  reset_mem_out : out std_logic;
  pc_out : out std_logic_vector(31 downto 0);
  unpred_pc_out : out std_logic_vector(31 downto 0);
  swap_flag_out:out std_logic;
  src1_value_out:out std_logic_vector(31 downto 0)
		  );
end component;

component mem_wb is
  port(clk: in std_logic;
        -- in
        wb_cs_in : in std_logic_vector(3 downto 0);
        opcode_in : in std_logic_vector(4 downto 0);
	      mem_result_in :in std_logic_vector(31 downto 0);
	      exe_in :in std_logic_vector(31 downto 0);
	      src1_val :in std_logic_vector(31 downto 0);
        src1_code_in : in std_logic_vector(2 downto 0);
        src2_code_in : in std_logic_vector(2 downto 0);
        dst_code_in : in std_logic_vector(2 downto 0);   
	      swap_flag_in : in std_logic;
        intr_wb_in : in std_logic;
        reset_wb_in : in std_logic;
         
        -- out
        wb_cs_out : out std_logic_vector(3 downto 0);
        opcode_out : out std_logic_vector(4 downto 0);
	      mem_result_out :out std_logic_vector(31 downto 0);
	      exe_out :out std_logic_vector(31 downto 0);
	      src1_val_out :out std_logic_vector(31 downto 0);
        src1_code_out : out std_logic_vector(2 downto 0);
        src2_code_out : out std_logic_vector(2 downto 0);
        dst_code_out : out std_logic_vector(2 downto 0);   
	      swap_flag_out : out std_logic;
        intr_wb_out : out std_logic;
        reset_wb_out : out std_logic
    );
end component;

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
  
    IR <= (RAM_INS_OUT & zeros) when fetch_stall = '0' else (FDRegOut(15 downto 0) & RAM_INS_OUT);
  FDRegIn <= int & reset & unpred_pc & IR & PC;
  FDReg: regi generic map (98) port map (FDRegIn, '1',reset,clk,FDRegOut);
  
  FD_pc_out <= FDRegout(31 downto 0);
  FD_ir_out <= FDRegout(63 downto 32);
  --FD_unpred_pc_out <= FDRegout(95 downto 64);
  --FD_rst_out <= FDRegout(96);
  --FD_intr_out <= FDRegout(97);


  decode_stage: dec port map(clk, FD_rst_out, dec_rst_out, FD_intr_out, dec_intr_out, FD_IR_out, FD_PC_out, FD_Unpred_PC_out, wb_val_out, wb_addr_out,
    dec_src1_code, dec_src2_code, dec_dst_code, dec_Rsrc1_val, dec_Rsrc2_val, dec_extended_imm, dec_ea, 
    dec_ex_cs, dec_mem_cs, dec_wb_cs, dec_PC_out, dec_unpred_PC_out, dec_opcode);

  idex: id_ex port map(clk, dec_ex_cs, dec_mem_cs, dec_wb_cs,
    dec_opcode, dec_Rsrc1_val, dec_Rsrc2_val, 
    dec_src1_code, dec_src2_code, dec_dst_code,
    dec_extended_imm, dec_ea, dec_pc_out, dec_unpred_pc_out,
    dec_rst_out, dec_intr_out,
    idex_ex_cs_out, idex_mem_cs_out, idex_wb_cs_out,
    idex_opcode_out, idex_src1_val_out, idex_src2_val_out,
    idex_src1_code_out, idex_src2_code_out, idex_dst_code_out,
    idex_extended_imm_out, idex_ea_out,
    idex_pc_out, idex_unpred_pc_out,
    idex_reset_out, idex_intr_out);


  flag_reg: flagRegster port map( clk,'0',reset,flag_reg_out,flag_reg_in) ;
  
  ZF<=flag_reg_out(0);
  
  execution_stage: excute generic map (32) port map(clk,idex_src1_val_out,idex_src2_val_out,
  idex_extended_imm_out,mem_src1_val_out,mem_src2_val_out,WB_src1_val_out,WB_src2_val_out,
  idex_opcode_out,IO_IN,IO_OUT,ALU_output_selector,IO_output_selector,
  src2_sel,ForwardUnit_src1_sel,ForwardUnit_src2_sel,reset,flag_reg_in,flag_reg_out,ex_mem_output_in,ex_swap_flag_in,ex_src1_value_in);



EX_MEM_REG:ex_mem port map (clk,idex_mem_cs_out,idex_wb_cs_out,
idex_opcode_out,flag_reg_in,ex_mem_output_in,idex_src1_code_out,
idex_src2_code_out,idex_dst_code_out,idex_extended_imm_out,idex_ea_out,
idex_intr_out,idex_reset_out,idex_pc_out,idex_unpred_pc_out,
ex_swap_flag_in,ex_src1_value_in,
ex_mem_cs_out,ex_wb_cs_out,ex_opcode_out,ex_flag_reg_out,ex_output_out,
ex_src1_code_out,ex_src2_code_out,ex_dst_code_out,ex_mem_extended_imm_out,ex_ea_out,ex_intr_mem_out,
ex_reset_mem_out,ex_pc_out,ex_unpred_pc_out,
ex_swap_flag_out,ex_src1_value_out
);
 
pc_flags <= ex_flag_reg_out & ex_pc_out(27 downto 0);

 memory: memo_stage port map (clk,ex_reset_mem_out,ex_mem_cs_out,ex_intr_mem_out,mem_intr_wb_out,ex_pc_out,pc_flags,ex_src1_value_out,ex_ea_out(10 downto 0),RAM_INS_ADDR,RAM_INS_WR,RAM_INS_IN,RAM_INS_OUT,mem_out);

 MEM_WB_REG: mem_wb port map(clk => clk ,
        -- in
        wb_cs_in => ex_wb_cs_out,
        opcode_in => ex_opcode_out,
	      mem_result_in => mem_out,
	      exe_in => ex_output_out,
	      src1_val => ex_src1_value_out,
        src1_code_in => ex_src1_code_out,
        src2_code_in => ex_src2_code_out,
        dst_code_in => ex_dst_code_out,
	      swap_flag_in =>ex_swap_flag_out,
        intr_wb_in => ex_intr_mem_out,
        reset_wb_in => ex_reset_mem_out,
         
        -- out
        wb_cs_out => mem_wb_cs_out,
        opcode_out => mem_opcode_out,
	      mem_result_out => mem_result_out,
	      exe_out => mem_exe_out,
	      src1_val_out => mem_src_val_out,
        src1_code_out => mem_src1_code_out,
        src2_code_out => mem_src2_code_out,
        dst_code_out => mem_dst_code_out,
	      swap_flag_out => mem_swap_flag_out,
        intr_wb_out => mem_intr_wb_out,
        reset_wb_out => mem_reset_wb_out
    );
	
END main_arch;