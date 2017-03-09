library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dataPath is port(
	clk : 						in std_logic;
	reset : 					in std_logic;
	den1: 						in std_logic;
	den2: 						in std_logic;
	aen: 						in std_logic;
	pcen: 						in std_logic;
	SPload: 					in std_logic;
	PCload : 					in std_logic;
	IRload : 					in std_logic;
	Psel : 						in std_logic_vector(1 downto 0);
	Dsel :						in std_logic_vector(1 downto 0);
	Ssel : 						in std_logic_vector(1 downto 0);
	ALUsel : 					in std_logic_vector (4 downto 0);
	Rsel : 						in std_logic_vector(1 downto 0);
	sub2: 						in std_logic;
	jmpMux : 					in std_logic;
	rbe : 				  		in std_logic;
	rae : 				 		in std_logic;
	we : 						in std_logic;
	int :						in std_logic;
	
	zero: 				  		out std_logic;
	inDatabus:					in std_logic_vector(15 downto 0);
	outDatabus: 				out std_logic_vector(15 downto 0);
	IRoutput: 					out std_logic_vector (4 downto 0);
	outAddressBus: 				out std_logic_vector(15 downto 0)
);
end dataPath;

architecture struct of dataPath is
-----------------SIGNALS-------------------
signal mux1 : 						std_logic_vector (15 downto 0);
signal mux2 :						std_logic_vector (15 downto 0); 
signal mux3 : 						std_logic_vector (15 downto 0);
signal mux4 : 						std_logic_vector (15 downto 0);
signal mux5 : 						std_logic_vector (15 downto 0);
signal pcSignal : 					std_logic_vector (15 downto 0);
signal stackPSignal : 				std_logic_vector (15 downto 0);
signal addSubSignal : 				std_logic_vector (15 downto 0);
signal addSub2Signal : 				std_logic_vector (15 downto 0);
signal irSignal : 					std_logic_vector (15 downto 0);
signal aluSignal : 					std_logic_vector (15 downto 0);
signal portA : 						std_logic_vector (15 downto 0);
signal portB : 						std_logic_vector (15 downto 0);
signal mux02in : 					std_logic_vector (15 downto 0);
signal dataSignal :					std_logic_vector (15 downto 0);
signal buffSignal :					std_logic_vector (15 downto 0);
signal mux6 :						std_logic_vector (15 downto 0);

signal mux06S :						std_logic;
signal mux02S :						std_logic_vector (1 downto 0);
signal wa : 						std_logic_vector (2 downto 0);
signal raa: 						std_logic_vector (2 downto 0);
signal rba: 						std_logic_vector (2 downto 0);
signal AluSel2:						std_logic_vector (4 downto 0);
signal AluSel3:						std_logic_vector (4 downto 0);

signal mux03S :      				std_logic_vector (15 downto 0);
signal signed_overflow : 			std_logic;
signal unsigned_overflow :  		std_logic;
signal carry :	 					std_logic;
signal subSignal : 					std_logic;
------------- RegisterFile ---------------
component regfile is port(
   clk:            				in std_logic;
   reset:          				in std_logic;      
   we:             				in std_logic;
   WA:             				in std_logic_vector(2 downto 0);
   D:              				in std_logic_vector(15 downto 0);
   rbe:            				in std_logic;
   rae:            				in std_logic;
   RAA:           				in std_logic_vector(2 downto 0);
   RBA:            				in std_logic_vector(2 downto 0);
   portA:          				out std_logic_vector(15 downto 0);
   portB:          				out std_logic_vector(15 downto 0));
end component;
--------ALU---------
component ALU is port (
    S:                   		in std_logic_vector(4 downto 0);
    A, B:                		in std_logic_vector(15 downto 0);
    F:                   		out std_logic_vector(15 downto 0);
    unsigned_overflow:  		out std_logic;
    signed_overflow:    		out std_logic;
    carry:               		out std_logic;
    zero:              			out std_logic);
end component;
-------------16_bit_mux4------------------
component mux4_16bit is port(
    S : 						in std_logic_vector(1 downto 0);
    x0,x1,x2,x3 : 				in std_logic_vector (15 downto 0);
    y :				 			out std_logic_vector (15 downto 0));
end component;
---------ProgramCounter------------------
component PC is port(
    clk : 						in std_logic;
    reset : 					in std_logic;
    load : 						in std_logic;
    INPUT : 					in std_logic_vector (15 downto 0);
    OUTPUT : 					out std_logic_vector (15 downto 0));
end component;
-----------InstructionRegister-------------
component IR_16bit is port(
	clk : 						in std_logic;
	reset : 					in std_logic;
	load : 						in std_logic;
	INPUT : 					in std_logic_vector (15 downto 0);
	OUTPUT : 					out std_logic_vector (15 downto 0));
end component;
---------------StackPointer-------------
component SP is port(
	clk : 						in std_logic;
	reset : 					in std_logic;
	SPload : 					in std_logic;
	INPUT : 					in std_logic_vector (15 downto 0);
	OUTPUT : 					out std_logic_vector (15 downto 0));
