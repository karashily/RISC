library ieee;
use ieee.std_logic_1164.all;

entity id_ex is
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
end id_ex;

architecture arch of id_ex is
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
    ex_cs: reg generic map(3) port map(d=>ex_cs_in,clk=>clk,rst=>reset_in,load=>'1',q=>ex_cs_out);
    mem_cs: reg generic map(7) port map(d=>mem_cs_in,clk=>clk,rst=>reset_in,load=>'1',q=>mem_cs_out);
    wb_cs: reg generic map(4) port map(d=>wb_cs_in,clk=>clk,rst=>reset_in,load=>'1',q=>wb_cs_out);
    opcode: reg generic map(5) port map(d=>opcode_in,clk=>clk,rst=>reset_in,load=>'1',q=>opcode_out);
    src1_val: reg generic map(32) port map(d=>src1_val_in,clk=>clk,rst=>reset_in,load=>'1',q=>src1_val_out);
    src2_val: reg generic map(32) port map(d=>src2_val_in,clk=>clk,rst=>reset_in,load=>'1',q=>src2_val_out);
    src1_code: reg generic map(3) port map(d=>src1_code_in,clk=>clk,rst=>reset_in,load=>'1',q=>src1_code_out);
    src2_code: reg generic map(3) port map(d=>src2_code_in,clk=>clk,rst=>reset_in,load=>'1',q=>src2_code_out);
    dst_code: reg generic map(3) port map(d=>dst_code_in,clk=>clk,rst=>reset_in,load=>'1',q=>dst_code_out);
    extended_imm: reg generic map(32) port map(d=>extended_imm_in,clk=>clk,rst=>reset_in,load=>'1',q=>extended_imm_out);
    ea: reg generic map(20) port map(d=>ea_in,clk=>clk,rst=>reset_in,load=>'1',q=>ea_out);
    pc: reg generic map(32) port map(d=>pc_in,clk=>clk,rst=>reset_in,load=>'1',q=>pc_out);
    unpred_pc: reg generic map(32) port map(d=>unpred_pc_in,clk=>clk,rst=>reset_in,load=>'1',q=>unpred_pc_out);
    reset: onebitreg port map(d=>reset_in,clk=>clk,rst=>reset_in,load=>'1',q=>reset_out);
    intr: onebitreg port map(d=>intr_in,clk=>clk,rst=>reset_in,load=>'1',q=>intr_out);
end architecture;

