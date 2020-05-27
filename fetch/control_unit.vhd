library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
  port(opcode : in std_logic_vector(4 downto 0);
      clk, rst: in std_logic;
      swap_flag: out std_logic;
      ex_cs: out std_logic_vector(2 downto 0);
      mem_cs: out std_logic_vector(6 downto 0);
      wb_cs: out std_logic_vector(3 downto 0));
end control_unit;

architecture arch of control_unit is
    component register1 IS PORT(
        d   : IN STD_LOGIC;
        ld  : IN STD_LOGIC; -- load/enable.
        clr : IN STD_LOGIC; -- async. clear.
        clk : IN STD_LOGIC; -- clock.
        q   : OUT STD_LOGIC -- output.
    );
    END component;
    signal inner_swap_flag, swap_last_state: std_logic;
  begin
    inner_swap_flag <= '1' when swap_last_state = '0' and opcode = "00111" and rst = '0' else '0';
    swap_flag <= inner_swap_flag;
    swap: register1 port map(inner_swap_flag, '1', rst, clk, swap_last_state);
    
    process(clk, rst)
      begin
        if(rst ='1') then
          ex_cs <= "000";
          mem_cs <= "0000000";
          wb_cs <= "0000";
        elsif falling_edge(clk) then
            -- ex
            -- io/alu
            case opcode is
                when "01101" => ex_cs(0) <= '1';
                when others => ex_cs(0) <= '0';
            end case;
            -- out sel
            case opcode is
                when "01100" => ex_cs(1) <= '1';
                when others => ex_cs(1) <= '0';
            end case;
            -- alu operand 2
            case opcode is
                when "00010" | "00101" | "00110" => ex_cs(2) <= '1';
                when others => ex_cs(2) <= '0';
            end case;

            -- mem
            -- read/write
            case opcode is
                when "10000" | "10100" | "11010" => mem_cs(0) <= '1';
                when others => mem_cs(0) <= '0';
            end case;
            --val
            case opcode is
                when "10000" | "10100" => mem_cs(2 downto 1) <= "01";
                when "11010" => mem_cs(2 downto 1) <= "10";
                when others => mem_cs(2 downto 1) <= "00";
            end case;
            -- addr
            case opcode is
                when "10011" | "10100" => mem_cs(4 downto 3) <= "10";
                when "10000" | "10001" | "11010" | "11011" | "11100" => 
                    mem_cs(4 downto 3) <= "11";
                when others => mem_cs(4 downto 3) <= "00";
            end case;
            -- sp
            case opcode is
                when "10000" | "11010" => mem_cs(5) <= '1';
                when others => mem_cs(5) <= '0';
            end case;
            -- spload
            case opcode is
                when "10001" | "11011" | "11100" | "10000" | "11010" => 
                    mem_cs(6) <= '1';
                when others => mem_cs(6) <= '0';
            end case;
            
            -- wb
            -- val
            case opcode is
                when "10001" | "10011" => 
                    wb_cs(1 downto 0) <= "01";
                when "01001" | "01010" | "01011" | "01101" | "00111" | 
                        "00000" | "00001" | "00010" | "00011" | "00100" | 
                        "00101" | "00110" | "10010" => 
                    wb_cs(1 downto 0) <= "10";
                when others => wb_cs(1 downto 0) <= "00";
            end case;
            --addr
            case opcode is
                when "00000" | "00001" | "00010" | "00011" | "00100" =>
                    wb_cs(3 downto 2) <= "01";
                when others =>
                    wb_cs(3 downto 2) <= "00";
            end case;
        end if;
    end process;
  end architecture;
