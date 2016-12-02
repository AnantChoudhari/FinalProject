
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decoder is
port(
clk, clr : in std_logic
		);

end decoder;

architecture Behavioral of decoder is

signal op : std_logic_vector(5 downto 0);
signal func : std_logic_vector(5 downto 0);
signal isLess : std_logic;)

signal isLoad : std_logic;
signal isStore : std_logic; 
signal I_type : std_logic;
signal isBranch : std_logic;
signal J_type : std_logic;
signal WrtEn : std_logic;
signal ALUop : std_logic_vector(2 downto 0);
signal NextPC : std_logic_vector(1 downto 0);

begin

op <= inst(31 downto 26);
func <= inst(5 downto 0);

process(clr,clk,isLoad)
begin
	if (clr = '0') then
		isLoad <= 0;
	elsif (clk'event and clk = '1') then
		if (op = "000111") then
			isLoad <= 1;
		else isLoad <= 0;
		end if;
	end if;
end process;

process(clr,clk,isStore)
begin
	if (clr = '0') then
		isStore <= 0;
	elsif (clk'event and clk = '1') then
		if (op = "001000") then
			isStore <= 1;
		else isStore <= 0;
		end if;
	end if;
end process;

process(clr,clk,I_type)
begin
	if (clr = '0') then
		I_type <= 0;
	elsif (clk'event and clk = '1') then
		if (op = "000000" or op = "001100" or op = "111111") then
			I_type <= 0;
		else I_type <= 1;
		end if;
	end if;
end process;

process(clr,clk,J_type)
begin
	if (clr = '0') then
		J_type <= 0;
	elsif (clk'event and clk = '1') then
		if (op = "001100" or op = "111111") then
			J_type <= 1;
		else J_type <= 0;
		end if;
	end if;
end process;

process(clr,clk,isBranch)
begin
	if (clr = '0') then
		isBranch <= 0;
	elsif (clk'event and clk = '1') then
		if (op = "001001" or op = "001010" or op = "001011") then
			isBranch <= 1;
		else isBranch <= 0;
		end if;
	end if;
end process;

process(clr,clk,WrtEn)
begin
	if (clr = '0') then
		WrtEn <= 0;
	elsif (clk'event and clk = '1') then
		if (isStore = '1' or isBranch = '1' or J_type = '1') then
			WrtEn <= 0;
		else WrtEn <= 1;
		end if;
	end if;
end process;


--NOP	000
--ADD	001
--SUB	010
--AND	011
--OR	100
--NOR	101	
--SHL	110
--SHR	111


process(clr,clk,ALUop)
begin
if (clr = '0') then
		ALUop <= "000";
	elsif (clk'event and clk = '1') then

		case op is
			when "000000" =>
				with func select
				ALUop <=	"001" when "010000",
						"010" when "010001",
						"011" when "010010",
						"100" when "010011",
						"101" when "010100",
						"000" when others;
		
	when "000001" => ALUop <= "001";
	when "000010" => ALUop <= "010";
	when "000011" => ALUop <= "011";
	when "000100" => ALUop <= "100";
	when "000101" => ALUop <= "110";
	when "000110" => ALUop <= "111";
	when "000111" => ALUop <= "001";
	when "001000" => ALUop <= "001";
	when others   => ALUop <= "000";
end case;
end if;
end process;

process(clk,clr,NextPC)
begin
if ((op = "001001" and isLess = '1') or (op = "001010" and isEq = '1') or (op = "001011" and isEq = '0')) then
	NextPC = "10";
	elsif (J_Type = '1') then
		NextPC = "01";
		else
			NextPC = "00";
end if;

end process;

end Behavioral;


