library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_cla is
	generic( n: natural := 8 );
	port(	M		:	in 	std_logic;	--nacin delovanja '0' -> aritmeticni, '1' -> logicni			
			F		: 	in 	std_logic_vector(2 downto 0);	-- opcodes
			X, Y	:	in 	std_logic_vector(n-1 downto 0); -- vhodni vektorji
			S		:	out std_logic_vector(n-1 downto 0); -- izhodni vektor
			Negative, Cout, Overflow, Zero,	Gout, Pout :	out	std_logic ); -- status flags
end alu_cla;

architecture NDV of alu_cla is
	COMPONENT cla_add_n_bit IS
		generic(n: natural := 8);
		PORT (	Cin	:	in 	std_logic ;
				X, Y	:	in 	std_logic_vector(n-1 downto 0);
				S		:	out	std_logic_vector(n-1 downto 0);
				Gout,	Pout, Cout	:	out	std_logic);
	END COMPONENT;
	
	
	
	signal S_sig, Y_sig : std_logic_vector(n-1 downto 0); -- pomozni signali ker S in Y sta lahko negativna
	signal nAddSub : std_logic; -- izbira ali sestevamo ali odstevamo
	signal alu_operation : std_logic_vector(3 downto 0);  -- sestavimo skupaj mode select in opcode
	
	constant zeros : std_logic_vector(n-1 downto 0) := (others => '0');
	constant one   : std_logic_vector(n-1 downto 0) := (0 => '1', others => '0');
begin

	U1: cla_add_n_bit
		generic map (n => n)
		port map (
			Cin => nAddSub, X => X, Y => Y_sig, S => S_sig, Gout => Gout, Pout => Pout, Cout => Cout
		);
		
		nAddSub <= alu_operation(0);
		
		alu_operation <= M & F;
		
		
		-- enacba za overflow velja v obeh primerih pri odstevanju in sestevanju, ampak za Y uporabljamo Y_sig kar pomeni da je invertiran pri odstevanju
		Overflow <= (not X(n-1) and not Y_sig(n-1) and S_sig(n-1)) or (X(n-1) and Y_sig(n-1) and not S_sig(n-1));
		
		-- postavitev Negative flaga
		with alu_operation select Negative <=
			'1'			when "0101",
			X(n-1) 		when "1110",
			Y(n-1) 		when "1111",
			S_sig(n-1) 	when others;
		
		-- postavitev Zero flaga
		Zero <= '0' when alu_operation = "0101" else
				  '1' when alu_operation = "1110" and X = zeros else
				  '0' when alu_operation = "1110" and X /= zeros else
				  '1' when alu_operation = "1111" and Y = zeros else
				  '0' when alu_operation = "1111" and Y /= zeros else
				  '1' when S_sig = zeros else '0';
		
		with alu_operation select S <=
			S_sig 		when "0000",  -- S = X + Y
			S_sig 		when "0001",  -- S = X - Y
			S_sig 		when "0010",  -- S = X + 1
			S_sig 		when "0011",  -- S = X - 1
			S_sig 		when "0100",  -- S = X + X
			not zeros 	when "0101",  -- S = -1 , inv(0) = -1 v 2'K
			X and Y  	when "1000",  -- S = X and X
			X nand Y 	when "1001",  -- S = X nand X
			X or Y   	when "1010",  -- S = X or X
			X nor Y  	when "1011",  -- S = X nor X
			X xor Y  	when "1100",  -- S = X xor X
			X xnor Y 	when "1101",  -- S = X xnor X
			X 				when "1110",  -- S = X 
			Y 				when "1111",  -- S = Y
			zeros		   when others;  -- S = 0 v ostalih primerih
		
		-- Y lahko zasede vec vrednosti

		with alu_operation select Y_sig <=
					 Y when "0000", -- X + Y
				not Y when "0001", -- X - Y
				  one when "0010", -- X + 1
			 not one when "0011", -- X - 1
			       X when "0100", -- X + X
					 Y when others; -- pri logicnih operacijah je Y vedno Y
				 
end NDV;