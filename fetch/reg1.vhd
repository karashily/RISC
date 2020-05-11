library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY register1 IS PORT(
    d   : IN STD_LOGIC;
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC -- output.
);
END register1;

ARCHITECTURE description OF register1 IS
signal output : std_logic := '0';
BEGIN
    q <= output;
    process(clk, clr)
    begin
        if rising_edge(clk) then
            if clr = '1' then
                output <= '0';
            elsif ld = '1' then
                output <= d;
            end if;
        end if;
    end process;
END description;