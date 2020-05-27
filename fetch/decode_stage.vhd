library ieee;
use ieee.std_logic_1164.all;

entity dec is
  port( clk, cs_flush, write_en, rst_in, reset_mem, intr_in : in std_logic;
      rst_out, intr_out: out std_logic;
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
      opcode: out std_logic_vector(4 downto 0);
      branch_regcode: in std_logic_vector(2 downto 0);
      branch_val: out std_logic_vector(31 downto 0);
      swap_flag: out std_logic);
end dec;
 
architecture arch of dec is
    component regfile is
        port(src1, src2, write_reg: in std_logic_vector(2 downto 0);
            write_val: in std_logic_vector(31 downto 0);
            write_en: in std_logic;
            rst, clk: in std_logic;
            src1_val, src2_val: out std_logic_vector(31 downto 0);
            branch_regcode: in std_logic_vector(2 downto 0);
            branch_val: out std_logic_vector(31 downto 0));
    end component;

    component control_unit is
        port(opcode : in std_logic_vector(4 downto 0);
            clk, rst: in std_logic;
            swap_flag: out std_logic;
            ex_cs: out std_logic_vector(2 downto 0);
            mem_cs: out std_logic_vector(6 downto 0);
            wb_cs: out std_logic_vector(3 downto 0));
      end component;

    signal clk_bar : std_logic:='0';

    signal cu_ex_cs: std_logic_vector(2 downto 0);
    signal cu_mem_cs: std_logic_vector(6 downto 0);
    signal cu_wb_cs: std_logic_vector(3 downto 0);
    signal cu_swap_flag: std_logic;

    signal regfile_rst : std_logic;
begin
    regfile_rst <= '1' when (rst_in = '1' or reset_mem = '1') else '0';
    clk_bar <= not clk;
    regs: regfile port map(src1 => ir(26 downto 24),
        src2 => ir(23 downto 21),
        write_reg => wb_addr,
        write_val => wb_val,
        write_en => write_en,
        rst => regfile_rst,
        clk => clk,
        src1_val => Rsrc1_val, 
        src2_val => Rsrc2_val,
        branch_regcode => branch_regcode,
        branch_val => branch_val);

    cu: control_unit port map(opcode => ir(31 downto 27),
        clk => clk,
        rst => rst_in,
        swap_flag => cu_swap_flag,
        ex_cs => cu_ex_cs,
        mem_cs => cu_mem_cs, 
        wb_cs => cu_wb_cs);

    PC_out <= PC_in;
    unpred_pc_out <= unpred_pc_in;
    rst_out <= rst_in;
    intr_out <= intr_in;

    ex_cs <= cu_ex_cs when cs_flush = '0' else (others=>'0');
    mem_cs <= cu_mem_cs when cs_flush = '0' else (others=>'0');
    wb_cs <= cu_wb_cs when cs_flush = '0' else (others=>'0');
    swap_flag <= cu_swap_flag when cs_flush = '0' else '0';
   
    process(clk)
    begin
        if(falling_edge(clk)) then
            opcode <= ir(31 downto 27);
            src1_code <= ir(26 downto 24);
            src2_code <= ir(23 downto 21);
            dst_code <= ir(20 downto 18);
            extended_imm (15 downto 0) <= ir(15 downto 0);
            extended_imm (31 downto 16) <= (others => ir(15));
            ea <= ir(19 downto 0);
            
        end if;
    end process;
end architecture;
