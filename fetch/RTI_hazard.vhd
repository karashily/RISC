library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY  RTI_RET_unit IS PORT(
    A: in std_logic_vector(15 downto 0);
    opcode_DE: in std_logic_vector(4 downto 0);
    clk: in std_logic;

    output_pc: out std_logic;
    output_control: out std_logic);
END  RTI_RET_unit;


ARCHITECTURE  RTI_RET_arch OF  RTI_RET_unit IS
signal opcode : std_logic_vector(4 downto 0);

constant RET_opcode: std_logic_vector(4 downto 0) := "11011";
constant RTI_opcode: std_logic_vector(4 downto 0) := "11100";

signal start_stall: std_logic := '0';
signal end_stall: std_logic := '0';
signal end_stall_delayed: std_logic := '0';
signal stall_bit_5: std_logic := '0';
signal load_reg: std_logic;
signal s: std_logic;
signal stall_bit_5_delayed: std_logic := '0';
signal stall_bit_5_delayed_delayed: std_logic := '0';


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
        (opcode = RET_opcode and opcode_DE /= RET_opcode) or
        (opcode = RTI_opcode and opcode_DE /= RTI_opcode)
    else '0';

    end_stall <= '1' when
        opcode_DE = RET_opcode or
        opcode_DE = RTI_opcode 
    else '0';

    s <= stall_bit_5 or start_stall;

    load_reg <= '0' when (stall_bit_5 = '1' and end_stall = '0') else '1';
    reg_PC : register1 port map (start_stall,load_reg,end_stall,clk,stall_bit_5);
    reg_cont : register1 port map (stall_bit_5,'1','0',clk,stall_bit_5_delayed);
    reg_cont_2 : register1 port map (stall_bit_5_delayed,'1','0',clk,stall_bit_5_delayed_delayed);

    -- reg2 : register1 port map (end_stall,load_reg,'0',clk,end_stall_delayed);
    -- output <=  ((stall_bit_5 or start_stall) and not end_stall_delayed);
    output_pc <= stall_bit_5 or start_stall;
    output_control <= stall_bit_5_delayed_delayed or stall_bit_5_delayed;
    -- ((stall_bit_5  and not end_stall_delayed )or start_stall) when (opcode = RET_opcode)
    -- else


END  RTI_RET_arch; 