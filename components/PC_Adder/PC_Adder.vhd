library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;

entity PC_Adder is
    Port (
        A   : in  instruction_address;
        Sum : out instruction_address
    );
end PC_Adder;

architecture Behavioral of PC_Adder is
    signal C : STD_LOGIC_VECTOR(3 downto 0);
begin
    C(0) <= '1';
    GEN: for i in 0 to 2 generate
        Sum(i) <= A(i) XOR C(i);
        C(i+1) <= A(i) AND C(i);
    end generate;
end Behavioral;