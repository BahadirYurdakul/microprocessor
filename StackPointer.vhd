library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SP is port(
	clk : 			in std_logic;
	reset : 		in std_logic;
	SPload : 		in std_logic;
	INPUT : 		in std_logic_vector (15 downto 0);
	OUTPUT : 		out std_logic_vector (15 downto 0));
end SP;

architecture beh of SP is

signal stackptr: std_logic_vector(15 downto 0) := "0000000011111111";

begin
	process(clk,reset)
	begin
		if(clk'EVENT and clk='1') then
			if(reset='1') then
				stackptr <= "1111111111111111";
			elsif(SPload = '1') then
				stackptr <= INPUT;
			end if;
		end if;
		OUTPUT <= stackptr;
	end process;
end beh;