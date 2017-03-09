library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity databus is port(
	enable : 					in std_logic;
	datain :					in std_logic_vector(15 downto 0);
	dataout : 		 			out std_logic_vector(15 downto 0));
end databus;

architecture structural_databus of databus is
begin
    process(enable, datain)
    begin
        if(enable = '1') then
			dataout <= datain;
        else
			dataout <= (others => 'Z');
		end if;
    end process;
end structural_databus;
