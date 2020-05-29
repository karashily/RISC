library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY  RET_RTI_RESET_INT_unit IS PORT(
    A: in std_logic_vector(15 downto 0);
    opcode_DE: in std_logic_vector(4 downto 0);
    INT: in std_logic;
    INT_EM: in std_logic;
    RESET: in std_logic;
    RESET_EM: in std_logic;
    clk: in std_logic;

    output: out std_logic
);
END  RET_RTI_RESET_INT_unit;

ARCHITECTURE  RET_RTI_RESET_INT_arch OF  RET_RTI_RESET_INT_unit IS
signal opcode : std_logic_vector(4 downto 0);

constant RET_opcode: std_logic_vector(4 downto 0) := "11011";
constant RTI_opcode: std_logic_vector(4 downto 0) := "11100";

signal start_stall: std_logic := '0';
signal end_stall: std_logic := '0';
signal end_stall_delayed: std_logic := '0';
signal stall_bit_5: std_logic := '0';
signal load_reg: std_logic;

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
    start_stall <= '1' when
        opcode = RET_opcode or
        opcode = RTI_opcode or
        INT = '1' or
        RESET = '1'
    else '0';

    end_stall <= '1' when
        opcode_DE = RET_opcode or
        opcode_DE = RTI_opcode or
        INT_EM = '1' or
        RESET_EM = '1'
    else '0';

    load_reg <= '0' when (stall_bit_5 = '1' and end_stall = '0') else '1';
    reg : register1 port map (start_stall,load_reg,'0',clk,stall_bit_5);
    reg2 : register1 port map (end_stall,load_reg,'0',clk,end_stall_delayed);
    output <= ((stall_bit_5  and not end_stall_delayed )or start_stall) when (opcode = RET_opcode)
    else ((stall_bit_5 or start_stall) and not end_stall_delayed);
    ;




END  RET_RTI_RESET_INT_arch;