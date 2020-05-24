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
      regcode_in_decode: out std_logic
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
    regcode_in_decode<='1' when (regcode=src1_dec or regcode=src2_dec or regcode=dst_dec) else '0';
  end architecture;