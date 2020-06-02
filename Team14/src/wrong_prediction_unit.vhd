library ieee;
use ieee.std_logic_1164.all;

entity wrong_prediction_unit is
  port(opcode_DE : in std_logic_vector(4 downto 0);
        prediction_bit : in std_logic;
        ZF : in std_logic;
        ex_instr_flushed: in std_logic;
      q: out std_logic);
end wrong_prediction_unit;

architecture arch of wrong_prediction_unit is
    constant jz_opcode : std_logic_vector(4 downto 0) := "11000";
  begin
    q <= (ZF xor prediction_bit) when ((opcode_DE = jz_opcode) and (ex_instr_flushed = '0')) else '0';
  end architecture;

