library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity small_alu is
    generic (n:integer := 32);
  port(d : in std_logic_vector(n-1 downto 0);
      clk, rst, control: in std_logic;
      q: out std_logic_vector(n-1 downto 0));
end small_alu;

architecture arch of small_alu is
  
  signal result:std_logic_vector(n-1 downto 0);
  begin
    process(clk,control,rst)
      begin
        if(rst ='1') then
          result <= d;
        else
          if (control = '1')then
            result <= std_logic_vector( unsigned(d) - 2 );
          else 
            result <= std_logic_vector( unsigned(d) + 2 );
          end if;
        end if;
    end process;
    q <= result;
  end architecture;
