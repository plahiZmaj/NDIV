library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reduction_operators_tb is
generic (	N: natural := 3 );
end reduction_operators_tb;

architecture test of reduction_operators_tb is
	
	component reduction_operators  is
		generic (	N: Natural := 10 );
		port (	A: in STD_LOGIC_VECTOR (N-1 DOWNTO 0);
					reduced_OR, reduced_AND, reduced_XOR: out STD_LOGIC);
	end component;
	
	constant ZERO  : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := ( others => '0');
	constant ONE   : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (0 => '1', others => '0');
	constant TWO   : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (1 => '1', others => '0');
	constant THREE : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (0 | 1 => '1', others => '0');
	constant FOUR  : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (2 => '1', others => '0');
	constant FIVE  : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (0 | 2 => '1', others => '0');
	constant SIX   : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (1 | 2 => '1', others => '0');
	constant SEVEN : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (0 | 1 | 2 => '1', others => '0');
	
	signal A: STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	signal reduced_OR, reduced_AND, reduced_XOR: STD_LOGIC;
begin

	UUT: reduction_operators
	generic map (N => N)
	port map (
		A => A,
		reduced_OR => reduced_OR,
		reduced_AND => reduced_AND,
		reduced_XOR => reduced_XOR
	);
	
	stim_proc: process
	begin
	
		A <= ZERO;
		wait for 150 ns;
		
		A <= ONE;
		wait for 50 ns;
		
		A <= TWO;
		wait for 100 ns;
		
		A <= FOUR;
		wait for 50 ns;
		
		A <= FIVE;
		wait for 50 ns;
		
		A <= SIX;
		wait for 50 ns;
		
		A <= SEVEN;
		wait;
	
	end process;
end test;