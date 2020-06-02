library ieee;
use ieee.std_logic_1164.all;

entity sp is
    generic (n:integer := 32);
  port(d : in std_logic_vector(n-1 downto 0);
      clk, rst, load: in std_logic;
      q: out std_logic_vector(n-1 downto 0));
end sp;

architecture arch of sp is
  signal qq : std_logic_vector(n-1 DOWNTO 0) := (others => '1');
  begin
    q <= qq;
    process(clk, rst, load)
      begin
        if(rst ='1') then
          qq <= (others=>'1');
        elsif rising_edge(clk) and load = '1' then
          qq <= d;
        end if;
    end process;
  end architecture;

