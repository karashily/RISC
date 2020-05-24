library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity RAM is
  port(
   RAM_CLOCK: in std_logic; 
   RAM_INS_ADDR: in std_logic_vector(10 downto 0);  
   RAM_DATA_ADDR: in std_logic_vector(10 downto 0);  
   RAM_DATA_WR: in std_logic;
   RAM_INS_WR: in std_logic; 
   RAM_INS_IN: in std_logic_vector(15 downto 0);
   RAM_INS_OUT: out std_logic_vector(15 downto 0);
   RAM_DATA_IN: in std_logic_vector(31 downto 0);
   RAM_DATA_OUT: out std_logic_vector(31 downto 0)
  );
end RAM;

architecture Behavioral of RAM is
type RAM_ARRAY is array (0 to 2047 ) of std_logic_vector (15 downto 0);
signal RAM: RAM_ARRAY :=(
                         0 => "0000000000000011",
                         4 => "0001000000011000", -- iadd r0,r6,16
                         5 => "0000000000010000", -- imm val
                         6 => "1101011000000000", -- call r6
                         7 => "0101000000000000", -- inc r0
                         8 => "0101000000000000", -- inc r0 
                         9 => "0101000100000000", -- inc r1
                         10 => "0101001000000000", -- inc r2
                         11 => "0101001100000000", -- inc r3
                         12 => "0101010000000000", -- inc r4
                         13 => "0101010100000000", -- inc r5
                         14 => "0101100100000000", -- dec r1
                         15 => "1100011000000000", -- jz 
                         16 => "0011100000000100", -- swap r0,r1
                         17 => "0101011100000000", -- inc r7
                         18 => "0101011100000000", -- inc r7
                         19 => "0101011100000000", -- inc r7
                         20 => "1101100000000000", -- ret 
                        --  14 => "0101000100000000", -- inc r1


                          others =>"0100000000000000"); 
signal read_data_1,read_data_2,read_ins : std_logic_vector(15 downto 0);

begin
process(RAM_CLOCK)is
begin
 if(rising_edge(RAM_CLOCK)) then
    if(RAM_DATA_WR='1') then  
      RAM(to_integer(unsigned(RAM_DATA_ADDR))) <= RAM_DATA_IN(15 downto 0);
      RAM(to_integer(unsigned(RAM_DATA_ADDR))-1) <= RAM_DATA_IN(31 downto 16);
    end if;
    if(RAM_INS_WR='1') then  
      RAM(to_integer(unsigned(RAM_INS_ADDR))) <= RAM_INS_IN;
    end if;

 end if;  

end process;

read_data_2 <= RAM(to_integer(unsigned(RAM_DATA_ADDR))) when RAM_DATA_ADDR /= "UUUUUUUUUUU" else (others => 'Z');
read_data_1 <= RAM(to_integer(unsigned(RAM_DATA_ADDR)) - 1) when RAM_DATA_ADDR /= "UUUUUUUUUUU" else (others => 'Z');

read_ins <=RAM(to_integer(unsigned(RAM_INS_ADDR))) when RAM_INS_ADDR /= "UUUUUUUUUUU" else "0100000000000000";

RAM_INS_OUT<=read_ins;
RAM_DATA_OUT<=read_data_2 & read_data_1;
end Behavioral;

