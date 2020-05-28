LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 
USE ieee.std_logic_misc.all;
ENTITY ALU IS
GENERIC (n : integer := 32);
	PORT(clk:in std_logic;
		A,B: IN std_logic_vector(n-1 downto 0);
	     S: IN std_logic_vector(3 downto 0);
	     Rst,flag_en:IN std_logic;
	     F: INOUT  std_logic_vector(n-1 downto 0);
		 flagReg_out: INOUT std_logic_vector(3 downto 0);
		 swap_flag:OUT std_logic;
inter_sig:in std_logic;
flush_signal:in std_logic);
		  
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
	process(clk)
	begin
		if(rising_edge(clk)) then
	if(S ="0000" or S ="0001" or S="1010" or S="1011" or S="0010") then --add sub inc dec)
	sigA<= A  ;
	else sigA<= (others => '0');
	end if;

	if(S="0000" or S="0010") then
		sigB<= B;
		elsif  (S="0001") then 
		sigB<=std_logic_vector(unsigned (not B) + ONE);
		elsif (S = "1011") then
			sigB<=(others => '1');
			else sigB<=(others => '0');
			end if;
	
			
	if(S="0000" or S="0001"  or S="1011" or S="0010") then
		carry_artihmetic<= '0';
		else carry_artihmetic<= '0';
    end if;

	if( S= "0000"  or S="0001" or S="1010"or S="1011" or S="0010") then
		f<= fout;
		elsif S="0110" and flush_signal='0' then 
			f<=STD_LOGIC_VECTOR(shift_right(signed(A),to_integer(unsigned(B))));
		elsif S="0011" then 
		f<=(A AND B);
		elsif S="0100" then
			f<=(A OR B);
		elsif S="1001" then
			f<=(NOT A);
		elsif S="0101" and flush_signal='0' then
			f<=STD_LOGIC_VECTOR(shift_left(signed(A), to_integer(unsigned(B))));
		
		elsif (S="1000" or S="0111") then
			f<=B;
	
		else f<=(others =>'0') ;
		end if;

		

		if(S="0000" or S="1010" or S="0010")then 
		Cout<=carry_artihmetic_out;
		elsif S="0001" then
			Cout<=not carry_artihmetic_out;
			elsif S="0101" and inter_sig/='1' and flush_signal='0' then
			Cout<=A(n - to_integer(unsigned(B))-1);
			elsif  S="0110" and B/="00000000000000000000000000000000" and inter_sig/='1' and flush_signal='0' then
				Cout<=A(to_integer(unsigned(B))-1);
				
			else Cout<= '0'; 
			end if;
			
	
		
	--flage register
	if(((S="0000"
	or S="0001" 
	or S="1010"
	or S="1011"
	or S="0011" 
	or S="0100" 
	or S="1001" 
	or S="0110"
	or S="0101" 
	or S="0110")
	and flag_en ='1' ))then
		EnableFlagReg<='1';
	end if;
	if(F="00000000000000000000000000000000")then 
		Z<= '1';
		else Z<='0';
	end if;
		if( F(n-1) = '1' )then 
		Nflg<= '1';
		else Nflg<='0';
		end if;
flagReg_in<=  Z & Nflg & Cout & '0';
		if( EnableFlagReg ='1' )then 
		flagReg_out<= flagReg_in;
		elsif  Rst='1'then
			flagReg_out<=(OTHERS=>'0') ;
		end if;
		end if;
		
	
if(S="0111" ) then 
	swap_flag<='1';
	else swap_flag<='0';
end if;
	end process;
end architecture;