library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity testbench is port(
	adresbusout :					out std_logic_vector(15 downto 0);
	databusout :						out std_logic_vector(15 downto 0));
end testbench;

architecture imp of testbench is
	
	signal clockSig :				std_logic;
	signal resetSig :				std_logic;
	signal wrSig :					std_logic;
	signal rdSig :					std_logic;
	signal opfetchSig :				std_logic;
	signal intSig :					std_logic;
	signal addressSig :				std_logic_vector(15 downto 0);
	signal dataSig :				std_logic_vector(15 downto 0);
	signal dataoutSig :				std_logic_vector(15 downto 0);
	signal ramdosig :				std_logic_vector(15 downto 0);
	signal muxSig :					std_logic_vector(15 downto 0);
	signal muxS :					std_logic_vector(1 downto 0);
	
	component uPabs3 is port(
		clk :							in std_logic;
		rst :							in std_logic;
		int :							in std_logic;
		
		wr :							out std_logic;
		rd :							out std_logic;
		opfetch :						out std_logic;
		A :								out std_logic_vector(15 downto 0);
		Din :							in std_logic_vector(15 downto 0);
		Dout :							out std_logic_vector(15 downto 0));
	end component;
	
	component ROM_1024_16 is port ( 
		oe:								in std_logic;
		address : 						in std_logic_vector(15 downto 0);
		data : 							out std_logic_vector(15 downto 0));
	end component;
	
	component clock is port(
		clock :							out std_logic;
		reset :							out std_logic);
	end component;
	
	component RAM is port(
		cs:        						in std_logic;
		wr:       					 	in std_logic;
		rd:								in std_logic;
		addr:     				 		in std_logic_vector(15 downto 0); 
		di:        						in std_logic_vector(15 downto 0);
		do:       						out std_logic_vector(15 downto 0));
	end component;
	
	component mux4_16bit is port(
		S : 						in std_logic_vector(1 downto 0);
		x0,x1,x2,x3 : 				in std_logic_vector (15 downto 0);
		y :				 			out std_logic_vector (15 downto 0));
	end component;
begin
	muxS <= '0' & opfetchSig;
	ROM : ROM_1024_16 port map(oe=>opfetchSig, address=>addressSig, data=>dataSig);
	MUX : mux4_16bit port map(S=> muxS, x0=>ramdosig, x1=>dataSig, x2=>"XXXXXXXXXXXXXXXX", x3=>"XXXXXXXXXXXXXXXX", y=>muxSig);
	C_RAM : RAM port map(cs=>'1', wr=>wrSig, rd=>rdSig, addr=>addressSig, di=>dataoutSig, do=>ramdosig);
	C_UPABS3 : uPabs3 port map(clk=>clockSig, rst=>resetSig, int=>intSig, wr=>wrSig, rd=>rdSig, opfetch=>opfetchSig, A=>addressSig, Din=>muxSig, Dout=>dataoutSig);
	C_CLOCK : clock port map(clock=>clockSig, reset=>resetSig);
	adresbusout <= addressSig;
	databusout <= dataoutSig;
end imp;