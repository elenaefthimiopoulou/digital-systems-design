library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_or is
    Port (
        a        : in  STD_LOGIC;
        b        : in  STD_LOGIC;
        operation: in  STD_LOGIC; -- 0=AND, 1=OR
        result   : out STD_LOGIC
    );
end and_or;

architecture Behavioral of and_or is
begin
    process(a, b, operation)
    begin
        if operation = '0' then
            result <= a and b;
        else
            result <= a or b;
        end if;
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_2 is
    Port (
        a      : in  STD_LOGIC;
        b      : in  STD_LOGIC;
        result : out STD_LOGIC
    );
end xor_2;

architecture Behavioral of xor_2 is
begin
    result <= a xor b;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port (
        a       : in  STD_LOGIC;
        b       : in  STD_LOGIC;
        carryIn : in  STD_LOGIC;
        sum     : out STD_LOGIC;
        carryOut: out STD_LOGIC
    );
end full_adder;

architecture Behavioral of full_adder is
begin
    sum     <= a xor b xor carryIn;
    carryOut<= (a and b) or (a and carryIn) or (b and carryIn);
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity alu_1bit is
    Port (
        a        : in  STD_LOGIC;
        b        : in  STD_LOGIC;
        Ainvert  : in  STD_LOGIC;
        Binvert  : in  STD_LOGIC;
        CarryIn  : in  STD_LOGIC;
        Operation : in  STD_LOGIC_VECTOR(1 downto 0);  -- Operation selector (00=AND, 01=OR, 10=ADD, 11=XOR)
        Result   : out STD_LOGIC;
        CarryOut : out STD_LOGIC);
end alu_1bit;

architecture Behavioral of alu_1bit is
    signal a_mod, b_mod : STD_LOGIC;
    signal temp_result  : STD_LOGIC;
    signal sum          : STD_LOGIC;
    signal carry        : STD_LOGIC;
begin
    -- Invert inputs if necessary
    a_mod <= not a when Ainvert = '1' else a;
    b_mod <= not b when Binvert = '1' else b;

    -- Full Adder Logic
    sum   <= a_mod xor b_mod xor CarryIn;
    carry <= (a_mod and b_mod) or (a_mod and CarryIn) or (b_mod and CarryIn);

    -- Operation selection
    process(Operation, a_mod, b_mod, sum)
    begin
        case Operation is
            when "00" => temp_result <= a_mod and b_mod; -- AND
            when "01" => temp_result <= a_mod or b_mod;  -- OR
            when "10" => temp_result <= sum;             -- ADD/SUB
            when "11" => temp_result <= a_mod xor b_mod; -- XOR
            when others => temp_result <= '0';
        end case;
    end process;

    Result <= temp_result;
     CarryOut <= carry when Operation = "10" else '0';  -- only for ADD
end Behavioral;

