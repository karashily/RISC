library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity memo_stage is
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
end memo_stage;

architecture arch of memo_stage is
  
  
  component mux2_1 is
    generic (N : integer);
    Port ( A   : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B   : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SEL : in  STD_LOGIC;
           X   : out STD_LOGIC_VECTOR (N-1 downto 0));
  end component;
  
  component mux4_1 is
  generic (N : integer);
  port(
 
  A,B,C,D : in STD_LOGIC_VECTOR (N-1 downto 0);
  S0,S1: in STD_LOGIC;
  Z: out STD_LOGIC_VECTOR (N-1 downto 0)
  );
  end component;
  
  component RAM is
  port(
   RAM_CLOCK: in std_logic; 
   RAM_INS_ADDR: in std_logic_vector(10 downto 0);  
   RAM_DATA_ADDR: in std_logic_vector(10 downto 0);  
   RAM_DATA_WR: in std_logic;
   RAM_INS_WR: in std_logic; 
   RAM_INS_IN: in std_logic_vector(15 downto 0);
   RAM_INS_OUT: out std_logic_vector(15 downto 0);
   RAM_DATA_IN: in std_logic_vector(31 downto 0);
   RAM_DATA_OUT: out std_logic_vector(31 downto 0)
  );
  end component;
  
  component small_alu is
    generic (n:integer := 32);
  port(d : in std_logic_vector(n-1 downto 0);
      clk, rst, control: in std_logic;
      q: out std_logic_vector(n-1 downto 0));
  end component;
  
  component reg is
    generic (n:integer := 32);
  port(d : in std_logic_vector(n-1 downto 0);
      clk, rst, load: in std_logic;
      q: out std_logic_vector(n-1 downto 0));
  end component;

  component handler is
  port(
      clk, rst, intr_mem, intr_wb: in std_logic;
      mem_control_signal :in std_logic_vector (6 downto 0);
      rd_wr_sel ,sp_load ,sp_alu: out std_logic;
      val_sel , add_sel: out std_logic_vector(1 downto 0));
  end component;
  
  --Handeler signals 
  signal rd_wr_sel_s,sp_load_s,sp_alu_s : std_logic;
  signal val_sel_s,add_sel_s : std_logic_vector(1 downto 0);
  
  --Value mux signals 
  signal val_out_s :std_logic_vector(31 downto 0);
  
   --Address mux signals 
  signal add_out_s :std_logic_vector(10 downto 0);
  
   --SP mux signals 
  signal sp_out_s :std_logic_vector(10 downto 0);
  signal sp_in_s :std_logic_vector(10 downto 0);
  signal sp_mux_out_s :std_logic_vector(10 downto 0);
  
  begin
     h: handler port map (clk => clk , rst=> rst, intr_mem=>intr_mem , intr_wb=> intr_wb,
      mem_control_signal => memo_control_signals,
      rd_wr_sel=>  rd_wr_sel_s,sp_load=>  sp_load_s,sp_alu=> sp_alu_s,
      val_sel => val_sel_s, add_sel=> add_sel_s);
      
     mux_val:mux4_1 generic map(N=> 32) port map (A  =>(others=>'Z') ,B  => Rsrc ,C  => pc,D => pc_flags,
      S0  => val_sel_s(0),S1 => val_sel_s(1), Z => val_out_s );
      
     mux_add:mux4_1 generic map(N=> 11) port map (A  =>"00000000001" ,B  => "00000000011",C  => EA,D => sp_mux_out_s,
      S0  =>add_sel_s(0) ,S1 =>add_sel_s(1) , Z => add_out_s);
      
     sp:reg  generic map (N=> 11) port map(d =>sp_in_s , clk => clk, rst=>rst , load =>sp_load_s , q => sp_out_s);
      
     alu:small_alu generic map(N=> 11) port map(d =>sp_out_s , clk => clk, rst => rst, control => sp_alu_s, q => sp_in_s);
       
     mux_sp:mux2_1 generic map (N => 11) Port map ( A => sp_in_s,B => sp_out_s, SEL =>sp_alu_s , X => sp_mux_out_s);
       
     r:RAM port map(RAM_CLOCK => clk, 
      RAM_INS_ADDR => RAM_INS_ADDR,
      RAM_DATA_ADDR => add_out_s, 
      RAM_DATA_WR => rd_wr_sel_s,
      RAM_INS_WR => RAM_INS_WR,
      RAM_INS_IN => RAM_INS_IN,
      RAM_INS_OUT => RAM_INS_OUT,
      RAM_DATA_IN => val_out_s,
      RAM_DATA_OUT => mem_out);
   
  end architecture;