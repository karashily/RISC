library ieee;
use ieee.std_logic_1164.all;

entity wb is
  port(opcode : in std_logic_vector(4 downto 0);
      swap_flag: in std_logic;
      wb_cs: in std_logic_vector(3 downto 0);
      clk, rst: in std_logic;
      mem, exe, Rsrc1_val: in std_logic_vector(31 downto 0);
      Rdst_code, Rsrc1_code, Rsrc2_code: in std_logic_vector(2 downto 0);
      val_out: out std_logic_vector(31 downto 0);
      addr_out: out std_logic_vector(2 downto 0));
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
    swap: swap_handler port map(opcode, swap_flag, wb_cs, clk, rst, val_sel, addr_sel);
    process(clk, rst)
    begin
        case val_sel is
            when "01" => val_out <= mem;
            when "10" => val_out <= exe;
            when "11" => val_out <= Rsrc1_val;
            when others => val_out <= (others => 'Z');
        end case; 
        case addr_sel is
            when "01" => addr_out <= Rsrc1_code;
            when "10" => addr_out <= Rsrc2_code;
            when others => addr_out <= Rdst_code;
        end case;
    end process;
  end architecture;
