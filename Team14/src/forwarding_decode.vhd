library ieee;
use ieee.std_logic_1164.all;

entity forwarding_decode is
  port(Rsrc1_val, mem_out, exe_out: in std_logic_vector(31 downto 0);
        Rsrc1_code, Rsrc2_code, Rdst_code: in std_logic_vector(2 downto 0);
        wb_cs: in std_logic_vector(3 downto 0);
        val_out: out std_logic_vector(31 downto 0);
        reg_out: out std_logic_vector(2 downto 0);
        en_out: out std_logic);
end forwarding_decode;
 
architecture arch of forwarding_decode is
signal val_sel, addr_sel: std_logic_vector(1 downto 0);
begin
   val_sel <= wb_cs(1 downto 0);
   addr_sel <= wb_cs(3 downto 2);
   
   en_out <= '0' when val_sel = "00" else '1';
   
   val_out <= mem_out when val_sel = "01" else
            exe_out when val_sel = "10" else
            Rsrc1_val when val_sel = "11" else
            (others => 'Z');
            
    reg_out <= Rsrc1_code when addr_sel = "00" else
            Rdst_code when addr_sel = "01" else
            Rsrc2_code;
end architecture;

