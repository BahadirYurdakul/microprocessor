library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.opcodes.all;

entity ROM_1024_16 is port ( 
	oe:				in std_logic;
	address : 		in std_logic_vector(15 downto 0);
	data : 			out std_logic_vector(15 downto 0));
end ROM_1024_16;

architecture imp of ROM_1024_16 is

	subtype cell is std_logic_vector(15 downto 0);
	type rom_type is array(0 to 6) of cell;
	
	constant ROM_1024_16: rom_type :=(
		s_nop & "00000000000",
		s_movi & A & "11111111",
                s_push & "XXXXXX" & A & "XX",
		s_push & "XXXXXX" & A & "XX",
		s_read & B & A & "XXXXX",  --READ RAM(A) ,WRITE INTO REGISTER B.
		s_pop & C & "XXXXXXXX",
		s_jmp & "10000000111"
	);
begin
		process(oe,address)
		begin
			if(oe = '1') then
				data <= ROM_1024_16(conv_integer(address));
			--else
				--data <= (others => 'Z');
			end if;
		end process;
end imp;
