library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;

entity Program_Counter is
    Port (
        D   : in  instruction_address;
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        Q   : out instruction_address
    );
end Program_Counter;

architecture Behavioral of Program_Counter is
    component D_FF
        Port (D:in STD_LOGIC; CLK:in STD_LOGIC;
              RST:in STD_LOGIC; Q:out STD_LOGIC);
    end component;
begin
    FF0: D_FF port map (D=>D(0), CLK=>CLK, RST=>RST, Q=>Q(0));
    FF1: D_FF port map (D=>D(1), CLK=>CLK, RST=>RST, Q=>Q(1));
    FF2: D_FF port map (D=>D(2), CLK=>CLK, RST=>RST, Q=>Q(2));
end Behavioral;