library ieee;
use ieee.std_logic_1164.all;

entity regfile is
  port(src1, src2, dst, write_reg: in std_logic_vector(2 downto 0);
      write_val: in std_logic_vector(31 downto 0);
      rst, clk, load: in std_logic;
      src1_val, src2_val, dst_val: out std_logic_vector(31 downto 0));
end regfile;

architecture arch of regfile is
    component reg is
        generic (n:integer := 32);
      port(d : in std_logic_vector(n-1 downto 0);
          clk, rst, load: in std_logic;
          q: out std_logic_vector(n-1 downto 0));
    end component;

    signal q0 : std_logic_vector(31 downto 0);
    signal q1 : std_logic_vector(31 downto 0);
    signal q2 : std_logic_vector(31 downto 0);
    signal q3 : std_logic_vector(31 downto 0);
    signal q4 : std_logic_vector(31 downto 0);
    signal q5 : std_logic_vector(31 downto 0);
    signal q6 : std_logic_vector(31 downto 0);
    signal q7 : std_logic_vector(31 downto 0);

    signal load0 : std_logic;
    signal load1 : std_logic;
    signal load2 : std_logic;
    signal load3 : std_logic;
    signal load4 : std_logic;
    signal load5 : std_logic;
    signal load6 : std_logic;
    signal load7 : std_logic;

  begin
    
    reg0: reg generic map (n=>32) port map(d=>write_val, clk=>clk, rst=>rst, load=>load0, q=>q0);
    reg1: reg generic map (n=>32) port map(d=>write_val, clk=>clk, rst=>rst, load=>load1, q=>q1);
    reg2: reg generic map (n=>32) port map(d=>write_val, clk=>clk, rst=>rst, load=>load2, q=>q2);
    reg3: reg generic map (n=>32) port map(d=>write_val, clk=>clk, rst=>rst, load=>load3, q=>q3);
    reg4: reg generic map (n=>32) port map(d=>write_val, clk=>clk, rst=>rst, load=>load4, q=>q4);
    reg5: reg generic map (n=>32) port map(d=>write_val, clk=>clk, rst=>rst, load=>load5, q=>q5);
    reg6: reg generic map (n=>32) port map(d=>write_val, clk=>clk, rst=>rst, load=>load6, q=>q6);
    reg7: reg generic map (n=>32) port map(d=>write_val, clk=>clk, rst=>rst, load=>load7, q=>q7);

    process(clk, rst, write_reg, load)
      begin
        if falling_edge(clk) then
            case src1 is
                when "000" =>
                    src1_val <= q0;
                when "001" =>
                    src1_val <= q1;
                when "010" =>
                    src1_val <= q2;
                when "011" =>
                    src1_val <= q3;
                when "100" =>
                    src1_val <= q4;
                when "101" =>
                    src1_val <= q5;
                when "110" =>
                    src1_val <= q6;
                when others =>
                    src1_val <= q7;
            end case;
            case src2 is
                when "000" =>
                    src2_val <= q0;
                when "001" =>
                    src2_val <= q1;
                when "010" =>
                    src2_val <= q2;
                when "011" =>
                    src2_val <= q3;
                when "100" =>
                    src2_val <= q4;
                when "101" =>
                    src2_val <= q5;
                when "110" =>
                    src2_val <= q6;
                when others =>
                    src2_val <= q7;
            end case;
            case dst is
                when "000" =>
                    dst_val <= q0;
                when "001" =>
                    dst_val <= q1;
                when "010" =>
                    dst_val <= q2;
                when "011" =>
                    dst_val <= q3;
                when "100" =>
                    dst_val <= q4;
                when "101" =>
                    dst_val <= q5;
                when "110" =>
                    dst_val <= q6;
                when others =>
                    dst_val <= q7;
            end case;
        end if;
        if load = '0' then
            case write_reg is
                when "000" =>
                    load0 <= '1';
                    load1 <= '0';
                    load2 <= '0';
                    load3 <= '0';
                    load4 <= '0';
                    load5 <= '0';
                    load6 <= '0';
                    load7 <= '0';
                when "001" =>
                    load0 <= '0';
                    load1 <= '1';
                    load2 <= '0';
                    load3 <= '0';
                    load4 <= '0';
                    load5 <= '0';
                    load6 <= '0';
                    load7 <= '0';
                when "010" =>
                    load0 <= '0';
                    load1 <= '0';
                    load2 <= '1';
                    load3 <= '0';
                    load4 <= '0';
                    load5 <= '0';
                    load6 <= '0';
                    load7 <= '0';
                when "011" =>
                    load0 <= '0';
                    load1 <= '0';
                    load2 <= '0';
                    load3 <= '1';
                    load4 <= '0';
                    load5 <= '0';
                    load6 <= '0';
                    load7 <= '0';
                when "100" =>
                    load0 <= '0';
                    load1 <= '0';
                    load2 <= '0';
                    load3 <= '0';
                    load4 <= '1';
                    load5 <= '0';
                    load6 <= '0';
                    load7 <= '0';
                when "101" =>
                    load0 <= '0';
                    load1 <= '0';
                    load2 <= '0';
                    load3 <= '0';
                    load4 <= '0';
                    load5 <= '1';
                    load6 <= '0';
                    load7 <= '0';
                when "110" =>
                    load0 <= '0';
                    load1 <= '0';
                    load2 <= '0';
                    load3 <= '0';
                    load4 <= '0';
                    load5 <= '0';
                    load6 <= '1';
                    load7 <= '0';
                when "111" =>
                    load0 <= '0';
                    load1 <= '0';
                    load2 <= '0';
                    load3 <= '0';
                    load4 <= '0';
                    load5 <= '0';
                    load6 <= '0';
                    load7 <= '1';
                when others =>
                    load0 <= '0';
                    load1 <= '0';
                    load2 <= '0';
                    load3 <= '0';
                    load4 <= '0';
                    load5 <= '0';
                    load6 <= '0';
                    load7 <= '0';
            end case;
        else
            load0 <= '0';
            load1 <= '0';
            load2 <= '0';
            load3 <= '0';
            load4 <= '0';
            load5 <= '0';
            load6 <= '0';
            load7 <= '0';
        end if;
    end process;
  end architecture;