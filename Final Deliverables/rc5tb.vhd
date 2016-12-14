--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:24:58 12/13/2016
-- Design Name:   
-- Module Name:   E:/Rishu/Hrishi/NYU/Courses/Sem 1/AHD/Labs/Codes/mipsproc/rc5tb.vhd
-- Project Name:  mipsproc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MIPSProc
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY rc5tb IS
END rc5tb;
 
ARCHITECTURE behavior OF rc5tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MIPSProc
    PORT(
         clk : IN  std_logic;
         clr : IN  std_logic;
         finalout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '1';
   signal clr : std_logic := '1';

 	--Outputs
   signal finalout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 500 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MIPSProc PORT MAP (
          clk => clk,
          clr => clr,
          finalout => finalout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 700 ns;	
		clr <= '0';
		
--      wait for clk_period*10;

      -- insert stimulus here 

--      wait;
   end process;

END;
