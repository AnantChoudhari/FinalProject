----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:42:23 12/05/2016 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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


entity Decoder is
port(
--clk : in std_logic;
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
selrd : out std_logic;
selwr : out std_logic;
ALUop : out std_logic_vector(2 downto 0);
NextPC : out std_logic_vector(1 downto 0));
end Decoder;

architecture Behavioral of Decoder is

signal op1 : std_logic_vector(5 downto 0);
signal func1 : std_logic_vector(5 downto 0);
--signal isLess : std_logic;
--signal isEq1 : std_logic;
signal isLoad1 : std_logic;
signal isStore1 : std_logic; 
signal I_type1 : std_logic;
signal isBranch1 : std_logic;
signal J_type1 : std_logic;
signal WrtEn1 : std_logic;
signal selrd1 : std_logic;
signal selwr1 : std_logic;
signal ALUop1 : std_logic_vector(2 downto 0);
signal NextPC1 : std_logic_vector(1 downto 0);

begin

op1 <= inst(31 downto 26);
func1 <= inst(5 downto 0);

--isLoad
process(clr,op1)
begin
--if(clk'event and clk='1') then
	if (clr = '1') then
		isLoad1 <= '0';
	else
		if (op1 = "000111") then
			isLoad1 <= '1';
		else isLoad1 <= '0';
		end if;
	end if;
--end if;
end process;

--isStore
process(clr,op1)
begin
--if (clk'event and clk='1') then
	if (clr = '1') then
		isStore1 <= '0';
	else
		if (op1 = "001000") then
			isStore1 <= '1';
		else
			isStore1 <= '0';
		end if;
	end if;
--end if;	
end process;

--I_type
process(clr,op1)
begin
--if(clk'event and clk='1') then
	if (clr = '1') then
		I_type1 <= '0';
	else
		if (op1 = "000000" or op1 = "001100" or op1 = "111111") then
			I_type1 <= '0';
		else 
			I_type1 <= '1';
		end if;
	end if;
--end if;
end process;

--J_type
process(clr,op1)
begin
--if(clk'event and clk='1') then
	if (clr = '1') then
		J_type1 <= '0';
	else
		if (op1 = "001100") then -- or op = "111111") then --halt
			J_type1 <= '1';
		else
			J_type1 <= '0';
		end if;
	end if;
--end if;
end process;

--isBranch
process(clr,op1)
begin
--if(clk'event and clk='1') then
	if (clr = '1') then
		isBranch1 <= '0';
	else
		if (op1 = "001001" or op1 = "001010" or op1 = "001011") then
			isBranch1 <= '1';
		else
			isBranch1 <= '0';
		end if;
	end if;
--end if;
end process;

--WrtEn
process(clr,op1,I_type1,isStore1,isBranch1)
begin
--if(clk'event and clk='1') then
	if (clr = '1') then
		WrtEn1 <= '0';
	else
--	if (wrten_f = '1') then
--		WrtEn1 <= '0';
		if(op1="000000") then
			WrtEn1 <= '1';
		elsif(I_type1='1') then
			if(isStore1='1' or isBranch1='1') then
				WrtEn1 <= '0';
			else
				WrtEn1 <= '1';
			end if;
		else
			WrtEn1 <= '0';
		end if;			
	end if;
--	if (wrten_f = '1') then
--		WrtEn1 <= '0';
--	end if;
--end if;
end process;

--selrd
process(clr,isLoad1)
begin
--if(clk'event and clk='1') then
	if (clr = '1') then
		selrd1 <= '0';
	else
		if(isLoad1='1') then
			selrd1 <= '1';
		else
			selrd1 <= '0';
		end if;			
	end if;
--end if;
end process;

--selwr
process(clr,isStore1)
begin
--if(clk'event and clk='1') then
	if (clr = '1') then
		selwr1 <= '0';
	else
		if(isStore1='1') then
			selwr1 <= '1';
		else
			selwr1 <= '0';
		end if;			
	end if;
--end if;
end process;

--NOP	000
--ADD	001
--SUB	010
--AND	011
--OR	100
--NOR	101	
--SHL	110
--SHR	111
--ALUop
process(clr,op1,func1)
begin
--if(clk'event and clk='1') then
if (clr = '1') then
		ALUop1 <= "000";
	else
		if(op1="000000") then
			case func1 is
				when "010000" => ALUop1 <= "001";
				when "010001" => ALUop1 <= "010";
				when "010010" => ALUop1 <= "011";
				when "010011" => ALUop1 <= "100";
				when "010100" => ALUop1 <= "101";
				when  others  => ALUop1 <= "000";
			end case;
		else
			case op1 is	
				when "000001" => ALUop1 <= "001";
				when "000010" => ALUop1 <= "010";
				when "000011" => ALUop1 <= "011";
				when "000100" => ALUop1 <= "100";
				when "000101" => ALUop1 <= "110";
				when "000110" => ALUop1 <= "111";
				when "000111" => ALUop1 <= "001";
				when "001000" => ALUop1 <= "001";
				when  others  => ALUop1 <= "000";
			end case;
		end if;
end if;
--end if;
end process;

--NextPC
process(clr,op1,isEq,isLess,J_Type1)
begin
--if(clk'event and clk='1') then
if (clr = '0') then

if ((op1 = "001001" and isLess = '1') or (op1 = "001010" and isEq = '1') or (op1 = "001011" and isEq = '0')) then
	NextPC1 <= "10";
	elsif (J_Type1 = '1') then
		NextPC1 <= "01";
	elsif (op1 = "111111") then
		NextPC1 <= "11";
	else
		NextPC1 <= "00";
end if;
else
  NextPC1 <= "11";
end if;
--end if;
end process;

op<=op1;
func<=func1;
--isLess<=isLess1;
--isEq<=isEq1;
I_type<=I_type1;
J_type<=J_type1;
isBranch<=isBranch1;
ALUop<=ALUop1;
NextPC<=NextPC1;
selrd<=selrd1;
selwr<=selwr1;
WrtEn<=WrtEn1;
isLoad<=isLoad1;
isStore<=isStore1;

end Behavioral;