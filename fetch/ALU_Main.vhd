LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 
USE ieee.std_logic_misc.all;
ENTITY ALU IS
GENERIC (n : integer := 32);
	PORT(A,B: IN std_logic_vector(n-1 downto 0);
	     S: IN std_logic_vector(3 downto 0);
	     Rst,flag_en:IN std_logic;
	     F: INOUT  std_logic_vector(n-1 downto 0);
		 flagReg_out: INOUT std_logic_vector(3 downto 0);
		 swap_flag:OUT std_logic;
inter_sig:in std_logic;
flush_signal:in std_logic;
swap_flagin:std_logic);
		  
END ENTITY ALU;

ARCHITECTURE Data_flow OF ALU IS

component my_nadder is
GENERIC (n : integer := 32);
	PORT(a,b : IN std_logic_vector(n-1 DOWNTO 0);
	     cin : IN std_logic;
	     f : OUT std_logic_vector(n-1 DOWNTO 0);
		 cout : OUT std_logic
		 );
end component;	



--one op

--NOT	01001
--INC	01010 done
--DEC	01011 done
--2 op

--ADD	00000 done
--SUB	00001 done
--IADD	00010
--AND	00011
--OR	00100
--SHL	00101
--SHR	00110
--SWAP	00111

SIGNAL flagReg_in :std_logic_vector(3 downto 0);
SIGNAL Cout,Z,Nflg,EnableFlagReg,carry_artihmetic,carry_artihmetic_out :std_logic;
signal sigA,sigB,fout : std_logic_vector (n-1 downto 0);
constant ONE:   UNSIGNED(n-1 downto 0) := (0 => '1', others => '0');
begin
nadder:  my_nadder generic map(n) port map(sigA,sigB,carry_artihmetic,fout,carry_artihmetic_out);
sigA<= A  when S ="0000" or S ="0001" or S="1010" or S="1011" or S="0010"--add sub inc dec
 else (others => '0');


sigB<= B  when (S="0000" or S="0010") --add
  else std_logic_vector(unsigned (not B) + ONE) when  S="0001" --sub
	   else (others => '1') when S = "1011" --dec
	   else (others => '0');

carry_artihmetic<= '0' when S="0000" or S="0001"  or S="1011" or S="0010" else '1';
f<= fout when S= "0000"  or S="0001" or S="1010"or S="1011" or S="0010"
    else STD_LOGIC_VECTOR(shift_right(signed(A),to_integer(unsigned(B)))) when S="0110" and flush_signal='0'
    else (A AND B) when S="0011" 
	else (A OR B) when S="0100" 
	else (NOT A) when S="1001"
	else  STD_LOGIC_VECTOR(shift_left(signed(A), to_integer(unsigned(B)))) when S="0101" and flush_signal='0'
	else  B when (S="1000")
	else A when swap_flagin='0' and S="0111"
	else (others =>'0') ;
Cout<=carry_artihmetic_out when( S="0000" or S="1010" or S="0010" )
   else(not carry_artihmetic_out) when  S="0001"  
   else A(n - to_integer(unsigned(B))-1) when S="0101" and inter_sig/='1' and flush_signal='0'
   else A(to_integer(unsigned(B))-1) when S="0110" and B/="00000000000000000000000000000000" and inter_sig/='1' and flush_signal='0'
   else '0'; 	
--flage register
EnableFlagReg<='1' when((S="0000"
 or S="0001" 
 or S="1010"
 or S="1011"
 or S="0011" 
 or S="0100" 
 or S="1001" 
 or S="0110"
 or S="0101" 
or S="0110")
 and flag_en ='1' );
Z<= '1' when F="00000000000000000000000000000000" else '0';
Nflg<= '1' when F(n-1) = '1' else '0';
flagReg_in<=  Z & Nflg & Cout & '0';
flagReg_out<= flagReg_in when (EnableFlagReg ='1') else
(OTHERS=>'0') when Rst='1';
swap_flag<='1' when S="0111" else '0';
end architecture;