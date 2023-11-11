library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Unary_Op_Bin_Tree_tb is
generic ( N: natural := 16 );
end Unary_Op_Bin_Tree_tb;

architecture tb of Unary_Op_Bin_Tree_tb is

	component Unary_Op_Bin_Tree IS
	generic (N : natural := 16);
	port (	I : std_logic_vector(N - 1 downto 0);
				O_Xor : OUT std_logic);
	END component;

	signal I : std_logic_vector (N - 1 DOWNTO 0) := (others => '0');  -- zaceten input nastavimo na 0
	signal O_Xor : STD_LOGIC;   
			
begin

	UUT: Unary_Op_Bin_Tree
	generic map ( N )
	port map (I, O_Xor);
	
	stim_proc: process
	variable O_Comp : std_logic;
	begin
	-- for zanka ki nastavi vrednost inputa 
	-- od 0 do 2^n - 1 to je tudi najvecja vrednost int
		for idx in 0 to 2**N - 1 loop
			I <= std_logic_vector(to_unsigned(idx, I'length)); -- to_unsigned(vrednost, velikost)
			-- delay
			wait for 50 ns;
		end loop;
		wait;
	end process;
	
end tb;