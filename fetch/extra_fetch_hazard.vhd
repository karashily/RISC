library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extra_fetch_hazard is
    port(
      A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
      result: out STD_LOGIC
      );
  end extra_fetch_hazard;

architecture extra_fetch_hazard_arch of extra_fetch_hazard is
    signal operation_type : STD_LOGIC_VECTOR(1 downto 0);
    signal operation : STD_LOGIC_VECTOR(2 downto 0);
    signal two_op : STD_LOGIC;
    signal mem_op : STD_LOGIC;
    signal two_op_incomplete : STD_LOGIC;
    signal mem_op_incomplete : STD_LOGIC;
    

    


begin
    operation_type <= A(15 downto 14);
    operation <= A(13 downto 11);
    two_op <= operation_type(1) nor operation_type(0);
    mem_op <= operation_type(1) and (not operation_type(0));
    two_op_incomplete <= (operation(1) and (not operation(0))) or (operation(2) and operation (0) and (not(operation(1))));
    mem_op_incomplete <= ((not operation(2)) and operation(1)) or (operation(2) and (not operation(1)) and (not(operation(0))));
    result <= (two_op and two_op_incomplete) or (mem_op and mem_op_incomplete);


end extra_fetch_hazard_arch; 

