library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity PC is port(
	clk : 			in std_logic;
	reset : 		in std_logic;
	load : 			in std_logic;
	INPUT :			in std_logic_vector (15 downto 0);
	OUTPUT : 		out std_logic_vector (15 downto 0));
end PC;

architecture beh of PC is
signal reg :			std_logic_vector(15 downto 0) := "0000000000000000";

begin
	process(clk,reset)
	begin
		if(clk'EVENT and clk='1') then
			if(reset='1') then
				reg <= "0000000000000000";
			elsif(load = '1') then
				reg <= INPUT;
			end if;
		OUTPUT <= reg;
		end if;
	end process;
end beh;