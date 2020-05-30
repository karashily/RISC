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
  0 => "0000000000010000",
  1 => "0000000000000000",
  2 => "0000000100000000",
  3 => "0000000000000000",
  4 => "0100000000000000",
  5 => "0100000000000000",
  6 => "0100000000000000",
  7 => "0100000000000000",
  8 => "0100000000000000",
  9 => "0100000000000000",
  10 => "0100000000000000",
  11 => "0100000000000000",
  12 => "0100000000000000",
  13 => "0100000000000000",
  14 => "0100000000000000",
  15 => "0100000000000000",
  16 => "0110101000000000",
  17 => "0110101100000000",
  18 => "0110110000000000",
  19 => "1001000100000000",
  20 => "0000000011110101",
  21 => "1000000100000000",
  22 => "1000001000000000",
  23 => "1000100100000000",
  24 => "1000101000000000",
  25 => "1010001000000000",
  26 => "0000001000000000",
  27 => "1010000100000000",
  28 => "0000001000000010",
  29 => "1001101100000000",
  30 => "0000001000000010",
  31 => "1001110000000000",
  32 => "0000001000000000",
  others => "0100000000000000"
 
  ); 
signal read_data_1,read_data_2,read_ins : std_logic_vector(15 downto 0);

begin
process(RAM_CLOCK)is
begin
 if(rising_edge(RAM_CLOCK)) then
    if(RAM_DATA_WR='1') then  
      RAM(to_integer(unsigned(RAM_DATA_ADDR))-1) <= RAM_DATA_IN(15 downto 0);
      RAM(to_integer(unsigned(RAM_DATA_ADDR))) <= RAM_DATA_IN(31 downto 16);
    end if;
    if(RAM_INS_WR='1') then  
      RAM(to_integer(unsigned(RAM_INS_ADDR))) <= RAM_INS_IN;
    end if;

 end if;  

end process;

read_data_2 <= RAM(to_integer(unsigned(RAM_DATA_ADDR))) when RAM_DATA_ADDR /= "UUUUUUUUUUU" else (others => 'Z');
-- ezzzzzaaaaat
read_data_1 <= RAM(to_integer(unsigned(RAM_DATA_ADDR)) - 1) when RAM_DATA_ADDR /= "UUUUUUUUUUU" and RAM_DATA_ADDR /= "00000000000" else (others => 'Z');

read_ins <=RAM(to_integer(unsigned(RAM_INS_ADDR))) when RAM_INS_ADDR /= "UUUUUUUUUUU" else "0100000000000000";

RAM_INS_OUT<=read_ins;
RAM_DATA_OUT<=read_data_2 & read_data_1;
end Behavioral;

