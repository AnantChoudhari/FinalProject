----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:18:47 12/06/2016 
-- Design Name: 
-- Module Name:    PC - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port (clr : in std_logic; 
			 clk : in std_logic;
			 addrin : in  STD_LOGIC_VECTOR (31 downto 0);
          addrout : out  STD_LOGIC_VECTOR (31 downto 0));
end PC;

architecture Behavioral of PC is

begin

process(clr,clk,addrin)
begin
if(clk'event and clk='1') then
	if(clr='1') then
		addrout <= x"00000000";
	else
		addrout<=addrin;
----		if(NextPC="00") then
----			addrout<=addrin+1;
----		elsif(NextPC="10") then
----			addrout<=addrin+1+seimm;
----		elsif(NextPC="01") then
----			addrout<=
----conditions
--		if() then
--		elsif
--		elsif
--		else
--			addrout <= addrin;
--		end if;
	end if;
end if;
end process;

end Behavioral;