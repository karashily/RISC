library ieee;
use ieee.std_logic_1164.all;

entity forward_unit is
  port(clk, rst: std_logic;
        src1_exec_code,src2_exec_code:in std_logic_vector(2 downto 0);
        --mem signals
        mem_Rsrc1_val, mem_mem_out, mem_exe_out: in std_logic_vector(31 downto 0);
        mem_Rsrc1_code, mem_Rsrc2_code, mem_Rdst_code: in std_logic_vector(2 downto 0);
        mem_wb_cs: in std_logic_vector(3 downto 0);
        mem_swap_flag: in std_logic;
        mem_opcode: in std_logic_vector(4 downto 0);
        
        --wb signals
        wb_Rsrc1_val, wb_mem_out, wb_exe_out: in std_logic_vector(31 downto 0);
        wb_Rsrc1_code, wb_Rsrc2_code, wb_Rdst_code: in std_logic_vector(2 downto 0);
        wb_wb_cs: in std_logic_vector(3 downto 0);
        wb_swap_flag: in std_logic;
        wb_opcode: in std_logic_vector(4 downto 0);
        --output
        src1_SEL,src2_SEL:OUT std_logic_vector(1 downto 0);
        mem_value, wb_value:OUT std_logic_vector(31 downto 0);
        --mimic unit outputs
        mem_reg:out std_logic_vector(2 downto 0);
        wb_reg:out std_logic_vector(2 downto 0)
       
        
        );
end forward_unit;
 
architecture arch of forward_unit is

component forwarding_decode is
    port(Rsrc1_val, mem_out, exe_out: in std_logic_vector(31 downto 0);
            Rsrc1_code, Rsrc2_code, Rdst_code: in std_logic_vector(2 downto 0);
            wb_cs: in std_logic_vector(3 downto 0);
            val_out: out std_logic_vector(31 downto 0);
            reg_out: out std_logic_vector(2 downto 0);
            en_out: out std_logic);
end component;

component swap_handler is
    port(opcode : in std_logic_vector(4 downto 0);
      swap_flag: in std_logic;
      wb_cs: in std_logic_vector(3 downto 0);
      val_sel, addr_sel: out std_logic_vector(1 downto 0));
end component;

component forwarding_unit IS
PORT(Rsrc1_exc,Rsrc2_exc,Rdest_mem,Rdest_WB: IN std_logic_vector(2 downto 0);
         src1_SEL,src2_SEL:OUT std_logic_vector(1 downto 0);
         enable_mem:in std_logic;
		 enable_wb: in std_logic;
		 mem_swap_flag:in std_logic
	     ); 
END component forwarding_unit;
--mem
signal mem_handled_wb_cs: std_logic_vector(3 downto 0);
signal mem_reg_out: std_logic_vector(2 downto 0);
signal mem_en_out: std_logic;

--wb
signal wb_handled_wb_cs: std_logic_vector(3 downto 0);
signal wb_reg_out: std_logic_vector(2 downto 0);
signal wb_en_out: std_logic;

signal enable_logic_mem:std_logic;
signal enable_logic_wb:std_logic;

begin

    mem_reg<=mem_reg_out;
    wb_reg<=wb_reg_out;
    enable_logic_mem<=mem_wb_cs(3) or mem_wb_cs(2) or mem_wb_cs(1) or mem_wb_cs(0) or( wb_swap_flag and (not (mem_swap_flag)));
    enable_logic_wb<=wb_wb_cs(3)or wb_wb_cs(2) or wb_wb_cs(1) or wb_wb_cs(0) or wb_swap_flag ;

    mem_swap_handler: swap_handler port map(opcode => mem_opcode,
            swap_flag => mem_swap_flag,
            wb_cs => mem_wb_cs,
            val_sel => mem_handled_wb_cs(1 downto 0), addr_sel => mem_handled_wb_cs(3 downto 2));
    

    mem_dec: forwarding_decode port map(Rsrc1_val => mem_Rsrc1_val, mem_out => mem_mem_out, exe_out => mem_exe_out,
                Rsrc1_code => mem_Rsrc1_code, Rsrc2_code => mem_Rsrc2_code, Rdst_code => mem_Rdst_code,
                wb_cs => mem_handled_wb_cs,
                val_out => mem_value,
                reg_out => mem_reg_out,
                en_out => mem_en_out);

    
    wb_swap_handler: swap_handler port map(opcode => wb_opcode,
                swap_flag => wb_swap_flag,
                wb_cs => wb_wb_cs,
                val_sel => wb_handled_wb_cs(1 downto 0), addr_sel => wb_handled_wb_cs(3 downto 2));
        
    
    wb_dec: forwarding_decode port map(Rsrc1_val => wb_Rsrc1_val, mem_out => wb_mem_out, exe_out => wb_exe_out,
                Rsrc1_code => wb_Rsrc1_code, Rsrc2_code => wb_Rsrc2_code, Rdst_code => wb_Rdst_code,
                wb_cs => wb_handled_wb_cs,
                val_out => wb_value,
                reg_out => wb_reg_out,
                en_out => wb_en_out);

    forwarding_logic:forwarding_unit port map (
        src1_exec_code,src2_exec_code,mem_reg_out,wb_reg_out,
        src1_SEL,src2_SEL,enable_logic_mem,enable_logic_wb,mem_swap_flag

    );

end architecture;

