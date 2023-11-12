LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY alu_cla_tb IS
	GENERIC( n: natural := 8 );
END alu_cla_tb;
 
ARCHITECTURE behavior OF alu_cla_tb IS 
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
	
	
	-- pomozni signali za preverjat v assert
	signal S_assert, X_and_Y, X_nand_Y, X_or_Y, X_nor_Y, X_xor_Y, X_xnor_Y : std_logic_vector(n-1 downto 0) := (others => '0');
	
	-- status flagi za preverjat v assert
	signal Neg_F, Overflow_F, Zero_F : std_logic := '0';
 
	constant zeros : std_logic_vector(n-1 downto 0) := (others => '0');
	constant one   : std_logic_vector(n-1 downto 0) := (0 => '1', others => '0');
 
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
	
		for i in -(2**(n-1)) to 2**(n-1) - 1 loop
			
			X <= std_logic_vector(to_signed(i, n));
			
			for j in -(2**(n-1)) to 2**(n-1) - 1 loop
				
				Y <= std_logic_vector(to_signed(j, n)); 
				
				
				
				-------------------------------------------- ADRITMETICNE OPERACIJE --------------------------------------------------------                            		
				
				M <= '0'; -- M = 0 -> Aritmeticni nacin
				F <= "000"; -- S = X + Y
				
				wait for 5 ns;
				assert(S_assert = S) report "Assert vsote failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "N flag vsote failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Overflow_F = Overflow) report "V flag vsote failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "Z flag vsote failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "001"; -- S = X - Y
				wait for 5 ns;
				assert(S_assert = S) report "Assert razlike failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "N flag razlike failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Overflow_F = Overflow) report "V flag razlike failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "Z flag razlike failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "010"; -- S = X + 1
				wait for 5 ns;
				assert(S_assert = S) report "Assert X + 1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "N flag X + 1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Overflow_F = Overflow) report "V flag X + 1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "Z flag X + 1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "011"; -- S = X - 1
				wait for 5 ns;
				assert(S_assert = S) report "Assert X - 1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "N flag X - 1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Overflow_F = Overflow) report "V flag X - 1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "Z flag X - 1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "100"; -- S = X + X
				wait for 5 ns;
				assert(S_assert = S) report "Assert X + X failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "N flag X + X failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Overflow_F = Overflow) report "V flag X + X failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "Z flag X + X failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "101"; --  S = -1
				wait for 5 ns;
				assert(S_assert = S) report "Assert -1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "N flag -1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				-- nerabimo gledat overflowa pri tej operaciji
				assert(Zero_F = Zero) report "Z flag -1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
								
				F <= "110"; -- ne uporabljeno
				wait for 5 ns;
				assert(zeros = S) report "0110 (neuporabljeno) failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "111"; -- ne uporabljeno
				wait for 5 ns;
				assert(zeros = S) report "0111 (neuporabljeno) failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				
				-------------------------------------------- LOGICNE OPERACIJE --------------------------------------------------------
				
				
				M <= '1'; -- M = 1 -> logicni nacin
 				F <= "000"; -- S = X and Y
				wait for 5 ns;
				assert(X_and_Y = S) report "X and Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "001"; -- S = X nand Y
				wait for 5 ns;
				assert(X_nand_Y = S) report "X nand Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "010"; -- S = X or Y
				wait for 5 ns;
				assert(X_or_Y = S) report "X or Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "011"; -- S = X nor Y
				wait for 5 ns;
				assert(X_nor_Y = S) report "X nor Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "100"; -- S = X xor Y
				wait for 5 ns;
				assert(X_xor_Y = S) report "X xor Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "101"; -- S = X xnor Y
				wait for 5 ns;
				assert(X_xnor_Y = S) report "X xnor Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "110"; -- S = X
				wait for 5 ns;
				assert(S_assert = S) report " S = X failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "S = X N flag failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "S = X Z flag failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "111"; -- S = Y
				wait for 5 ns;
				assert(S_assert = S) report " S = Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "S = Y N flag failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "S = Y Z flag failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
			
			end loop;
		
		end loop;
      wait;
   
	end process;
	
	-- proces racunanja za preverit pravilnost 
	assert_proc: process ( X, Y, F)
	
	variable S_temp : std_logic_vector(n-1 downto 0);
	variable S_int : integer;
	
	begin
		
		case F is
			-- S -> -1 v 2'K 
			when "101" =>  
				S_temp := not zeros;  -- -1 v 2'K
            Overflow_F <= '0';    -- overflowa ni
            
      when others =>
            
			case F is
				when "000" =>
					S_int := to_integer(signed(X)) + to_integer(signed(Y));
            when "001" =>
               S_int := to_integer(signed(X)) - to_integer(signed(Y));
            when "010" =>
               S_int := to_integer(signed(X)) + 1;
            when "011" =>
               S_int := to_integer(signed(X)) - 1;
            when "100" =>
               S_int := to_integer(signed(X)) + to_integer(signed(X));
            when "110" =>
               S_int := to_integer(signed(X));
            when "111" =>
               S_int := to_integer(signed(Y));
            when others =>
               S_int := 0;
			end case;
            
				-- preverjanje overflowa 
            if S_int > 2**(n-1) - 1 or S_int < -(2**(n-1)) then
					Overflow_F <= '1';
				else
					Overflow_F <= '0';
				end if;
			
			-- potrebno je odrezati bite ce je prislo do overflowa
			S_temp := std_logic_vector(to_unsigned(S_int mod 2**n , n));
		
		end case;

		-- postavimo zastavico ce je izhod negativen
		Neg_F <= S_temp(n-1);
		
		-- postavimo izhod za assertat
		S_assert <= S_temp;
		
		-- postavimo zastavico ce je izhod = 0
		if S_temp = zeros then
			Zero_F <= '1';
		else
			Zero_F <= '0';
		end if;
		
		-- logicne 
		X_and_Y <= X and Y;
		X_nand_Y <= X nand Y;
		X_or_Y <= X or Y;
		X_nor_Y <= X nor Y;
		X_xor_Y <= X xor Y;
		X_xnor_Y <= X xnor Y;
		
	end process;

END;