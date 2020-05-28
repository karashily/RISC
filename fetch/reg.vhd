library ieee;
use ieee.std_logic_1164.all;

entity reg is
    generic (n:integer := 32);
  port(d : in std_logic_vector(n-1 downto 0);
      clk, rst, load: in std_logic;
      q: out std_logic_vector(n-1 downto 0));
end reg;

architecture arch of reg is
  signal qq : std_logic_vector(n-1 DOWNTO 0);
  begin
    -- q <= qq;
    process(clk, rst)
      begin
        if(rst ='1') then
          q <= (others=>'0');
        elsif rising_edge(clk) and load = '1' then
          q <= d;
        end if;
    end process;
  end architecture;
