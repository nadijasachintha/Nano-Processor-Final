library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;

entity Logic_Gates_4bit is
    Port (
        A          : in  data_bus;
        B          : in  data_bus;
        AND_Result : out data_bus;
        OR_Result  : out data_bus;
        XOR_Result : out data_bus
    );
end Logic_Gates_4bit;

architecture Behavioral of Logic_Gates_4bit is
begin
    AND_Result <= A AND B;
    OR_Result  <= A OR  B;
    XOR_Result <= A XOR B;
end Behavioral;