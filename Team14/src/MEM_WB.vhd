library ieee;
use ieee.std_logic_1164.all;

entity mem_wb is
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
end mem_wb;

architecture arch of mem_wb is
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
 
    wb_cs: reg generic map(4) port map(d=>wb_cs_in,clk=>clk,rst=>'0',load=>'1',q=>wb_cs_out);
    opcode: reg generic map(5) port map(d=>opcode_in,clk=>clk,rst=>'0',load=>'1',q=>opcode_out);
    mem_result:reg generic map(32) port map(d=>mem_result_in,clk=>clk,rst=>'0',load=>'1',q=>mem_result_out);
	ex_result:reg generic map(32) port map(d=>exe_in,clk=>clk,rst=>'0',load=>'1',q=>exe_out);
	src_val:reg generic map(32) port map(d=>src1_val,clk=>clk,rst=>'0',load=>'1',q=>src1_val_out);
	src1_code: reg generic map(3) port map(d=>src1_code_in,clk=>clk,rst=>'0',load=>'1',q=>src1_code_out);
    src2_code: reg generic map(3) port map(d=>src2_code_in,clk=>clk,rst=>'0',load=>'1',q=>src2_code_out);
    dst_code: reg generic map(3) port map(d=>dst_code_in,clk=>clk,rst=>'0',load=>'1',q=>dst_code_out);
    reset: onebitreg port map(d=>reset_wb_in,clk=>clk,rst=>'0',load=>'1',q=>reset_wb_out);
    intr: onebitreg port map(d=>intr_wb_in,clk=>clk,rst=>'0',load=>'1',q=>intr_wb_out);
	sf: onebitreg port map(d=>swap_flag_in,clk=>clk,rst=>'0',load=>'1',q=>swap_flag_out);
    
end architecture;



