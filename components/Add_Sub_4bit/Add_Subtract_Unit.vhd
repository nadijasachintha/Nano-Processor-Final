library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;
use work.ALU_H.all;

entity Add_Subtract_Unit is
    Port (
        A        : in  data_bus;
        B        : in  data_bus;
        OpS      : in  Operation_Sel;   -- AU_ADD_SIGNAL or AU_SUB_SIGNAL
        Result   : out data_bus;
        Overflow : out STD_LOGIC;
        Zero     : out STD_LOGIC;
        Carry    : out STD_LOGIC
    );
end Add_Subtract_Unit;

architecture Behavioral of Add_Subtract_Unit is
    component RCA_4bit
        Port (A:in STD_LOGIC_VECTOR(3 downto 0);
              B:in STD_LOGIC_VECTOR(3 downto 0);
              Cin:in STD_LOGIC;
              Sum:out STD_LOGIC_VECTOR(3 downto 0);
              Cout:out STD_LOGIC);
    end component;
    signal B_in           : data_bus;
    signal Sum_s          : data_bus;
    signal Cout_s         : STD_LOGIC;
    signal C1, C2, Cout_3 : STD_LOGIC;
begin
    B_in <= B XOR (OpS & OpS & OpS & OpS);

    U_RCA: RCA_4bit port map (
        A => A, B => B_in, Cin => OpS,
        Sum => Sum_s, Cout => Cout_s
    );

    Result   <= Sum_s;
    Carry    <= Cout_s;
    Zero     <= '1' when Sum_s = "0000" else '0';
    C1       <= (A(0) AND B_in(0)) OR (A(0) AND OpS)  OR (B_in(0) AND OpS);
    C2       <= (A(1) AND B_in(1)) OR (A(1) AND C1)   OR (B_in(1) AND C1);
    Cout_3   <= (A(2) AND B_in(2)) OR (A(2) AND C2)   OR (B_in(2) AND C2);
    Overflow <= Cout_s XOR Cout_3;
end Behavioral;
