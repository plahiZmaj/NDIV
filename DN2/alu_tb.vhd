LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY alu_tb IS
	GENERIC( n: natural := 8 );
END alu_tb;
 
ARCHITECTURE behavior OF alu_tb IS 
    COMPONENT alu_cla
	 GENERIC( n: natural := 8 );
    PORT(
         M : IN  std_logic;
         F : IN  std_logic_vector(2 downto 0);
         X : IN  std_logic_vector(n-1 downto 0);
         Y : IN  std_logic_vector(n-1 downto 0);
         S : OUT  std_logic_vector(n-1 downto 0);
         Negative : OUT  std_logic;
         Cout : OUT  std_logic;
         Overflow : OUT  std_logic;
         Zero : OUT  std_logic;
         Gout : OUT  std_logic;
         Pout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal M : std_logic := '0';
   signal F : std_logic_vector(2 downto 0) := (others => '0');
   signal X : std_logic_vector(n-1 downto 0) := (others => '0');
   signal Y : std_logic_vector(n-1 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(n-1 downto 0);
   signal Negative : std_logic;
   signal Cout : std_logic;
   signal Overflow : std_logic;
   signal Zero : std_logic;
   signal Gout : std_logic;
   signal Pout : std_logic;
	
	-- Pomozni signali za assert
	signal S_int, X_int, Y_int : integer := 0;
	signal S_assert : std_logic_vector(n-1 downto 0) := (others => '0');
	--signal Overflow_F : std_logic := '0';
 
BEGIN
   uut: alu_cla 
	GENERIC MAP (n => n)
	PORT MAP (
          M => M,
          F => F,
          X => X,
          Y => Y,
          S => S,
          Negative => Negative,
          Cout => Cout,
          Overflow => Overflow,
          Zero => Zero,
          Gout => Gout,
          Pout => Pout
        );
		  
   stim_proc: process
   begin
		-- loop
		for i in 0 to 2**n - 1 loop
			
			X <= std_logic_vector(to_unsigned(i, n));
			X_int <= i;  -- int vrednost trenutnega X
			
			for j in 0 to 2**n - 1 loop
				
				Y <= std_logic_vector(to_unsigned(j, n));
				Y_int <= j; -- int vrednost trenutnega Y
				
				F <= "000"; -- S = X + Y
				wait for 5 ns;
				-- assertamo izhod
				assert(S_assert = S) report "Assert za vsoto failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "001"; -- S = X - Y
				wait for 5 ns;
				-- assertamo izhod
				assert(S_assert = S) report "Assert za razliko failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
			
			end loop;
		
		end loop;
      wait;
   
	end process;
	
	
	assert_proc: process (X_int, Y_int, F)
	begin
		
		if F(0) = '0' then
			S_assert <= std_logic_vector(to_unsigned((X_int + Y_int) mod 2**n, n));
		else
			S_assert <= std_logic_vector(to_unsigned((X_int - Y_int) mod 2**n, n));
		end if;
	
		
	
	end process;
	

END;