LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_MISC.ALL; -- reduction operators ( AND_REDUCE, OR_REDUCE )

ENTITY cla_add_n_bit IS
	generic( n: natural := 8 );
	PORT (Cin : in std_logic ;
	X, Y : in std_logic_vector(n-1 downto 0);
	S : out std_logic_vector(n-1 downto 0);
	Gout, Pout, Cout : out std_logic );
END cla_add_n_bit;

ARCHITECTURE NDV OF cla_add_n_bit IS
	COMPONENT cla_gp IS
	PORT ( Cin, x, y : IN STD_LOGIC;
	s, Cout, g, p : OUT STD_LOGIC );
	END COMPONENT;
	
	-- vektor vmesnih prenosov in funkcij tvorjenja in sirjenja
	SIGNAL G, P : STD_LOGIC_VECTOR( n-1 DOWNTO 0 );
	SIGNAL S_sig : STD_LOGIC_VECTOR( n-1 DOWNTO 0 );
	SIGNAL Gint : STD_LOGIC_VECTOR( n-1 DOWNTO 1 );
	SIGNAL C : STD_LOGIC_VECTOR( n DOWNTO 0 );

BEGIN

	-- zacetni carry
	C(0) <= Cin;
	
	stages: FOR i IN 0 TO (n-1) GENERATE
		G(i) <= X(i) and Y(i); -- funkcija tvorjenja generate
		P(i) <= X(i) xor Y(i); -- funkcija sirjenja propagate  
		S_sig(i) <= X(i) xor Y(i) xor C(i); -- vsota 
		C(i+1) <= G(i) or ( P(i) and C(i) ); -- izhodni prenos 
	END GENERATE;
	
	g_stages: FOR i IN 1 TO (n-1) GENERATE
		g_stage: Gint(i) <= AND_REDUCE(P(n-1 downto i)) and G (i-1); -- enacba iz navodil
	END GENERATE;
	
	Pout <= AND_REDUCE (P);
	Gout <= G(n-1) or OR_REDUCE(Gint);
	S <= S_sig;
	Cout <= C(n);
	
END NDV;