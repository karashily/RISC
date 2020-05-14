library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_1 is
    generic (N : integer := 32);
    Port ( A   : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B   : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SEL : in  STD_LOGIC;
           X   : out STD_LOGIC_VECTOR (N-1 downto 0));
end mux2_1;

architecture Behavioral of mux2_1 is
begin
    X <= A when (SEL = '0') else B;
end Behavioral;
