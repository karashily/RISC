library ieee;
use ieee.std_logic_1164.all;

entity mimic_forward is
  port(regcode : in std_logic_vector(2 downto 0);
      reg : out std_logic_vector(31 downto 0));
end mimic_forward;

architecture mimic_forward_arch of mimic_forward is
  begin
    reg <= "00000000000000000000000000000100";
  end architecture;