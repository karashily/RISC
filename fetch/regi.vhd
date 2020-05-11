LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY regi IS
generic( Nbits : positive := 16 );
PORT(
    d   : IN std_logic_vector(Nbits-1 DOWNTO 0);
    ld  : IN std_logic; -- load/enable.
    clr : IN std_logic; -- async. clear.
    clk : IN std_logic; -- clock.
    q   : OUT std_logic_vector(Nbits-1 DOWNTO 0) -- output
);
END regi;

ARCHITECTURE arch OF regi IS
signal qq : std_logic_vector(Nbits-1 DOWNTO 0) := (others => '0');
BEGIN
    q <= qq;
    process(clk, clr)
    begin
        if clr = '1' then
            qq <= (others => '0');
        elsif rising_edge(clk) then
            if ld = '1' then
                qq <= d;
            end if;
        end if;
    end process;
END arch;