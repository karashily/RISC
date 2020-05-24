library ieee;
use ieee.std_logic_1164.all;

entity wb is
  port(opcode : in std_logic_vector(4 downto 0);
      swap_flag, intr, reset: in std_logic;
      wb_cs: in std_logic_vector(3 downto 0);
      clk: in std_logic;
      mem, exe, Rsrc1_val: in std_logic_vector(31 downto 0);
      Rdst_code, Rsrc1_code, Rsrc2_code: in std_logic_vector(2 downto 0);
      wb_en: out std_logic;
      val_out: out std_logic_vector(31 downto 0);
      addr_out: out std_logic_vector(2 downto 0);
      mem_out: out std_logic_vector(31 downto 0));
end wb;
 
architecture arch of wb is
    component swap_handler is
        port(opcode : in std_logic_vector(4 downto 0);
            swap_flag: in std_logic;
            wb_cs: in std_logic_vector(3 downto 0);
            val_sel, addr_sel: out std_logic_vector(1 downto 0));
      end component;

      signal val_sel, addr_sel : std_logic_vector(1 downto 0);
  begin
    mem_out <= mem;
    
    swap: swap_handler port map(opcode, swap_flag, wb_cs, val_sel, addr_sel);
    
    val_out <= mem when val_sel = "01" else
            exe when val_sel = "10" else
            Rsrc1_val when val_sel = "11" else
            (others => 'Z');
    
    wb_en <= '1' when val_sel = "01" or val_sel = "10" or val_sel = "11" else '0';
    
    addr_out <= Rdst_code when addr_sel = "01" else
            Rsrc2_code when addr_sel = "10" else
            Rsrc1_code;
  end architecture;
