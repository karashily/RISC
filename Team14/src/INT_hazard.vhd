library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY  INT_unit IS PORT(
    INT: in std_logic;
    INT_EM: in std_logic;
    clk: in std_logic;

    output_pc: out std_logic;
    output_control: out std_logic
);
END  INT_unit;

ARCHITECTURE  INT_arch OF  INT_unit IS
signal opcode : std_logic_vector(4 downto 0);

constant RET_opcode: std_logic_vector(4 downto 0) := "11011";
constant RTI_opcode: std_logic_vector(4 downto 0) := "11100";

signal start_stall: std_logic := '0';
signal end_stall: std_logic := '0';
signal end_stall_delayed: std_logic := '0';
signal stall_bit_5: std_logic := '0';
signal stall_bit_5_delayed: std_logic := '0';
signal stall_bit_5_delayed_delayed: std_logic := '0';
signal load_reg: std_logic;
signal s: std_logic;

component register1 IS PORT(
    d   : IN STD_LOGIC;
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC -- output.
);
END component;

BEGIN
    start_stall <= '1' when
        INT = '1'
    else '0';

    end_stall <= '1' when
        INT_EM = '1'
    else '0';

    s <= stall_bit_5 or start_stall;

    load_reg <= '0' when (stall_bit_5 = '1' and end_stall = '0') else '1';
    reg_PC : register1 port map (start_stall,load_reg,end_stall,clk,stall_bit_5);
    reg_cont : register1 port map (stall_bit_5,'1','0',clk,stall_bit_5_delayed);
    reg_cont_2 : register1 port map (stall_bit_5_delayed,'1','0',clk,stall_bit_5_delayed_delayed);
    -- reg2 : register1 port map (end_stall,load_reg,'0',clk,end_stall_delayed);
    -- output <=  ((stall_bit_5 or start_stall) and not end_stall_delayed);
    output_pc <= stall_bit_5 or start_stall;
    output_control <= stall_bit_5_delayed or stall_bit_5_delayed_delayed or stall_bit_5;
    -- ((stall_bit_5  and not end_stall_delayed )or start_stall) when (opcode = RET_opcode)
    -- else


END  INT_arch; 