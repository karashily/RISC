library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
  port(opcode : in std_logic_vector(4 downto 0);
      clk, rst: in std_logic;
      ex_cs: out std_logic_vector(1 downto 0);
      mem_cs: out std_logic_vector(6 downto 0);
      wb_cs: out std_logic_vector(3 downto 0));
end control_unit;

architecture arch of control_unit is
  begin
    process(clk, rst)
      begin
        if(rst ='1') then
          ex_cs <= "00";
          mem_cs <= "0000000";
          wb_cs <= "0000";
        elsif rising_edge(clk) then
            -- ex
            -- out sel
            case opcode is
                when "01100" => ex_cs(0) <= '0';
                when others => ex_cs(0) <= '1';
            end case;
            -- alu operand 2
            case opcode is
                when "00010" | "00101" | "00110" => ex_cs(1) <= '1';
                when others => ex_cs(1) <= '0';
            end case;

            -- mem
            -- read/write
            case opcode is
                when "10000" | "10100" | "11011" => mem_cs(0) <= '1';
                when others => mem_cs(0) <= '0';
            end case;
            --val
            case opcode is
                when "11010" => mem_cs(2 downto 1) <= "01";
                when "10000" | "10100" => mem_cs(2 downto 1) <= "10";
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
            -- io/mem
            case opcode is
                when "01101" => mem_cs(6) <= '1';
                when others => mem_cs(6) <= '0';
            end case;
            
            -- wb
            -- val
            case opcode is
                when "01000" | "01100" | "10000" | "10100" => 
                    wb_cs(2 downto 0) <= "000";
                when "10001" | "10011" | "01101" => 
                    wb_cs(2 downto 0) <= "001";
                when "10010" => 
                    wb_cs(2 downto 0) <= "011";   
                when others => wb_cs(2 downto 0) <= "010";
            end case;
            --addr
            case opcode is
                when "00000" | "00001" | "00010" | "00011" | "00100" =>
                    wb_cs(3) <= '0';
                when others =>
                    wb_cs(3) <= '1';
            end case;
        end if;
    end process;
  end architecture;
