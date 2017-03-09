library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity AE is port(
	S:				in std_logic_vector(2 downto 0);
	a, b:			in std_logic;
	y:				out std_logic);
end AE;

architecture imp of AE is
begin
	process(S, a, b)
	begin
		case S is
			when "100" => y <= b;
			when "101" => y <= not b;
			when "110" => y <= '0';
			when "111" => y <= '1';
			when others => y <= '0';
		end case;
	end process;
end imp;