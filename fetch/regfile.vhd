library ieee;
use ieee.std_logic_1164.all;

entity regfile is
  port(src1, src2, write_reg: in std_logic_vector(2 downto 0);
      write_val: in std_logic_vector(31 downto 0);
      write_en: in std_logic;
      rst, clk: in std_logic;
      src1_val, src2_val: out std_logic_vector(31 downto 0));
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


    src1_val <= q0 when src1 = "000" else
        q1 when src1 = "001" else
        q2 when src1 = "010" else
        q3 when src1 = "011" else
        q4 when src1 = "100" else
        q5 when src1 = "101" else
        q6 when src1 = "110" else
        q7;


    src2_val <= q0 when src2 = "000" else
        q1 when src2 = "001" else
        q2 when src2 = "010" else
        q3 when src2 = "011" else
        q4 when src2 = "100" else
        q5 when src2 = "101" else
        q6 when src2 = "110" else
        q7;

    process(write_en)
      begin
        if write_en = '1' then
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