library ieee;
use ieee.std_logic_1164.all;

entity swap_handler is
  port(opcode : in std_logic_vector(4 downto 0);
      swap_flag: in std_logic;
      wb_cs: in std_logic_vector(3 downto 0);
      clk, rst: in std_logic;
      val_sel, addr_sel: out std_logic_vector(1 downto 0));
end swap_handler;
 
architecture arch of swap_handler is
  begin
    process(clk, rst)
    begin
        if(rst ='1') then
            val_sel <= "00";
            addr_sel <= "00";
        elsif rising_edge(clk) then
            If Opcode = "00111" and swap_flag = '1' then
                val_sel <= "10";
                addr_sel <= "01";
            elsif opcode = "00111" and swap_flag = '0' then
                val_sel <= "11";
                addr_sel <= "10";
            else
                val_sel <= wb_cs(1 downto 0);
                addr_sel <= wb_cs(3 downto 2);  
            end if;
        end if;
    end process;
  end architecture;
