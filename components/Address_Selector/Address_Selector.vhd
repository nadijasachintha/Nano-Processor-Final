library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;

entity Address_Selector is
    Port (
        A   : in  instruction_address;   -- PC+1
        B   : in  instruction_address;   -- jump address
        Sel : in  STD_LOGIC;             -- J flag from decoder
        Y   : out instruction_address
    );
end Address_Selector;

architecture Behavioral of Address_Selector is
begin
    Y <= B when Sel = '1' else A;
end Behavioral;