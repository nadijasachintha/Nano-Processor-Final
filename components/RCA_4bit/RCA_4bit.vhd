library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA_4bit is
    Port (
        A    : in  STD_LOGIC_VECTOR(3 downto 0);
        B    : in  STD_LOGIC_VECTOR(3 downto 0);
        Cin  : in  STD_LOGIC;
        Sum  : out STD_LOGIC_VECTOR(3 downto 0);
        Cout : out STD_LOGIC
    );
end RCA_4bit;

architecture Behavioral of RCA_4bit is
    signal C : STD_LOGIC_VECTOR(4 downto 0);
begin
    C(0) <= Cin;
    GEN: for i in 0 to 3 generate
        Sum(i) <= A(i) XOR B(i) XOR C(i);
        C(i+1) <= (A(i) AND B(i)) OR (A(i) AND C(i)) OR (B(i) AND C(i));
    end generate;
    Cout <= C(4);
end Behavioral;
