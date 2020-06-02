library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY  prediction_in_decode_unit IS PORT(
    A: in std_logic_vector(15 downto 0);
    regCode_in_dec: in std_logic;
    clk: in std_logic;
    reset: in std_logic;
    output: out std_logic
);
END  prediction_in_decode_unit;

ARCHITECTURE  prediction_in_decode_arch OF  prediction_in_decode_unit IS
signal opcode : std_logic_vector(4 downto 0);

constant JZ_opcode: std_logic_vector(4 downto 0) := "11000";
constant JMP_opcode: std_logic_vector(4 downto 0) := "11001";
constant RET_opcode: std_logic_vector(4 downto 0) := "11010";

signal stall_bit_8: std_logic := '0';
signal stall: std_logic := '0';
signal clr: std_logic := '0';

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
    stall <= '1' when (regCode_in_dec = '1' and ((opcode = JZ_opcode) or (opcode = JMP_opcode) or (opcode = RET_opcode))) else '0';
    -- output <= stall;


    -- clr <= '1' when (stall= '1' and stall_bit_8 = '0') or reset = '1' else '0';
    u1 : register1 port map (stall,'1',reset,clk,stall_bit_8);

    process(stall,stall_bit_8)
    begin
        -- if (rising_edge(clk)) then
            if (stall = '1' and stall_bit_8 = '0') then
                output <= '1';
            else
                output <= '0';
            end if;
        -- end if;
    end process;




END  prediction_in_decode_arch;