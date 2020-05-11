library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch_hazard is
    port(
      A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
      clk: in std_logic;
      reset: in std_logic;
      result: out STD_LOGIC
      );
  end fetch_hazard;

architecture fetch_hazard_arch of fetch_hazard is
    signal stall: std_logic;
    signal res: std_logic;
    signal clr: std_logic;

    component extra_fetch_hazard is
        port(
          A: in STD_LOGIC_VECTOR (15 DOWNTO 0);
          result: out STD_LOGIC
          );
      end component;

    component register1 IS PORT(
        d   : IN STD_LOGIC;
        ld  : IN STD_LOGIC; -- load/enable.
        clr : IN STD_LOGIC; -- async. clear.
        clk : IN STD_LOGIC; -- clock.
        q   : OUT STD_LOGIC -- output.
    );
    END component;


begin
    
    u0 : extra_fetch_hazard port map (A,stall);
    clr <= (stall and res) or reset;
    u1 : register1 port map (stall,'1',clr,clk,res);
    result <= res;

end fetch_hazard_arch; 

