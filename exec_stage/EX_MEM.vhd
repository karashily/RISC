library ieee;
use ieee.std_logic_1164.all;

entity ex_mem is
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
        ea_in : in std_logic_vector(19 downto 0);
	intr_mem_in : in std_logic;
	reset_mem_in : in std_logic;
        pc_in : in std_logic_vector(31 downto 0);
        unpred_pc_in : in std_logic_vector(31 downto 0);
        -- out
        mem_cs_out : out std_logic_vector(6 downto 0);
        wb_cs_out : out std_logic_vector(3 downto 0);
        opcode_out : out std_logic_vector(4 downto 0);
	flags_out:out std_logic_vector(3 downto 0);
	output_out:out std_logic_vector(31 downto 0);
        src1_code_out : out std_logic_vector(2 downto 0);
        src2_code_out : out std_logic_vector(2 downto 0);
        dst_code_out : out std_logic_vector(2 downto 0);
        ea_out : out std_logic_vector(19 downto 0);
	intr_mem_out : out std_logic;
	reset_mem_out : out std_logic;
        pc_out : out std_logic_vector(31 downto 0);
        unpred_pc_out : out std_logic_vector(31 downto 0)
      );
end ex_mem;

architecture arch of ex_mem is
component reg is
    generic (n:integer := 32);
    port(d : in std_logic_vector(n-1 downto 0);
        clk, rst, load: in std_logic;
        q: out std_logic_vector(n-1 downto 0));
end component;

component onebitreg is
    port(d : in std_logic;
        clk, rst, load: in std_logic;
        q: out std_logic);
end component;

begin
    mem_cs: reg generic map(7) port map(d=>mem_cs_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>mem_cs_out);
    wb_cs: reg generic map(4) port map(d=>wb_cs_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>wb_cs_out);
    opcode: reg generic map(5) port map(d=>opcode_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>opcode_out);
    flags:reg generic map(4) port map(d=>flags_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>flags_out);
	output: reg generic map(32) port map(d=>output_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>output_out);
	src1_code: reg generic map(3) port map(d=>src1_code_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>src1_code_out);
    src2_code: reg generic map(3) port map(d=>src2_code_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>src2_code_out);
    dst_code: reg generic map(3) port map(d=>dst_code_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>dst_code_out);
    ea: reg generic map(20) port map(d=>ea_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>ea_out);
    reset: onebitreg port map(d=>reset_mem_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>reset_mem_out);
    intr: onebitreg port map(d=>intr_mem_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>intr_mem_out);
	pc: reg generic map(32) port map(d=>pc_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>pc_out);
    unpred_pc: reg generic map(32) port map(d=>unpred_pc_in,clk=>clk,rst=>reset_mem_in,load=>'1',q=>unpred_pc_out);
    
end architecture;

