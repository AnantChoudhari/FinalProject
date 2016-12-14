----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:04:04 12/01/2016 
-- Design Name: 
-- Module Name:    MIPSProc - Behavioral 
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
--use IEEE.numeric_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MIPSProc is
port(--topclk : in std_logic;
		clk : in std_logic;
		clr : in std_logic;
		SSEG_CA, SSEG_AN : out std_logic_vector (7 downto 0)
		--out1 : inout std_logic_vector(31 downto 0)
		);
--	  key_vld : in std_logic;
--	  din_vld : in std_logic;
--	  ukey : in std_logic_vector(127 downto 0);				FOR RC5
--	  din : in std_logic_vector(63 downto 0);
--	  dout : out std_logic_vector(63 downto 0));
end MIPSProc;

architecture Behavioral of MIPSProc is


 component Hex2LED 
port (CLK: in STD_LOGIC; X: in STD_LOGIC_VECTOR (3 downto 0); Y: out STD_LOGIC_VECTOR (7 downto 0)); 
end component; 

component PC
	port(clr : in std_logic;
		  clk : in std_logic;
		  addrin : in  STD_LOGIC_VECTOR (31 downto 0);
        addrout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
component InstrMem
	port(--clk : in std_logic;
		  clr : in std_logic;
		  addr : in  STD_LOGIC_VECTOR (31 downto 0);
        instr : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
component Decoder
	port(--clk : in std_logic;
		  clr : in std_logic;
        inst: in std_logic_vector(31 downto 0);
		  op : out std_logic_vector(5 downto 0);
		  func : out std_logic_vector(5 downto 0);
		  isLess : in std_logic;
		  isEq : in std_logic;
		  isLoad : out std_logic;
		  isStore : out std_logic; 
		  I_type : out std_logic;
		  isBranch : out std_logic;
		  J_type : out std_logic;
		  WrtEn : out std_logic;
		  --wrten_f : in std_logic;
		  ALUop : out std_logic_vector(2 downto 0);
		  selrd : out std_logic;
		  selwr : out std_logic;
		  NextPC : out std_logic_vector(1 downto 0));
end component;
component RF
	port(clr     : in  STD_LOGIC;
			  clk     : in  STD_LOGIC;
			  --topclk     : in  STD_LOGIC;
			  instr   : in  std_logic_vector (31 downto 0);
--			  rdaddr1 : in  STD_LOGIC_VECTOR (4 downto 0);
--           rdaddr2 : in  STD_LOGIC_VECTOR (4 downto 0);
--           wrtaddr : in  STD_LOGIC_VECTOR (4 downto 0);
			  wrtdata : in  STD_LOGIC_VECTOR (31 downto 0);
--			  rddata1 : out STD_LOGIC_VECTOR (31 downto 0);
--			  rddata2 : out STD_LOGIC_VECTOR (31 downto 0);
--			  data2 : out STD_LOGIC_VECTOR (31 downto 0);
			  wrten   : in  STD_LOGIC;
--			  wrten_f : out STD_LOGIC;
    		  op : in std_logic_vector(5 downto 0);	
			  I_type : in std_logic;
			  seimm : out std_logic_vector(31 downto 0);
--			  rfaddr : out std_logic_vector(4 downto 0);
--			  a: out std_logic_vector(31 downto 0);
--			  b: out std_logic_vector(31 downto 0);
--			  c: out std_logic_vector(31 downto 0);
--			  d: out std_logic_vector(31 downto 0);
--			  e: out std_logic_vector(31 downto 0);
--			  f: out std_logic_vector(31 downto 0);
--			  g: out std_logic_vector(31 downto 0);
--			  h: out std_logic_vector(31 downto 0);
				data2 : out std_logic_vector(31 downto 0);
			  output : inout std_logic_vector(31 downto 0);
			  aluop : in std_logic_vector(2 downto 0);
			  isEq : out std_logic;
			  isLess : out std_logic);
end component;
--component ALU
--	port(clk, clr : in std_logic;
--		  op1 : in std_logic_vector(31 downto 0);
--		  op2 : in std_logic_vector(31 downto 0);
--		  ALUop : in std_logic_vector(2 downto 0);
--		  output : out std_logic_vector(31 downto 0);
--		  IsEq : out std_logic;
--		  IsLess : out std_logic);
--end component;
component DataMem
	port( clk : in  STD_LOGIC;
         rst : in  STD_LOGIC;
         addr : in  STD_LOGIC_VECTOR (31 downto 0);
         din : in  STD_LOGIC_VECTOR (31 downto 0);
         dout : out  STD_LOGIC_VECTOR (31 downto 0);
         selwr : in  STD_LOGIC;
         selrd : in  STD_LOGIC);
end component;

component MUX
	port(	  clk : in std_logic;
			  clr : in std_logic;
			  addrin : in  STD_LOGIC_VECTOR (31 downto 0);
           NextPC : in  STD_LOGIC_VECTOR (1 downto 0);
           instr : in  STD_LOGIC_VECTOR (31 downto 0);
			  seimm : in  STD_LOGIC_VECTOR (31 downto 0);		
			  addrout : inout  STD_LOGIC_VECTOR (31 downto 0);	
			  RFWrtData : out  STD_LOGIC_VECTOR (31 downto 0);	
			  dout : in  STD_LOGIC_VECTOR (31 downto 0);			
			  output : in  STD_LOGIC_VECTOR (31 downto 0);		
			  isLoad : in std_logic);
end component;

signal PCin: STD_LOGIC_VECTOR (31 downto 0);
signal PCout: STD_LOGIC_VECTOR (31 downto 0);
signal IMout: STD_LOGIC_VECTOR (31 downto 0);
signal ALUout: STD_LOGIC_VECTOR (31 downto 0); --output of ALU written back in RF(R,I)
signal DMout: STD_LOGIC_VECTOR(31 downto 0);
signal RFWrtData : STD_LOGIC_VECTOR(31 downto 0);
signal RFout1: std_logic_vector(31 downto 0); 
signal RFout2: std_logic_vector(31 downto 0); 
signal RFdata: std_logic_vector(31 downto 0); 
signal seimm : std_logic_vector(31 downto 0);
--signal wrten_f : STD_LOGIC;
signal op :  std_logic_vector(5 downto 0);				

signal func :  std_logic_vector(5 downto 0);
signal isLess :  std_logic;
signal isEq :  std_logic;
signal isLoad :  std_logic;
signal isStore :  std_logic; 
signal I_type :  std_logic;
signal isBranch :  std_logic;
signal J_type :  std_logic;
signal WrtEn :  std_logic;
--signal wrten_f : std_logic;
signal selrd :  std_logic;
signal selwr :  std_logic;
signal ALUop :  std_logic_vector(2 downto 0);
signal NextPC :  std_logic_vector(1 downto 0);
--signal timepass : std_logic_vector(4 downto 0);
signal rfaddr : std_logic_vector(4 downto 0);

type arr is array(0 to 22) of std_logic_vector(7 downto 0);
signal NAME: arr;

constant CNTR_MAX : std_logic_vector(23 downto 0) := x"030D40"; --100,000,000 = clk cycles per second
constant VAL_MAX : std_logic_vector(3 downto 0) := "1001"; --9
constant RESET_CNTR_MAX : std_logic_vector(17 downto 0) := "110000110101000000";-- 100,000,000 * 0.002 = 200,000 = clk cycles per 2 ms

signal Cntr : std_logic_vector(26 downto 0) := (others => '0');
signal Val : std_logic_vector(3 downto 0) := "0000";
signal hexval: std_logic_vector(31 downto 0):=x"00000000";


begin

M1: PC port map(clr=>clr,clk=>clk,addrin=>PCin,addrout=>PCout);
M2: InstrMem port map(clr=>clr,addr=>PCout,instr=>IMout);
M3: Decoder port map(clr=>clr,inst=>IMout,op=>op,func=>func,isLess=>isLess,isEq=>isEq,isLoad=>isLoad,
							isStore=>isStore,I_type=>I_type,isBranch=>isBranch,J_type=>J_type,WrtEn=>WrtEn,
							selrd=>selrd,selwr=>selwr,ALUop=>ALUop,NextPC=>NextPC);
M4: RF port map(clr=>clr,clk=>clk,instr=>IMout,output=>aluout,wrten=>WrtEn, wrtdata=>rfwrtdata,
					 op=>op,I_type=>I_type, aluop=>aluop,data2=>RFdata,
					 isEq=>isEq, isLess=>isLess, seimm=>seimm);
					 
--M5: ALU port map(clr=>clr,clk=>clk,op1=>RFout1,op2=>RFout2,output=>ALUout,ALUop=>ALUop,isLess=>isLess,isEq=>isEq);
M5: DataMem port map(rst=>clr,clk=>clk,addr=>ALUout,din=>RFdata,dout=>DMout,selrd=>selrd,selwr=>selwr);
M6: MUX port map(clr=>clr,clk=>clk,addrin=>PCout,NextPC=>NextPC,instr=>IMout,seimm=>seimm,addrout=>PCin,
					  RFWrtData=>RFWrtData,dout=>DMout,output=>ALUout,isLoad=>isLoad);



-- 7-Segment

process(clr, clk, aluout)
  begin
    if(clk'event and clk = '1') then
    if(clr = '1') then
	   hexval <= x"00000000";
	 elsif(PCout = "00000000000000000000000000001000") then
	   hexval <= aluout;
	 end if;
	 end if;
  end process;

timer_counter_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		if ((Cntr = CNTR_MAX)) then
			Cntr <= (others => '0');
		else
			Cntr <= Cntr + 1;
		end if;
	end if;
end process;

timer_inc_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		if (Cntr = CNTR_MAX) then
			if (Val = VAL_MAX) then
				Val <= (others => '0');
			else
				Val <= Val + 1;
			end if;
		end if;
	end if;
end process;
 
with Val select
	SSEG_AN <= "01111111" when "0001",
				  "10111111" when "0010",
				  "11011111" when "0011",
				  "11101111" when "0100",
				  "11110111" when "0101",
				  "11111011" when "0110",
				  "11111101" when "0111",
				  "11111110" when "1000",
				  "11111111" when others;

with Val select
	SSEG_CA <= NAME(0) when "0001",
				  NAME(1) when "0010",
				  NAME(2) when "0011",
				  NAME(3) when "0100",
				  NAME(4) when "0101",
				  NAME(5) when "0110",
				  NAME(6) when "0111",
				  NAME(7) when "1000",
				  NAME(0) when others;
--out1 <= aluout;

CONV1: Hex2LED port map (CLK => CLK, X => HexVal(31 downto 28), Y => NAME(0));
CONV2: Hex2LED port map (CLK => CLK, X => HexVal(27 downto 24), Y => NAME(1));
CONV3: Hex2LED port map (CLK => CLK, X => HexVal(23 downto 20), Y => NAME(2));
CONV4: Hex2LED port map (CLK => CLK, X => HexVal(19 downto 16), Y => NAME(3));		
CONV5: Hex2LED port map (CLK => CLK, X => HexVal(15 downto 12), Y => NAME(4));
CONV6: Hex2LED port map (CLK => CLK, X => HexVal(11 downto 8), Y => NAME(5));
CONV7: Hex2LED port map (CLK => CLK, X => HexVal(7 downto 4), Y => NAME(6));
CONV8: Hex2LED port map (CLK => CLK, X => HexVal(3 downto 0), Y => NAME(7));



end Behavioral;


















--------------------------------------------------------------------------------------
------ Company: 
------ Engineer: 
------ 
------ Create Date:    17:04:04 12/01/2016 
------ Design Name: 
------ Module Name:    MIPSProc - Behavioral 
------ Project Name: 
------ Target Devices: 
------ Tool versions: 
------ Description: 
------
------ Dependencies: 
------
------ Revision: 
------ Revision 0.01 - File Created
------ Additional Comments: 
------
--------------------------------------------------------------------------------------
----library IEEE;
----use IEEE.STD_LOGIC_1164.ALL;
------use IEEE.numeric_STD.ALL;
----use IEEE.STD_LOGIC_UNSIGNED.ALL;
----use IEEE.STD_LOGIC_arith.ALL;
----
------ Uncomment the following library declaration if using
------ arithmetic functions with Signed or Unsigned values
------use IEEE.NUMERIC_STD.ALL;
----
------ Uncomment the following library declaration if instantiating
------ any Xilinx primitives in this code.
------library UNISIM;
------use UNISIM.VComponents.all;
----
----entity MAIN is
----port(--topclk : in std_logic;
----		clk : in std_logic;
----		clr : in std_logic);
------	  key_vld : in std_logic;
------	  din_vld : in std_logic;
------	  ukey : in std_logic_vector(127 downto 0);				FOR RC5
------	  din : in std_logic_vector(63 downto 0);
------	  dout : out std_logic_vector(63 downto 0));
----end MAIN;
----
----architecture Behavioral of MAIN is
----
----component PC
----	port(clr : in std_logic;
----		  clk : in std_logic;
----		  addrin : in  STD_LOGIC_VECTOR (31 downto 0);
----        addrout : out  STD_LOGIC_VECTOR (31 downto 0));
----end component;
----component InstrMem
----	port(--clk : in std_logic;
----		  clr : in std_logic;
----		  addr : in  STD_LOGIC_VECTOR (31 downto 0);
----        instr : out  STD_LOGIC_VECTOR (31 downto 0));
----end component;
----component Decoder
----	port(--clk : in std_logic;
----		  clr : in std_logic;
----        inst: in std_logic_vector(31 downto 0);
----		  op : out std_logic_vector(5 downto 0);
----		  func : out std_logic_vector(5 downto 0);
----		  isLess : in std_logic;
----		  isEq : in std_logic;
----		  isLoad : out std_logic;
----		  isStore : out std_logic; 
----		  I_type : out std_logic;
----		  isBranch : out std_logic;
----		  J_type : out std_logic;
----		  WrtEn : out std_logic;
----		  --wrten_f : in std_logic;
----		  ALUop : out std_logic_vector(2 downto 0);
----		  selrd : out std_logic;
----		  selwr : out std_logic;
----		  NextPC : out std_logic_vector(1 downto 0));
----end component;
----component RF
----	port(clr     : in  STD_LOGIC;
----			  clk     : in  STD_LOGIC;
----			  --topclk     : in  STD_LOGIC;
----			  instr   : in  std_logic_vector (31 downto 0);
------			  rdaddr1 : in  STD_LOGIC_VECTOR (4 downto 0);
------           rdaddr2 : in  STD_LOGIC_VECTOR (4 downto 0);
------           wrtaddr : in  STD_LOGIC_VECTOR (4 downto 0);
----			  wrtdata : in  STD_LOGIC_VECTOR (31 downto 0);
------			  rddata1 : out STD_LOGIC_VECTOR (31 downto 0);
------			  rddata2 : out STD_LOGIC_VECTOR (31 downto 0);
------			  data2 : out STD_LOGIC_VECTOR (31 downto 0);
----			  wrten   : in  STD_LOGIC;
------			  wrten_f : out STD_LOGIC;
----    		  op : in std_logic_vector(5 downto 0);	
----			  I_type : in std_logic;
----			  seimm : out std_logic_vector(31 downto 0);
----			  rfaddr : out std_logic_vector(4 downto 0);
----			  a: out std_logic_vector(31 downto 0);
----			  b: out std_logic_vector(31 downto 0);
----			  c: out std_logic_vector(31 downto 0);
----			  d: out std_logic_vector(31 downto 0);
----			  e: out std_logic_vector(31 downto 0);
----			  f: out std_logic_vector(31 downto 0);
----			  g: out std_logic_vector(31 downto 0);
----			  h: out std_logic_vector(31 downto 0);
----				data2 : out std_logic_vector(31 downto 0);
----			  output : inout std_logic_vector(31 downto 0);
----			  aluop : in std_logic_vector(2 downto 0);
----			  isEq : out std_logic;
----			  isLess : out std_logic);
----end component;
------component ALU
------	port(clk, clr : in std_logic;
------		  op1 : in std_logic_vector(31 downto 0);
------		  op2 : in std_logic_vector(31 downto 0);
------		  ALUop : in std_logic_vector(2 downto 0);
------		  output : out std_logic_vector(31 downto 0);
------		  IsEq : out std_logic;
------		  IsLess : out std_logic);
------end component;
----component DataMem
----	port( clk : in  STD_LOGIC;
----         rst : in  STD_LOGIC;
----         addr : in  STD_LOGIC_VECTOR (31 downto 0);
----         din : in  STD_LOGIC_VECTOR (31 downto 0);
----         dout : out  STD_LOGIC_VECTOR (31 downto 0);
----         selwr : in  STD_LOGIC;
----         selrd : in  STD_LOGIC;
----			m8: out std_logic_vector(31 downto 0);
----			m9: out std_logic_vector(31 downto 0);
----			m10: out std_logic_vector(31 downto 0);
----			m11: out std_logic_vector(31 downto 0);
----			m12: out std_logic_vector(31 downto 0));
----end component;
----
----component MUX
----	port(	  clk : in std_logic;
----			  clr : in std_logic;
----			  addrin : in  STD_LOGIC_VECTOR (31 downto 0);
----           NextPC : in  STD_LOGIC_VECTOR (1 downto 0);
----           instr : in  STD_LOGIC_VECTOR (31 downto 0);
----			  seimm : in  STD_LOGIC_VECTOR (31 downto 0);		
----			  addrout : inout  STD_LOGIC_VECTOR (31 downto 0);	
----			  RFWrtData : out  STD_LOGIC_VECTOR (31 downto 0);	
----			  dout : in  STD_LOGIC_VECTOR (31 downto 0);			
----			  output : in  STD_LOGIC_VECTOR (31 downto 0);		
----			  isLoad : in std_logic);
----end component;
----
----signal PCin: STD_LOGIC_VECTOR (31 downto 0);
----signal PCout: STD_LOGIC_VECTOR (31 downto 0);
----signal IMout: STD_LOGIC_VECTOR (31 downto 0);
----signal ALUout: STD_LOGIC_VECTOR (31 downto 0); --output of ALU written back in RF(R,I)
----signal DMout: STD_LOGIC_VECTOR(31 downto 0);
----signal RFWrtData : STD_LOGIC_VECTOR(31 downto 0);
----signal RFout1: std_logic_vector(31 downto 0); 
----signal RFout2: std_logic_vector(31 downto 0); 
----signal RFdata: std_logic_vector(31 downto 0); 
----signal seimm : std_logic_vector(31 downto 0);
------signal wrten_f : STD_LOGIC;
----
----signal op :  std_logic_vector(5 downto 0);				
----signal func :  std_logic_vector(5 downto 0);
----signal isLess :  std_logic;
----signal isEq :  std_logic;
----signal isLoad :  std_logic;
----signal isStore :  std_logic; 
----signal I_type :  std_logic;
----signal isBranch :  std_logic;
----signal J_type :  std_logic;
----signal WrtEn :  std_logic;
------signal wrten_f : std_logic;
----signal selrd :  std_logic;
----signal selwr :  std_logic;
----signal ALUop :  std_logic_vector(2 downto 0);
----signal NextPC :  std_logic_vector(1 downto 0);
------signal timepass : std_logic_vector(4 downto 0);
----signal rfaddr : std_logic_vector(4 downto 0);
----signal a : std_logic_vector(31 downto 0);
----signal b : std_logic_vector(31 downto 0);
----signal c : std_logic_vector(31 downto 0);
----signal d : std_logic_vector(31 downto 0);
----signal e : std_logic_vector(31 downto 0);
----signal f : std_logic_vector(31 downto 0);
----signal g : std_logic_vector(31 downto 0);
----signal h : std_logic_vector(31 downto 0);
----
----signal m8:  std_logic_vector(31 downto 0);
----signal m9:  std_logic_vector(31 downto 0);
----signal m10:  std_logic_vector(31 downto 0);
----signal m11:  std_logic_vector(31 downto 0);
----signal m12:  std_logic_vector(31 downto 0);
----
------type rfout is array(0 to 31) of std_logic_vector(31 downto 0);
------signal vj: rfout:= rfout'(x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
------										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
------										x"00000000", x"00000000", x"0000000E", x"0000000F", x"00000000", x"00000000",
------										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
------										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
------										x"00000000", x"00000000");
------
------
------signal surfacepro: rfout:= rfout'(x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
------										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
------										x"00000000", x"00000000", x"0000000E", x"0000000F", x"00000000", x"00000000",
------										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
------										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
------										x"00000000", x"00000000");
----
----
----begin
----
----M1: PC port map(clr=>clr,clk=>clk,addrin=>PCin,addrout=>PCout);
----M2: InstrMem port map(clr=>clr,addr=>PCout,instr=>IMout);
----M3: Decoder port map(clr=>clr,inst=>IMout,op=>op,func=>func,isLess=>isLess,isEq=>isEq,isLoad=>isLoad,
----							isStore=>isStore,I_type=>I_type,isBranch=>isBranch,J_type=>J_type,WrtEn=>WrtEn,
----							selrd=>selrd,selwr=>selwr,ALUop=>ALUop,NextPC=>NextPC);
----M4: RF port map(clr=>clr,clk=>clk,instr=>IMout,output=>aluout,wrten=>WrtEn, wrtdata=>rfwrtdata,
----					 op=>op,I_type=>I_type, aluop=>aluop,data2=>RFdata,rfaddr=>rfaddr,
----					 a=>a,b=>b,c=>c,d=>d,e=>e,f=>f,g=>g, isEq=>isEq, isLess=>isLess, seimm=>seimm);
----					 
------M5: ALU port map(clr=>clr,clk=>clk,op1=>RFout1,op2=>RFout2,output=>ALUout,ALUop=>ALUop,isLess=>isLess,isEq=>isEq);
----M5: DataMem port map(rst=>clr,clk=>clk,addr=>ALUout,din=>RFdata,dout=>DMout,selrd=>selrd,selwr=>selwr,
----							m8=>m8,m9=>m9,m10=>m10,m11=>m11,m12=>m12);
----M6: MUX port map(clr=>clr,clk=>clk,addrin=>PCout,NextPC=>NextPC,instr=>IMout,seimm=>seimm,addrout=>PCin,
----					  RFWrtData=>RFWrtData,dout=>DMout,output=>ALUout,isLoad=>isLoad);
----
----
----
------process(clk, clr, op, I_type, IMout)
------  begin
------    if(clk'event and clk = '1') then
------	   if(clr = '0') then
------		  if(op = "000000") then
------		    timepass <= IMout(15 downto 11);
------		  elsif(I_type = '1') then
------		    timepass <= IMout(20 downto 16);
------		  end if;
------		end if;
------	 end if;
------	end process;
------	
------process(clk, clr, RFWrtData, IMout)
------  begin
------    if(clk'event and clk = '1') then
------	   if(clr = '0') then
------		  vj(conv_integer(timepass)) <= RFWrtData;
------	   else
------		  vj <= surfacepro;
------		end if;
------	 end if;
------	 
------
------  end process;
----end Behavioral;