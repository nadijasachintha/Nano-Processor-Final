library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;

entity Comparator_TB is
end Comparator_TB;

architecture Behavioral of Comparator_TB is

    component Comparator_4bit
        Port (A,B:in data_bus; EQ,GT,LT:out STD_LOGIC);
    end component;

    signal A, B     : data_bus;
    signal EQ,GT,LT : STD_LOGIC;

begin

    UUT: Comparator_4bit port map (A=>A, B=>B, EQ=>EQ, GT=>GT, LT=>LT);

    process
    begin
        -- A = B
        A <= "0110"; B <= "0110"; wait for 20 ns;
        assert EQ='1' and GT='0' and LT='0' report "FAIL: A=B" severity error;

        -- A > B
        A <= "1001"; B <= "0011"; wait for 20 ns;
        assert EQ='0' and GT='1' and LT='0' report "FAIL: A>B" severity error;

        -- A < B
        A <= "0010"; B <= "1100"; wait for 20 ns;
        assert EQ='0' and GT='0' and LT='1' report "FAIL: A<B" severity error;

        -- A = 0, B = 0
        A <= "0000"; B <= "0000"; wait for 20 ns;
        assert EQ='1' and GT='0' and LT='0' report "FAIL: 0=0" severity error;

        -- Max A, min B
        A <= "1111"; B <= "0000"; wait for 20 ns;
        assert EQ='0' and GT='1' and LT='0' report "FAIL: 15>0" severity error;

        assert false report "Comparator_TB: All tests PASS" severity note;
        wait;
    end process;

end Behavioral;