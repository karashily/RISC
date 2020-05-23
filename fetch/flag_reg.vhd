library ieee;  
use ieee.std_logic_1164.all;  
 
entity flag_Register is  
  port(C,PRE,RST : in std_logic;  
        D : in  std_logic_vector (3 downto 0);  
        Q : out std_logic_vector (3 downto 0));  
end flag_Register; 
architecture flag_arch of flag_Register is  
  begin  
    process (C, PRE)  
      begin  
        if (PRE='1') then  
          Q <= "1111";
        elsif (RST='1') then  
          Q <= "0000"; 
        elsif (rising_edge(c))then
            Q <= D;   
        end if;  
    end process;  
end flag_arch; 
