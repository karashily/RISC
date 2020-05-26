LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 
USE ieee.std_logic_misc.all;
ENTITY forwarding_unit IS
PORT(	 Rsrc1_exc,Rsrc2_exc,Rdest_mem,Rdest_WB: IN std_logic_vector(2 downto 0);
		 src1_SEL,src2_SEL:OUT std_logic_vector(1 downto 0);
		 enable_mem:std_logic;
		 enable_wb:std_logic
	     ); 
END ENTITY forwarding_unit;
ARCHITECTURE forwarding_unit_arch OF forwarding_unit IS
begin
src1_SEL<="00" when (Rsrc1_exc /=Rdest_mem and Rsrc1_exc /=Rdest_WB )
else "01" when (Rsrc1_exc = Rdest_mem and enable_mem='1'   )
else "10" when (Rsrc1_exc = Rdest_WB and enable_wb='1'  )
else "00";
src2_SEL<="00" when (Rsrc2_exc /=Rdest_mem and Rsrc2_exc /=Rdest_WB )
else "01" when (Rsrc2_exc = Rdest_mem and enable_mem='1' )
else "10" when (Rsrc2_exc = Rdest_WB and enable_wb= '1'  )
else "00";
end architecture;

