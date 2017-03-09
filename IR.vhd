library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity IR_16bit is port(
	clk : 			in std_logic;
	reset :			in std_logic;
	load : 			in std_logic;
	INPUT : 		in std_logic_vector (15 downto 0);
	OUTPUT : 		out std_logic_vector (15 downto 0));
end IR_16bit;

architecture imp of IR_16bit is
begin
	process(clk,reset)
	begin
		if(clk'EVENT and clk='1') then
			if(reset='1') then
				OUTPUT <= "0000000000000000";
			elsif(load = '1') then
				OUTPUT <= INPUT;
			end if;
		end if;
	end process;
end imp;
