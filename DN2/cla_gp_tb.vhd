--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:49:22 11/09/2023
-- Design Name:   
-- Module Name:   C:/VHDL_Projekti/DN2/DN2/cla_gp_tb.vhd
-- Project Name:  DN2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cla_gp
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
 
ENTITY cla_gp_tb IS
END cla_gp_tb;
 
ARCHITECTURE behavior OF cla_gp_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cla_gp
    PORT(
         Cin : IN  std_logic;
         x : IN  std_logic;
         y : IN  std_logic;
         S : OUT  std_logic;
         Cout : OUT  std_logic;
         g : OUT  std_logic;
         p : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Cin : std_logic := '0';
   signal x : std_logic := '0';
   signal y : std_logic := '0';

 	--Outputs
   signal S : std_logic;
   signal Cout : std_logic;
   signal g : std_logic;
   signal p : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name

	signal clk : std_logic := '0'; -- Initialize the clock signal to '0'
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cla_gp PORT MAP (
          Cin => Cin,
          x => x,
          y => y,
          S => S,
          Cout => Cout,
          g => g,
          p => p
        );

   -- Clock process definitions
   clk_process :process
  begin
    while now < 1000 ns loop -- Adjust the simulation time as needed
      clk <= not clk;  -- Toggle the clock signal
      wait for clk_period;   -- Adjust the clock period as needed
    end loop;
    wait;
  end process;
	 

   -- Stimulus process
   stim_proc: process
   begin

		-- loop za testirat
      for i in 0 to 1 loop
			
			for j in 0 to 1 loop
				
				for k in 0 to 1 loop
					
					wait for clk_period;
						Cin <= not Cin; -- invertiramo
				end loop;
				
				y <= not y; -- invertiramo
			end loop;
			
			x <= not x; --invertiramo
		end loop;

      wait;
   end process;
	

END;
