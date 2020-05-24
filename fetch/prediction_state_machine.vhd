library ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity prediction_state_machine is    
    port (
        input,clk,load,rst:in std_logic;
        output:out std_logic);
end prediction_state_machine ;

Architecture prediction_state_machine_arch of prediction_state_machine is
    
        type states is (SNT,WNT,WT,ST);
        signal current_state : states := SNT;
        signal next_state : states := SNT;
    
    begin
    
        process (clk,rst) 
            begin
                if rst = '1' then
                    current_state <= SNT;
              elsif rising_edge(clk) and load = '1' then 
                case current_state is
                    when SNT => 
                       if input = '1' then current_state <= WNT; else current_state <= SNT; end if;
                    when WNT =>
                        if input = '1' then current_state <= WT; else current_state <= SNT; end if;
                    when WT =>
                        if input = '1' then current_state <= ST; else current_state <= WNT; end if;
                    when ST =>
                        if input = '1' then current_state <= ST; else current_state <= WT; end if;
          
                end case;
              end if;
            end process;
        
    
    
        process (current_state) 
        begin
            case current_state is
                when SNT | WNT  =>
                    output <= '0';
                when ST | WT =>
                    output <= '1';
            end case;
        end process;
           
    end Architecture;