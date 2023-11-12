LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
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
   constant clk_period : time := 10 ns; -- perioda clk signala
 
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
    while now < 1000 ns loop -- Simulacijski cas
      clk <= not clk;  -- Togglanje clock signala
      wait for clk_period;   -- Dolocanje periode
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
						Cin <= not Cin; -- flipamo bit
				end loop;
				
				y <= not y; -- flipamo bit
			end loop;
			
			x <= not x; --flipamo bit
		end loop;

      wait;
   end process;
	

END;
