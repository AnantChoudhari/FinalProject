----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:21:00 12/06/2016 
-- Design Name: 
-- Module Name:    MUX - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX is
    Port ( clk : in std_logic;
			  clr : in std_logic;
			  addrin : in  STD_LOGIC_VECTOR (31 downto 0);
           NextPC : in  STD_LOGIC_VECTOR (1 downto 0);
           instr : in  STD_LOGIC_VECTOR (31 downto 0);
			  seimm : in  STD_LOGIC_VECTOR (31 downto 0);		
			  addrout : inout  STD_LOGIC_VECTOR (31 downto 0);	
			  RFWrtData : out  STD_LOGIC_VECTOR (31 downto 0);	
			  dout : in  STD_LOGIC_VECTOR (31 downto 0);			
			  output : in  STD_LOGIC_VECTOR (31 downto 0);		
			  isLoad : in std_logic										
			  );
end MUX;

architecture Behavioral of MUX is
signal newaddr : STD_LOGIC_VECTOR (31 downto 0);

begin
newaddr <= addrin + 1;

process(clr,NextPC,newaddr,seimm,instr,addrout,addrin)
begin
--if(clk'event and clk='1') then
	if(clr='1') then
		addrout <= x"00000000";
	else
		if(NextPC="00") then
			addrout<=newaddr;
		elsif(NextPC="10") then
			addrout<=newaddr+seimm;
		elsif(NextPC="01") then
			addrout<= newaddr(31 downto 26) & instr(25 downto 0);
		else
			addrout<= addrin;	--x"00000000";
		end if;
	end if;
--end if;
end process;

--MUX for wrtdata to RF
process(clr, clk, isLoad, dout, output)
begin
--if(topclk'event and topclk='1') then
	if(clr='1') then
		RFWrtData<=x"00000000";
	else
		if(isLoad='1') then
			RFWrtData<=dout;
		else
			RFWrtData<=output;
		end if;
	end if;
--END IF;
end process;
end Behavioral;