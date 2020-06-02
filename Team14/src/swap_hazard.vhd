library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY  swap_unit IS PORT(
    A: in std_logic_vector(15 downto 0);
    opcode_FD: in std_logic_vector(4 downto 0);
    clk: in std_logic;

    output: out std_logic
);
END  swap_unit;

ARCHITECTURE  swap_arch OF  swap_unit IS

constant swap_opcode: std_logic_vector(4 downto 0) := "00111";

signal stall: std_logic := '0';
signal stall_delayed: std_logic := '0';
signal opcode: std_logic_vector(4 downto 0);


component register1 IS PORT(
    d   : IN STD_LOGIC;
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC -- output.
);
END component;

BEGIN
    opcode <= A(15 downto 11);

    stall <= '1' when (opcode = swap_opcode) and (stall_delayed = '0') else '0';
    

    reg : register1 port map (stall,'1','0',clk,stall_delayed);
    output <= stall;




END  swap_arch;