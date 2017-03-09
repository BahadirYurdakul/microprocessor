library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mux4_16bit is port(
	S : 				in std_logic_vector(1 downto 0);
	x0, x1, x2, x3 :	in std_logic_vector (15 downto 0);
    y : 				out std_logic_vector (15 downto 0));
end mux4_16bit;

architecture behavioral of mux4_16bit is
begin
	process(S,x0,x1,x2,x3)       
	begin
		case S is
			when "00" => y <= x0;
			when "01" => y <= x1;
			when "10" => y <= x2;
			when others => y <= x3;		
		end case;			
	end process;
end behavioral;
