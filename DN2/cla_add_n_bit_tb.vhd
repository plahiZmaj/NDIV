--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:01:02 11/09/2023
-- Design Name:   
-- Module Name:   C:/VHDL_Projekti/DN2/DN2/cla_add_n_bit_tb.vhd
-- Project Name:  DN2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cla_add_n_bit
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
USE ieee.numeric_std.ALL;
 
ENTITY cla_add_n_bit_tb IS
	generic(n: natural := 8);
END cla_add_n_bit_tb;
 
ARCHITECTURE behavior OF cla_add_n_bit_tb IS 
    COMPONENT cla_add_n_bit
    PORT(
         Cin : IN  std_logic;
         X : IN  std_logic_vector(n-1 downto 0);
         Y : IN  std_logic_vector(n-1 downto 0);
         S : OUT  std_logic_vector(n-1 downto 0);
         Gout : OUT  std_logic;
         Pout : OUT  std_logic;
         Cout : OUT  std_logic
        );
    END COMPONENT;

   signal Cin : std_logic := '0';
   signal X : std_logic_vector(n-1 downto 0) := (others => '0');
   signal Y : std_logic_vector(n-1 downto 0) := (others => '0');
	
	signal X_int, Y_int : integer range 0 to (2**n-1) := 0;

   signal S, S_comp : std_logic_vector(n-1 downto 0);
   signal Gout : std_logic;
   signal Pout : std_logic;
   signal Cout : std_logic;
 
BEGIN
   uut: cla_add_n_bit PORT MAP (
          Cin => Cin,
          X => X,
          Y => Y,
          S => S,
          Gout => Gout,
          Pout => Pout,
          Cout => Cout
        );

   stim_proc: process 
	begin		
		for i in 0 to (2**n)-1 loop
		X_int <= i;
		X <= std_logic_vector(to_unsigned(i, n));
			for j in 0 to (2**n)-1 loop		
				Y_int <= j;
				Y <= std_logic_vector(to_unsigned(j, n));
				wait for 1 ns;
				assert(S_comp = S) report "Test failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				exit when (S_comp /= S);
			end loop;
		end loop;
      wait;
   end process;

	-- Calculate sum for checking the adder result
	comp_proc: process (X_int, Y_int)
	begin
		S_comp <= std_logic_vector(to_unsigned((X_int + Y_int) mod 2**n, n));
	end process;
END;
