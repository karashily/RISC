library ieee;
use ieee.std_logic_1164.all;

entity handler is
  port(
      clk, rst, intr_mem, intr_wb: in std_logic;
      mem_control_signal :in std_logic_vector (6 downto 0);
      rd_wr_sel ,sp_load ,sp_alu: out std_logic;
      val_sel , add_sel: out std_logic_vector(1 downto 0));
end handler;

architecture arch of handler is
  begin
    process(clk, rst)
      begin
        if(rst ='1') then
          rd_wr_sel <='0';
          val_sel <="00";
          add_sel <="00";
          sp_load <='0';
          sp_alu <='0';
        elsif rising_edge(clk) then
          if(intr_mem = '1' and intr_wb ='0')then
            rd_wr_sel <= '1';
            val_sel <= "11";
	          add_sel <= "11";
	          SP_load <= '1';
           	SP_Alu <= '1';
       	
       	  elsif(intr_wb = '1')then
            rd_wr_sel <= '0';
            val_sel <= "00";
	          add_sel <= "01";
	          SP_load <= '0';
           	SP_Alu <= '0';
     	    
     	    else
       	    rd_wr_sel <= mem_control_signal(0);
            val_sel <= mem_control_signal(2 downto 1);
	          add_sel <= mem_control_signal(4 downto 3);
	          SP_load <= mem_control_signal(5);
           	SP_Alu <= mem_control_signal(6);
       	  
     	    end if;
        end if;
    end process;
  end architecture;



