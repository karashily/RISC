library ieee;
use ieee.std_logic_1164.all;

entity mimic_forward is
  port(regcode : in std_logic_vector(2 downto 0);
      reg : out std_logic_vector(31 downto 0);
      --codes to compare
      exec_src1,exec_src2,exec_dst: in std_logic_vector(2 downto 0);
      mem_src: in std_logic_vector(2 downto 0);
      wb_src: in std_logic_vector(2 downto 0);
      src1_exec_value,src2_exec_value,exec_dst_value,mem_value,wb_value,reg_file_value:IN std_logic_vector(31 downto 0);
      src1_dec,src2_dec,dst_dec:in  std_logic_vector(2 downto 0);
      regcode_in_decode: out std_logic;

      opcode_in_decode:in std_logic_vector(4 downto 0);
      csFlush:in std_logic
      );
end mimic_forward;

architecture mimic_forward_arch of mimic_forward is
  begin
    reg <=src1_exec_value when( regcode=exec_src1 ) 
    else src2_exec_value when( regcode=exec_src2 )
    else mem_value when (regcode=mem_src )
    else wb_value when (  regcode=wb_src ) 
    else exec_dst_value when (regcode=exec_dst)
    else reg_file_value ;
    regcode_in_decode<='1' when (regcode=src1_dec and (opcode_in_decode="01001" or opcode_in_decode="01010" 
    or opcode_in_decode="01011" or opcode_in_decode="01101" or opcode_in_decode="00111" or opcode_in_decode="00101"
    or opcode_in_decode="00110" or opcode_in_decode="10001" or opcode_in_decode="10010" or opcode_in_decode="10011"))
    else '1' when (regcode=src2_dec and opcode_in_decode="00111" and csFlush='1')
    else '1' when (regcode=dst_dec and (opcode_in_decode="00000" or opcode_in_decode="00001" or opcode_in_decode="00010"
    or opcode_in_decode="00011" or opcode_in_decode="00100") )
    else '0';
  end architecture;