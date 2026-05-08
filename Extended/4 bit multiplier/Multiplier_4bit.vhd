library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.buses.all;

entity Multiplier_4bit is
    Port (
        A      : in  data_bus;
        B      : in  data_bus;
        Result : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Multiplier_4bit;

architecture Behavioral of Multiplier_4bit is
begin
    Result <= STD_LOGIC_VECTOR(unsigned(A) * unsigned(B));
end Behavioral;