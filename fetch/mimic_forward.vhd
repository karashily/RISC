library ieee;
use ieee.std_logic_1164.all;

entity mimic_forward is
  port(regcode : in std_logic_vector(2 downto 0);
      reg : out std_logic_vector(31 downto 0);
      --codes to compare
      
      exec_src1,exec_src2: in std_logic_vector(2 downto 0);
      mem_src: in std_logic_vector(2 downto 0);
      wb_src: in std_logic_vector(2 downto 0);
      src1_exec_value,src2_exec_value,mem_value,wb_value,reg_file_value:IN std_logic_vector(31 downto 0)
      );
end mimic_forward;

architecture mimic_forward_arch of mimic_forward is
  begin
    reg <=src1_exec_value when( regcode=exec_src1 ) 
    else src2_exec_value when( regcode=exec_src2 )
    else mem_value when (regcode=mem_src )
    else wb_value when (  regcode=wb_src ) 
    else reg_file_value ;
  end architecture;