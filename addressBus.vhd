library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity adressbus is port(
   enable : 		in std_logic;
   input : 			in std_logic_vector(15 downto 0);
   output : 		out std_logic_vector(15 downto 0));
end adressbus;

architecture behavioral_adressbus of adressbus is
signal addrptr: std_logic_vector(15 downto 0) := "0000000000000000";
begin
    process(enable, input)
    begin
        if(enable = '1') then
            output <= input;
		else
			output <= "XXXXXXXXXXXXXXXX";
        end if;
    end process;
end behavioral_adressbus;