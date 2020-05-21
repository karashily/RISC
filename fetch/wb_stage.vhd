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
            clk, rst: in std_logic;
            val_sel, addr_sel: out std_logic_vector(1 downto 0));
      end component;

      signal val_sel, addr_sel : std_logic_vector(1 downto 0);
  begin
    mem_out <= mem;
    swap: swap_handler port map(opcode, swap_flag, wb_cs, clk, reset, val_sel, addr_sel);
    process(clk)
    begin
        case val_sel is
            when "01" => val_out <= mem; wb_en <= '1';
            when "10" => val_out <= exe; wb_en <= '1';
            when "11" => val_out <= Rsrc1_val; wb_en <= '1';
            when others => val_out <= (others => 'Z'); wb_en <= '0';
        end case;
        case addr_sel is
            when "01" => addr_out <= Rsrc1_code;
            when "10" => addr_out <= Rsrc2_code;
            when others => addr_out <= Rdst_code;
        end case;
    end process;
  end architecture;
