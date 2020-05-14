library ieee;
use ieee.std_logic_1164.all;

entity onebitreg is
  port(d : in std_logic;
      clk, rst, load: in std_logic;
      q: out std_logic);
end onebitreg;

architecture arch of onebitreg is
  begin
    process(clk, rst)
      begin
        if(rst ='1') then
          q <= '0';
        elsif rising_edge(clk) and load = '1' then
          q <= d;
        end if;
    end process;
  end architecture;