end component;
---------------ADDSUB-------------------
component addsub16 is port(
	A:							in std_logic_vector(15 downto 0);
	B:							in std_logic_vector(15 downto 0);
	F:							out std_logic_vector(15 downto 0);
	carryIn:					in std_logic;
	unsigned_overflow:			out std_logic;
	signed_overflow:			out std_logic);
end component;
------------BUFFER----------------------
component buf is port(
	clk,reset: 					in std_logic;
	input : 					in std_logic_vector (15 downto 0);
	output: 					out std_logic_vector(15 downto 0);
	enable: 					in std_logic);
end component;
------------ADRRESS-BUS----------------------
component adressbus is port(
   enable : 					in std_logic;
   input : 						in std_logic_vector(15 downto 0);
   output : 					out std_logic_vector(15 downto 0));
end component;
------------DATA-BUS----------------------
component databus is port(
	enable : 					in std_logic;
	datain :					in std_logic_vector(15 downto 0);
	dataout : 					out std_logic_vector(15 downto 0));
end component;
-----------END OF COMPONENTS----------------
begin
-----------------------------------------------------------------------------------------------------------
subSignal <= irSignal(10) and jmpMux;
AluSel2 <= "0010" & subSignal;
AluSel3 <= "0011" & sub2;
mux02in <= "000000" & irSignal(9 downto 0);
mux02S <= '0' & jmpMux;
--mux06S <= '0' & int;
mux06S <= not(int) or reset;
MUX01 : mux4_16bit port map(S=>Psel,x0=>"ZZZZZZZZZZZZZZZZ",x1=>mux5,x2=>addSubSignal,x3=>"XXXXXXXXXXXXXXXX" ,y=>mux1);
PCounter : PC port map(clk=>clk,reset=>reset,load=>PCload,INPUT=>mux1,OUTPUT=>pcSignal);
C_ALU2 : ALU port map(S=>AluSel2, A=>pcSignal, B=>mux2, signed_overflow=>signed_overflow, unsigned_overflow=>unsigned_overflow,carry=>carry,zero=>zero, F=>addSubSignal);
MUX02 : mux4_16bit port map(S=>mux02S, x0=>"0000000000000001", x1=>mux02in, x2=>"XXXXXXXXXXXXXXXX",x3=>"XXXXXXXXXXXXXXXX",y=>mux2);
IRes : IR_16bit port map(clk=>clk,reset=>reset,load=>IRload,INPUT=>mux5,OUTPUT=>irSignal);
SPointer : SP port map(clk=>clk, reset=>mux06S, SPload=>SPload, INPUT=>addsub2Signal, OUTPUT=>stackPSignal);
--MUX06 : mux4_16bit port map (S=>mux06S, x0=>"0000000000000000", x1=>addsub2Signal, x2=>"XXXXXXXXXXXXXXXX",x3=>"XXXXXXXXXXXXXXXX", y=>mux6);
C_ALU3 : ALU port map(S=>AluSel3, A=>stackPSignal, B=>"XXXXXXXXXXXXXXXX", unsigned_overflow=>unsigned_overflow, signed_overflow=>signed_overflow, carry=>carry,zero=>zero, F=>addsub2Signal);
------------------------------------------------------------------------------------------------------------
wa <= irSignal(10 downto 8);
raa <= irSignal(7 downto 5);
mux03S <= "00000000" & irSignal(7 downto 0);
MUX03 : mux4_16bit port map(S=>Rsel,x0=>mux03S,x1=>"0000000000000000",x2=>portA,x3=>"XXXXXXXXXXXXXXXX",y=>mux3);
REGISTERFILE : regfile port map(clk=>clk, reset=>reset, D=>aluSignal,WE=>we,WA=>wa,RAA=>raa,RAE=>rae,RBE=>rbe,RBA=>irSignal(4 downto 2),portA=>portA,portB=>portB);
MUX05 : mux4_16bit port map (S=>Dsel,x0=>portB, x1=>dataSignal, x2=>"XXXXXXXXXXXXXXXX", x3=>"XXXXXXXXXXXXXXXX", y=>mux5);
C_ALU : ALU port map(S=>ALUsel,A=>mux3,B=>mux5,signed_overflow=>signed_overflow,unsigned_overflow=>unsigned_overflow,carry=>carry,zero=>zero, F=>aluSignal);
MUX04 : mux4_16bit port map(S=>Ssel,x0=>portA,x1=>pcSignal,x2=>stackPSignal,x3=>"XXXXXXXXXXXXXXXX",y=>mux4);
ADDRESSBUS : adressbus port map(enable=>aen, input=>mux4, output=>outAddressBus);
--C_DATABUSPC : adressbus port map(enable=>pcen, input=>pcSignal, output=>outDatabus);
C_DATABUSUP : databus port map(enable=>den2, datain=>inDatabus, dataout=>dataSignal);
C_DATABUSDOWN : databus port map(enable=>den1, datain=>portB, dataout=>outDatabus);
IRoutput <= irSignal(15 downto 11);
------------------------------------------
end struct;
 