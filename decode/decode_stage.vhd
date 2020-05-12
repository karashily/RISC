library ieee;
use ieee.std_logic_1164.all;

entity dec is
  port( clk, rst: std_logic;
      ir: in std_logic_vector(31 downto 0);
      PC_in: in std_logic_vector(31 downto 0);
      wb_val: in std_logic_vector(31 downto 0);
      wb_addr: in std_logic_vector(2 downto 0);
      src1_code, src2_code, dst_code: out std_logic_vector(2 downto 0);
      Rsrc1_val, Rsrc2_val, extended_imm: out std_logic_vector(31 downto 0);
      ea: out std_logic_vector (19 downto 0);
      ex_cs: out std_logic_vector(2 downto 0);
      mem_cs: out std_logic_vector(6 downto 0);
      wb_cs: out std_logic_vector(3 downto 0);
      PC_out: out std_logic_vector(31 downto 0);
      opcode: out std_logic_vector(4 downto 0));
end dec;
 
architecture arch of dec is
    component regfile is
        port(src1, src2, write_reg: in std_logic_vector(2 downto 0);
            write_val: in std_logic_vector(31 downto 0);
            rst, clk: in std_logic;
            src1_val, src2_val: out std_logic_vector(31 downto 0));
    end component;

    component control_unit is
        port(opcode : in std_logic_vector(4 downto 0);
            clk, rst: in std_logic;
            ex_cs: out std_logic_vector(2 downto 0);
            mem_cs: out std_logic_vector(6 downto 0);
            wb_cs: out std_logic_vector(3 downto 0));
      end component;
begin
    regs: regfile port map(src1 => ir(26 downto 24),
        src2 => ir(23 downto 21),
        write_reg => wb_addr,
        write_val => wb_val,
        rst => rst,
        clk => clk,
        src1_val => Rsrc1_val, 
        src2_val => Rsrc2_val);

    cu: control_unit port map(opcode => ir(31 downto 27),
        clk => clk,
        rst => rst,
        ex_cs => ex_cs,
        mem_cs => mem_cs, 
        wb_cs => wb_cs);

    process(clk, rst)
    begin
        if rst = '1' then
            src1_code <= (others => '0');
            src2_code <= (others => '0');
            dst_code <= (others => '0');
            Rsrc1_val <= (others => '0');
            Rsrc2_val <= (others => '0');
            extended_imm <= (others => '0');
            ea <= (others => '0');
            ex_cs <= (others => '0');
            mem_cs <= (others => '0');
            wb_cs <= (others => '0');
            PC_out <= (others => '0');
            opcode <= (others => '0');
        elsif(falling_edge(clk)) then
            opcode <= ir(31 downto 27);
            src1_code <= ir(26 downto 24);
            src2_code <= ir(23 downto 21);
            dst_code <= ir(20 downto 18);
            extended_imm (15 downto 0) <= ir(15 downto 0);
            extended_imm (31 downto 16) <= (others => ir(15));
            ea <= ir(19 downto 0);
            PC_out <= PC_in;
        end if;
    end process;
end architecture;
