----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:26:11 11/28/2016 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
port(r1: in std_logic_vector(31 downto 0); --Register R1
     r2: in std_logic_vector(31 downto 0); --Register R2
	  fn: in std_logic_vector(5 downto 0);  --Function(Hex)
	  op: in std_logic_vector(5 downto 0);  --Opcode
	  res: out std_logic_vector(31 downto 0) --Final Output
	  );
	  

end alu;

architecture Behavioral of alu is
begin
process(r1,r2,fn,op)
begin
IF(op = "000000") then

case fn is
  when "010000" =>   res <= r1 + r2;
  when "010001" =>   res <= r1 - r2;
  when "010010" =>   res <= r1 and r2;
  when "010011" =>   res <= r1 or r2;
  when "010100" =>   res <= r1 nor r2;
  when others  =>    res <= "00000000000000000000000000000000";
  end case;

 
ELSE
 
case op is
 when "000001" => 	res <= r1+r2;
 when "000010" =>    res <= r1-r2;
 when "000011" =>    res <= r1 and r2;
 when "000100" =>    res <= r1 or r2;
 when others   =>    res <= "00000000000000000000000000000000";
 end case;
 end if;  
end process;


end Behavioral;

