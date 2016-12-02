
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity alu is
port (
clk, clr : in std_logic
		);

end alu;

architecture Behavioral of alu is
signal op1 : std_logic_vector(31 downto 0);
signal op2 : std_logic_vector(31 downto 0);
signal ALUop : std_logic_vector(2 downto 0);
signal output : std_logic_vector(31 downto 0);

begin

process(clk, clr, ALUop)
if (clr = '0') then
	op = x"00000000";
	elsif (clk'event and clk = '1') then
	
		case ALUop is
			when "001" => output <= op1 + op2;
			when "010" => output <= op1 - op2;
			when "011" => output <= op1 and op2;
			when "100" => output <= op1 or op2;
			when "101" => output <= op1 nor op2;
			when "101" => 
				with op2(4 downto 0) select
					output <= 	op1(30 downto 0) & '0',
									op1(29 downto 0) & "00",
									....
									-- other cases need to be written
									
			when "110" => 
				with op2(4 downto 0) select
					output <=	'0' & op1(31 downto 1),
									"00" & op1(31 downto 2),
									....
									-- other cases need to be written
									
			when others => output <= x"00000000";

end Behavioral;

