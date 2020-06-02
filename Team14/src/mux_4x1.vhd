library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity mux4_1 is
  generic (N : integer := 32);
  port(
 
  A,B,C,D : in STD_LOGIC_VECTOR (N-1 downto 0);
  S0,S1: in STD_LOGIC;
  Z: out STD_LOGIC_VECTOR (N-1 downto 0)
  );
end mux4_1;
 
architecture Behavioral of mux4_1 is
component mux2_1
    generic (N : integer := 32);
    Port ( A   : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B   : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SEL : in  STD_LOGIC;
           X   : out STD_LOGIC_VECTOR (N-1 downto 0));
end component;
signal temp1, temp2: STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
 
begin
-- m1: mux2_1  generic map (N   => N) port map(A,B,S0,temp1);
-- m2: mux2_1  generic map (N   => N) port map(C,D,S0,temp2);
-- m3: mux2_1  generic map (N   => N) port map(temp1,temp2,S1,Z);
Z <= A when (S0 = '0' and S1 = '0') else
     B when (S0 = '1' and S1 = '0') else
     C when (S0 = '0' and S1 = '1') else
     D;
 
end Behavioral;

