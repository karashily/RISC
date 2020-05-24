library ieee;
use ieee.std_logic_1164.all;

entity mimic_forward is
  port(regcode : in std_logic_vector(2 downto 0);
      reg : out std_logic_vector(31 downto 0);
      --codes to compare
      src1_SEL,src2_SEL:in std_logic_vector(1 downto 0);
      exec_src1,exec_src2: in std_logic_vector(2 downto 0);
      src1_exec_value,src2_exec_value,src1_mem_value,src2_mem_value,src1_wb_value,src2_wb_value,reg_file_value:IN std_logic_vector(31 downto 0)
      );
end mimic_forward;

architecture mimic_forward_arch of mimic_forward is
  begin
    reg <=src1_exec_value when(src1_SEL="00" and regcode=exec_src1 ) 
    else src2_exec_value when(src2_SEL="00" and regcode=exec_src2 )
    else src1_mem_value when (src1_SEL="01" and regcode=exec_src1 )
    else src2_mem_value when(src2_SEL="01" and regcode=exec_src2 )
    else src1_wb_value when (src1_SEL="10" and regcode=exec_src1 ) 
    else src2_wb_value when (src2_SEL="10" and regcode=exec_src2 )
    else reg_file_value ;
  end architecture;