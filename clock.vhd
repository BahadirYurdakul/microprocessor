library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity clock is port(
	clock :			out std_logic;
	reset :			out std_logic);
end clock;

architecture imp of clock is
begin
	clock <= '1';
	reset <= '0';
end imp;