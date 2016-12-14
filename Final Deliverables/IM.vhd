----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:23:15 12/01/2016 
-- Design Name: 
-- Module Name:    InstrMem - Behavioral 
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

entity InstrMem is
    Port ( --clk : in std_logic;
			  clr : in std_logic;
			  addr : in  STD_LOGIC_VECTOR (31 downto 0);
           instr : out  STD_LOGIC_VECTOR (31 downto 0));
end InstrMem;

architecture Behavioral of InstrMem is

type imem is array(0 to 31) of std_logic_vector(31 downto 0);
constant im: imem := imem'(x"00000000", 
"00000100000000010000000000000111",
"00000100000000100000000000001000",
"00000000010000010001100000010000",
"11111100000000000000000000000000",
x"00000000",x"00000000",x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",x"00000000", x"00000000",x"00000000", x"00000000",
								 x"00000000", x"00000000", x"00000000", x"00001111", x"00000000", x"00000000",x"00000000",
								 x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",x"00000000",
--								 x"00000000", x"00000000", x"00000000", x"00000000", x"00000000") x"00000000",
								 x"00000000", x"00000000");
								 							 
begin

process(clr,addr)
begin
--if(clk'event and clk='1')then
	if(clr='0')then
		instr <= im(conv_integer(addr));
   else
	   instr <= im(0); --one change made
	end if;
--end if;
end process;

end Behavioral;