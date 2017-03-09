library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package opcodes is
	subtype t_cond is std_logic_vector(4 downto 0);
	
	constant s_mov		:	t_cond := "00000";
	constant s_add		:	t_cond := "00001";
	constant s_sub		:	t_cond := "00010";
	constant s_and		:	t_cond := "00011";
	constant s_or		:	t_cond := "00100";
	constant s_not		:	t_cond := "00101";
	constant s_inc		:	t_cond := "00110";
	constant s_dec		:	t_cond := "00111";
	constant s_sr		:	t_cond := "01000";
	constant s_sl		:	t_cond := "01001";
	constant s_rr		:	t_cond := "01010";
	constant s_clear	:	t_cond := "01011";
	constant s_jmp		:	t_cond := "01100";
	constant s_jz		:	t_cond := "01101";
	constant s_jnz		:	t_cond := "01110";
	constant s_call		:	t_cond := "01111";
	constant s_ret		:	t_cond := "10000";
	constant s_nop		:	t_cond := "10001";
	constant s_halt		:	t_cond := "10010";
	constant s_push		:	t_cond := "10011";
	constant s_pop		:	t_cond := "10100";
	constant s_write	:	t_cond := "10101";
	constant s_read		:	t_cond := "10110";
	constant s_movi		:	t_cond := "10111";
	
	--register name
	subtype t_oreg is std_logic_vector (2 downto 0);
	
	constant A			:	t_oreg := "000";
	constant B			:	t_oreg := "001";
	constant C			:	t_oreg := "010";
	constant D			:	t_oreg := "011";
	constant E			:	t_oreg := "100";
	constant F			:	t_oreg := "101";
	constant G			:	t_oreg := "110";
	constant H			:	t_oreg := "111";
end opcodes;