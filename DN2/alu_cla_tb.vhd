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
	
	signal X_int, Y_int : integer := 0;
	signal S_comp, X_and_Y, 
			 X_nand_Y, X_or_Y, X_nor_Y, 
			 X_xor_Y, X_xnor_Y : std_logic_vector(n-1 downto 0) := (others => '0');
	signal Neg_F, Overflow_F, Zero_F : std_logic := '0';
 
	constant zeros : std_logic_vector(n-1 downto 0) := (others => '0');
 
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
			X_int <= i;
			X <= std_logic_vector(to_signed(i, n));
			for j in -(2**(n-1)) to 2**(n-1) - 1 loop
				Y_int <= j;
				Y <= std_logic_vector(to_signed(j, n));
				
				M <= '0'; -- Aritmeticni nacin
				F <= "000"; -- X + Y
				wait for 1 ns;
				assert(S_comp = S) report "Sum failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "Sum N failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Overflow_F = Overflow) report "Sum V failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "Sum Z failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "001"; -- X - Y
				wait for 1 ns;
				assert(S_comp = S) report "Dif failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "Dif N failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Overflow_F = Overflow) report "Dif V failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "Dif Z failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "010"; -- X + 1
				wait for 1 ns;
				assert(S_comp = S) report "X+1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "X+1 N failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Overflow_F = Overflow) report "X+1 V failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "X+1 Z failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "011"; -- X - 1
				wait for 1 ns;
				assert(S_comp = S) report "X-1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "X-1 N failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Overflow_F = Overflow) report "X-1 V failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "X-1 Z failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "100"; -- X + X
				wait for 1 ns;
				assert(S_comp = S) report "X+X failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "X+X N failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Overflow_F = Overflow) report "X+X V failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "X+X Z failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "101"; -- -1
				wait for 1 ns;
				assert(S_comp = S) report "-1 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "-1 N failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "-1 Z failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
								
				F <= "110"; -- undefined operation
				wait for 1 ns;
				assert(zeros = S) report "0110 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "111"; -- undefined operation
				wait for 1 ns;
				assert(zeros = S) report "0111 failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				M <= '1'; -- Logièni naèin
 				F <= "000"; -- X and Y
				wait for 1 ns;
				assert(X_and_Y = S) report "X and Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "001"; -- X nand Y
				wait for 1 ns;
				assert(X_nand_Y = S) report "X nand Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "010"; -- X or Y
				wait for 1 ns;
				assert(X_or_Y = S) report "X or Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "011"; -- X nor Y
				wait for 1 ns;
				assert(X_nor_Y = S) report "X nor Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "100"; -- X xor Y
				wait for 1 ns;
				assert(X_xor_Y = S) report "X xor Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "101"; -- X xnor Y
				wait for 1 ns;
				assert(X_xnor_Y = S) report "X xnor Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "110"; -- X
				wait for 1 ns;
				assert(X = S) report "X failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "X N failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "X Z failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				
				F <= "111"; -- Y
				wait for 1 ns;
				assert(Y = S) report "Y failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Neg_F = Negative) report "Y N failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
				assert(Zero_F = Zero) report "Y Z failed. X:" & integer'image(i) & " Y:" & integer'image(j) severity error;
			end loop;
		end loop;
      wait;
   end process;
	
	-- racunanje za preverit pravilnost 
	assert_proc: process (X_int, Y_int, F)
	variable S_temp, X_temp, Y_temp : std_logic_vector(n-1 downto 0);
	variable Res_temp : integer;
	begin
		X_temp := std_logic_vector(to_signed(X_int, n));
		Y_temp := std_logic_vector(to_signed(Y_int, n));
		
		case F is
			-- S -> -1 v 2'K 
			when "101" =>  
				S_temp := not zeros;
            Overflow_F <= '0';
            
      when others =>
            
			case F is
				when "000" =>
					Res_temp := X_int + Y_int;
            when "001" =>
               Res_temp := X_int - Y_int;
            when "010" =>
               Res_temp := X_int + 1;
            when "011" =>
               Res_temp := X_int - 1;
            when "100" =>
               Res_temp := X_int + X_int;
            when "110" =>
               Res_temp := X_int;
            when "111" =>
               Res_temp := Y_int;
            when others =>
               Res_temp := 0;
			end case;
            
				-- preverjanje overflowa 
            if Res_temp > 2**(n-1) - 1 or Res_temp < -(2**(n-1)) then
					Overflow_F <= '1';
				else
					Overflow_F <= '0';
				end if;
			
			-- potrebno je odsteti 2**(n-1) ce gremo cez, ali pristeti ce gremo pod -2**(n-1)
			-- to se da resiti tudi z modulo operacijo
			S_temp := std_logic_vector(to_unsigned(Res_temp mod 2**n , n));
		end case;

		
		
		S_comp <= S_temp;
		Neg_F <= S_temp(n-1);
		
		if S_temp = zeros then
			Zero_F <= '1';
		else
			Zero_F <= '0';
		end if;
		
		X_and_Y <= X_temp and Y_temp;
		X_nand_Y <= X_temp nand Y_temp;
		X_or_Y <= X_temp or Y_temp;
		X_nor_Y <= X_temp nor Y_temp;
		X_xor_Y <= X_temp xor Y_temp;
		X_xnor_Y <= X_temp xnor Y_temp;
		
	end process;

END;