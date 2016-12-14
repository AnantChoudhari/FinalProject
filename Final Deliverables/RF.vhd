----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:31:39 12/02/2016 
-- Design Name: 
-- Module Name:    RF - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RF is
    Port ( clr     : in  STD_LOGIC;
			  clk     : in  STD_LOGIC;
			  instr   : in  std_logic_vector (31 downto 0);
			  wrtdata : in  STD_LOGIC_VECTOR (31 downto 0);
--			  rddata1 : inout STD_LOGIC_VECTOR (31 downto 0);
--			  rddata2 : inout STD_LOGIC_VECTOR (31 downto 0);
			  data2 : out STD_LOGIC_VECTOR (31 downto 0);
			  wrten   : in  STD_LOGIC;
			  op : in std_logic_vector(5 downto 0);	
			  I_type : in std_logic;
			  seimm : out std_logic_vector(31 downto 0);
--			  rddata1 : out STD_LOGIC_VECTOR (31 downto 0);
--			  rddata2 : out STD_LOGIC_VECTOR (31 downto 0);
			  rfaddr : out std_logic_vector(4 downto 0);
--			  a: out std_logic_vector(31 downto 0);
--			  b: out std_logic_vector(31 downto 0);
--			  c: out std_logic_vector(31 downto 0);
--			  d: out std_logic_vector(31 downto 0);
--			  e: out std_logic_vector(31 downto 0);
--			  f: out std_logic_vector(31 downto 0);
--			  g: out std_logic_vector(31 downto 0);
--			  h: out std_logic_vector(31 downto 0);
			  output : inout std_logic_vector(31 downto 0);
			  aluop : in std_logic_vector(2 downto 0);
			  isEq : out std_logic;
		  isLess : out std_logic);						
end RF;

architecture Behavioral of RF is
signal rdaddr1: std_logic_vector(4 downto 0);
signal rdaddr2: std_logic_vector(4 downto 0);
signal wrtaddr: std_logic_vector(4 downto 0);
signal seimm1 : std_logic_vector(31 downto 0);
signal left_op : std_logic_vector(31 downto 0);
signal right_op : std_logic_vector(31 downto 0);
signal rddata1 : STD_LOGIC_VECTOR (31 downto 0);
signal rddata2 : STD_LOGIC_VECTOR (31 downto 0);
signal data : STD_LOGIC_VECTOR (31 downto 0);

type regfile is array(0 to 31) of std_logic_vector(31 downto 0);
signal rf: regfile:= regfile'(x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000");

signal rf1: regfile:= regfile'(x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000");

begin

data2 <= data;
rdaddr1<=instr(25 downto 21);
--new code
--rddata1<=rf(conv_integer(rdaddr1));
--new code
rdaddr2<=instr(20 downto 16);
process(clr,op,I_type,instr)
begin
	if (clr ='0') then
		if(op="000000") then
		--	rdaddr2<=instr(20 downto 16);
			wrtaddr<=instr(15 downto 11);
		else
			if(I_type='1') then
			  
				if(instr(15)='0') then
					wrtaddr<=instr(20 downto 16);
					seimm1<= x"0000" & instr(15 downto 0);
				elsif(instr(15)='1') then
					wrtaddr<=instr(20 downto 16);
					seimm1<= x"FFFF" & instr(15 downto 0);
				end if;
			end if;
		end if;
	else
	  --rddata2 <= x"00000000";
	  --rdaddr2 <= "00000";
	  seimm1 <= x"00000000";
	  wrtaddr <= "00000";
	end if;
end process;

process(clr,I_type,rdaddr1,rdaddr2,seimm1,rf)
begin
	if(clr='0') then
		rddata1 <= rf(conv_integer(rdaddr1));
		if(I_type='1') then
			rddata2<=seimm1;
			data<= rf(conv_integer(rdaddr2));
		else
			rddata2 <= rf(conv_integer(rdaddr2));
		end if;
	else
		--rf <= rf1;
		rddata1 <= x"00000000";
		rddata2 <= x"00000000";
		data <= x"00000000";
	end if;
end process;

