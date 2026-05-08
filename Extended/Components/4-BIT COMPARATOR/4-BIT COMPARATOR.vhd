library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.buses.all;

entity Comparator_4bit is
    Port (
        A  : in  data_bus;
        B  : in  data_bus;
        EQ : out STD_LOGIC;
        GT : out STD_LOGIC;
        LT : out STD_LOGIC
    );
end Comparator_4bit;

architecture Behavioral of Comparator_4bit is
begin
    EQ <= '1' when unsigned(A) = unsigned(B) else '0';
    GT <= '1' when unsigned(A) > unsigned(B) else '0';
    LT <= '1' when unsigned(A) < unsigned(B) else '0';
end Behavioral;