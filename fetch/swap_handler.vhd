library ieee;
use ieee.std_logic_1164.all;

entity swap_handler is
  port(opcode : in std_logic_vector(4 downto 0);
      swap_flag: in std_logic;
      wb_cs: in std_logic_vector(3 downto 0);
      val_sel, addr_sel: out std_logic_vector(1 downto 0));
end swap_handler;
 
architecture arch of swap_handler is
begin
    val_sel <= "10" when Opcode = "00111" and swap_flag = '1' else
            "11" when Opcode = "00111" and swap_flag = '0' else
            wb_cs(1 downto 0);
    
    addr_sel <= "01" when Opcode = "00111" and swap_flag = '1' else
            "10" when Opcode = "00111" and swap_flag = '0' else
            wb_cs(3 downto 2);

end architecture;