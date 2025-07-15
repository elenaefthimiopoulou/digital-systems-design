
library ieee;
use ieee.std_logic_1164.all;

-- Alu-16-bits entity
entity ALU16bits is
	port(a, b 	: in std_logic_vector(15 downto 0);
		opcode 	: in std_logic_vector(2 downto 0);
		Result	: out std_logic_vector(15 downto 0);
		overflow	: out std_logic);
end ALU16bits;

library ieee;
use ieee.std_logic_1164.all;

-- Control circuit entity (we'll use it as a component
entity ConCirc is
	port(opcode  : in std_logic_vector(2 downto 0);
		Operation : out std_logic_vector(1 downto 0);
		Ainvert, Binvert, CarryIn	 :	out std_logic);
end ConCirc;

architecture behaviorConCirc of ConCirc is
begin
  Ainvert <= '1' when (OpCode = "100" or OpCode = "101") else '0';
  Binvert <= '1' when (OpCode = "011" or OpCode = "100" or OpCode = "101") else '0';
  CarryIn <= '1' when (OpCode = "011") else '0';

  with opcode select
    Operation <=
      "00" when "000",  -- and
      "01" when "001",  -- or
      "10" when "010",  -- add
      "10" when "011",  -- sub 
      "00" when "100",  -- nor
      "01" when "101",  -- nand
      "11" when "110",  -- xor
      "00" when others; -- when opcode = 111
end behaviorConCirc;

architecture structural of ALU16bits is
	-- Using ALU1bit as a component
	component ALU1bit
	   port(a, b, Ainvert, Binvert, CarryIn: in std_logic;
			Operation					: in std_logic_vector(1 downto 0);
			Result, CarryOut			: out std_logic);
	end component;
	
	component ConCirc 
		port(opcode  : in std_logic_vector(2 downto 0);
			Operation : out std_logic_vector(1 downto 0);
			Ainvert, Binvert, CarryIn	 :	out std_logic);
	end component;

	-- Internal Signals
	signal internal_carry : std_logic_vector(16 downto 0); -- Internal ripple add carry
	signal Operation : std_logic_vector(1 downto 0);
	signal Ainvert, Binvert: std_logic;

	
begin 
	-- Connecting Control Circuit with the Alu-ripple-carry
	ControlCircuit: ConCirc port map(opcode, Operation, Ainvert, Binvert, internal_carry(0));
	
	-- first instance
	first_inst: ALU1bit port map(
	 a => a(0), b => b(0), 
	 Ainvert => Ainvert, Binvert => Binvert,
    CarryIn => internal_carry(0), 
	 Operation => Operation, Result => Result(0),
	 CarryOut => internal_carry(1));
	
	-- loop for the ripple carry
	gen_ALU: for i in 1 to 15 generate
		alu_i: ALU1bit port map( 
		a => a(i), b => b(i), 
		Ainvert => Ainvert, Binvert => Binvert, 
		CarryIn => internal_carry(i), 
		Operation => Operation, Result => Result(i), 
		CarryOut => internal_carry(i+1));
	end generate;

	
	overflow <= internal_carry(15) xor internal_carry(16) when (opcode = "010" or opcode = "011") else '0';

end structural;
	