process(clr,clk,wrten,wrtdata,wrtaddr)
begin
if(clk'event and clk='0') then
	if(clr='0') then
		if (wrten='1') then
			rf(conv_integer(wrtaddr)) <= wrtdata;
		end if;
	end if;
end if;
end process;

rfaddr <= wrtaddr;

seimm <= seimm1;

--a<=rf(0);
--b<=rf(1);
--c<=rf(2);
--d<=rf(3);
--e<=rf(4);
--f<=rf(5);
--g<=rf(6);
--h<=rf(7);
--
--
----ALU
--
with rddata2(4 downto 0) select
					right_op <=	'0' & rddata1(31 downto 1) when "00001",
									"00" & rddata1(31 downto 2) when "00010",
									"000" & rddata1(31 downto 3) when "00011",
									"0000" & rddata1(31 downto 4) when "00100",
									"00000" & rddata1(31 downto 5) when "00101",
									"000000" & rddata1(31 downto 6) when "00110",
									"0000000" & rddata1(31 downto 7) when "00111",
									"00000000" & rddata1(31 downto 8) when "01000",
									"000000000" & rddata1(31 downto 9) when "01001", 
									"0000000000" & rddata1(31 downto 10) when "01010",
									"00000000000" & rddata1(31 downto 11) when "01011", 
									"000000000000" & rddata1(31 downto 12) when "01100", 
									"0000000000000" & rddata1(31 downto 13) when "01101",
									"00000000000000" & rddata1(31 downto 14) when "01110",
									"000000000000000" & rddata1(31 downto 15) when "01111",
									"0000000000000000" & rddata1(31 downto 16) when "10000",
									"00000000000000000" & rddata1(31 downto 17) when "10001",
									"000000000000000000" & rddata1(31 downto 18) when "10010",
									"0000000000000000000" & rddata1(31 downto 19) when "10011", 
									"00000000000000000000" & rddata1(31 downto 20) when "10100",
									"000000000000000000000" & rddata1(31 downto 21) when "10101",
									"0000000000000000000000" & rddata1(31 downto 22) when "10110",
									"00000000000000000000000" & rddata1(31 downto 23) when "10111",
									"000000000000000000000000" & rddata1(31 downto 24) when "11000",
									"0000000000000000000000000" & rddata1(31 downto 25) when "11001",
									"00000000000000000000000000" & rddata1(31 downto 26) when "11010",
									"000000000000000000000000000" & rddata1(31 downto 27) when "11011",
									"0000000000000000000000000000" & rddata1(31 downto 28) when "11100",
									"00000000000000000000000000000" & rddata1(31 downto 29) when "11101",
									"000000000000000000000000000000" & rddata1(31 downto 30) when "11110",
									"0000000000000000000000000000000" & rddata1(31) when "11111",
									rddata1 when others;

with rddata2(4 downto 0) select
					left_op <= 	rddata1(30 downto 0) & '0' when "00001",
									rddata1(29 downto 0) & "00" when "00010", 
									rddata1(28 downto 0) & "000" when "00011", 
									rddata1(27 downto 0) & "0000" when "00100", 
									rddata1(26 downto 0) & "00000" when "00101", 
									rddata1(25 downto 0) & "000000" when "00110", 
									rddata1(24 downto 0) & "0000000" when "00111", 
									rddata1(23 downto 0) & "00000000" when "01000", 
									rddata1(22 downto 0) & "000000000" when "01001", 
									rddata1(21 downto 0) & "0000000000" when "01010", 
									rddata1(20 downto 0) & "00000000000" when "01011", 
									rddata1(19 downto 0) & "000000000000" when "01100", 
									rddata1(18 downto 0) & "0000000000000" when "01101", 
									rddata1(17 downto 0) & "00000000000000" when "01110", 
									rddata1(16 downto 0) & "000000000000000" when "01111", 
									rddata1(15 downto 0) & "0000000000000000" when "10000", 
									rddata1(14 downto 0) & "00000000000000000" when "10001",
									rddata1(13 downto 0) & "000000000000000000" when "10010", 
								rddata1(12 downto 0) & "0000000000000000000" when "10011", 
									rddata1(11 downto 0) & "00000000000000000000" when "10100", 
									rddata1(10 downto 0) & "000000000000000000000" when "10101", 
									rddata1(9 downto 0) & "0000000000000000000000" when "10110", 
									rddata1(8 downto 0) & "00000000000000000000000" when "10111", 
									rddata1(7 downto 0) & "000000000000000000000000" when "11000", 
									rddata1(6 downto 0) & "0000000000000000000000000" when "11001", 
									rddata1(5 downto 0) & "00000000000000000000000000" when "11010", 
									rddata1(4 downto 0) & "000000000000000000000000000" when "11011", 
									rddata1(3 downto 0) & "0000000000000000000000000000" when "11100", 
									rddata1(2 downto 0) & "00000000000000000000000000000" when "11101", 
									rddata1(1 downto 0) & "000000000000000000000000000000" when "11110", 
									rddata1(0) & "0000000000000000000000000000000" when "11111", 
									rddata1 when others;


process(clr,rddata1,rddata2,left_op,right_op, aluop,op)
begin
if (clr = '1') then
	output <= x"00000000";	 
else
	case ALUop is
			when "001" => output <= rddata1 + rddata2;
			
			when "010" => 
				if (op = "000000") then 
					output <= rddata2 - rddata1;
				else
					output <= rddata1 - rddata2;
				end if;
			
			when "011" => output <= rddata1 and rddata2;
			
			when "100" => output <= rddata1 or rddata2;
			
			when "101" => output <= rddata1 nor rddata2;
			
			when "110" => output <= left_op;
			
			when "111" => output <= right_op;
			
			when others => output <= x"00000000";
		end case;
end if;
end process;

process(clr, op, rddata1, data)
begin
if (clr = '1') then
	isEq <= '0';
	isLess <= '0';
elsif(op = "001001" or op = "001010" or op = "001011") then
		if(rddata1 = data) then
			isEq <= '1';
		elsif(rddata1 < data) then
			isLess <= '1';
		end if;
end if;
end process;

end Behavioral;