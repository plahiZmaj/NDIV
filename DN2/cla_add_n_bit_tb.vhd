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
	
	-- pomozni signali
   signal Cin : std_logic := '0';
   signal X : std_logic_vector(n-1 downto 0) := (others => '0');
   signal Y : std_logic_vector(n-1 downto 0) := (others => '0');
	
	
	-- pomozni signali
   signal S, S_assert : std_logic_vector(n-1 downto 0);
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
		  
	-- racunanje vrednosti da lahko assertamo

   stim_proc: process 
	begin	
	
		for i in 0 to (2**n)-1 loop
		
		X <= std_logic_vector(to_unsigned(i, n));
			
			for j in 0 to (2**n)-1 loop		
				
				Y <= std_logic_vector(to_unsigned(j, n));
				
				
				-- izracunamo pricakovano vrednost, vsota lahko overflowa cez n bitov zato rabimo mod operacijo da odrezemo odvecne bite
				S_assert <= std_logic_vector(to_unsigned((i + j) mod 2**n, n));
					
					-- preverimo ali je izhod adderja enak izracunani vrednosti
					assert(S_assert = S) report "Assert failed. X -> " & integer'image(i) & " Y -> " & integer'image(j) severity error;
				
				exit when (S_assert /= S);
			
			wait for 5 ns;
			end loop;
		
		end loop;
      
		wait;
   end process;

	
END;
