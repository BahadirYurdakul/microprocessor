library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity uPabs3 is port(
	clk :								in std_logic;
	rst :								in std_logic;
	int :								in std_logic;
	
	wr :								out std_logic;
	rd :								out std_logic;
	opfetch :							out std_logic;
	A :									out std_logic_vector(15 downto 0);
	Din :								in std_logic_vector(15 downto 0);
	Dout :								out std_logic_vector(15 downto 0));
end uPabs3;

architecture imp of uPabs3 is
	---------------------------------------------------------
	signal ALUselSig :				std_logic_vector (4 downto 0);
	signal IRoutputSig : 			std_logic_vector(4 downto 0);
	signal SselSig :				std_logic_vector (1 downto 0);
	signal RselSig :				std_logic_vector (1 downto 0);
	signal PselSig :				std_logic_vector (1 downto 0);
	signal DselSig :				std_logic_vector (1 downto 0);
	signal aenSig : 				std_logic;
	signal den1Sig :  				std_logic;
	signal den2Sig :  				std_logic;
	signal pcenSig :	 			std_logic;
	signal PCloadSig: 				std_logic;
	signal SPloadSig: 				std_logic;
	signal IRloadSig : 				std_logic;
	signal jmpMuxSig : 				std_logic;
	signal Sub2Sig : 				std_logic;
	signal rbeSig : 				std_logic;
	signal raeSig : 				std_logic;
	signal weSig : 					std_logic;
	signal zeroSig :				std_logic;
	signal Dsig : 					std_logic_vector(15 downto 0);
	---------------------------------------------------------------

	component dataPath is port(
		clk : 							in std_logic;
		reset : 						in std_logic;
		den1: 							in std_logic;
		den2: 							in std_logic;
		aen: 							in std_logic;
		pcen: 							in std_logic;
		SPload: 						in std_logic;
		PCload : 						in std_logic;
		IRload : 						in std_logic;
		Psel : 							in std_logic_vector(1 downto 0);
		Dsel :							in std_logic_vector(1 downto 0);
		Ssel : 							in std_logic_vector(1 downto 0);
		ALUsel : 						in std_logic_vector (4 downto 0);
		Rsel : 							in std_logic_vector(1 downto 0);
		sub2: 							in std_logic;
		jmpMux : 						in std_logic;
		rbe : 				  			in std_logic;
		rae : 				 			in std_logic;
		we : 							in std_logic;
		int :							in std_logic;
		
		zero: 				  			out std_logic;
		inDatabus:						in std_logic_vector(15 downto 0);
		outDatabus: 					out std_logic_vector(15 downto 0);
		IRoutput: 						out std_logic_vector (4 downto 0);
		outAddressBus: 					out std_logic_vector(15 downto 0));
	end component;
	
	component controller is port(
		clk:								in std_logic;
		rst:								in std_logic;
		zero:								in std_logic;
		IR:									in std_logic_vector(4 downto 0);
		int:								in std_logic;
		
		ALUsel:								out std_logic_vector (4 downto 0);
		Ssel:								out std_logic_vector (1 downto 0);
		Rsel:								out std_logic_vector (1 downto 0);
		Psel:								out std_logic_vector (1 downto 0);
		Dsel :								out std_logic_vector (1 downto 0);
		aen:								out std_logic;
		den1:								out std_logic;
		den2:								out std_logic;
		pcen:								out std_logic;
		opfetch:							out std_logic;
		PCload:								out std_logic;
		SPload:								out std_logic;
		IRload:								out std_logic;
		wR:									out std_logic;
		RD:									out std_logic;
		jmpMux:								out std_logic;
		Sub2:								out std_logic;
		rbe:								out std_logic;
		rae:								out std_logic;
		we:									out std_logic);
	end component;

begin
	
	C_CONTROLLER : controller port map(
		clk=>clk, 
		rst=>rst, 
		zero=>zeroSig, 
		IR=>IRoutputSig, 
		int=>int,
		ALUsel=>ALUselSig, 
		Ssel=>SselSig, 
		Rsel=>RselSig, 
		Psel=>PselSig, 
		Dsel=>DselSig,
		aen=>aenSig, 
		den1=>den1Sig, 
		den2=>den2Sig, 
		pcen=>pcenSig, 
		opfetch=>opfetch, 
		PCload=>PCloadSig, 
		SPload=>SPloadSig, 
		IRload=>IRloadSig, 
		WR=>wr, 
		RD=>rd, 
		jmpMux=>jmpMuxSig, 
		sub2=>Sub2Sig, 
		rbe=>rbeSig, 
		rae=>raeSig, 
		we=>weSig);
		
	C_DATAPATH : dataPath port map(
		clk=>clk,
		reset=>rst, 
		den1=>den1Sig, 
		den2=>den2Sig, 
		aen=>aenSig, 
		pcen=>pcenSig, 
		SPload=>SPloadSig, 
		PCload=>PCloadSig, 
		IRload=>IRloadSig, 
		Psel=>PselSig,
		Dsel=>DselSig,		
		Ssel=>SselSig, 
		ALUsel=>ALUselSig, 
		Rsel=>RselSig, 
		sub2=>Sub2Sig, 
		jmpMux=>jmpMuxSig, 
		rbe=>rbeSig, 
		rae=>raeSig, 
		we=>weSig, 
		int=>int,
		zero=>zeroSig, 
		inDatabus=>Din,
		outDatabus=>Dout,
		IRoutput=>IRoutputSig, 
		outAddressBus=>A);
		
end imp;