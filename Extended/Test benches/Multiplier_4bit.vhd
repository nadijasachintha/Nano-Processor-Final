library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.buses.all;

entity Multiplier_TB is
end Multiplier_TB;

architecture Behavioral of Multiplier_TB is

    component Multiplier_4bit
        Port (A,B:in data_bus; Result:out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    signal A, B  : data_bus;
    signal Result: STD_LOGIC_VECTOR(7 downto 0);

begin

    UUT: Multiplier_4bit port map (A=>A, B=>B, Result=>Result);

    process
    begin
        -- 0 x 0 = 0
        A <= "0000"; B <= "0000"; wait for 20 ns;
        assert Result = "00000000" report "FAIL: 0x0" severity error;

        -- 1 x 1 = 1
        A <= "0001"; B <= "0001"; wait for 20 ns;
        assert Result = "00000001" report "FAIL: 1x1" severity error;

        -- 3 x 2 = 6
        A <= "0011"; B <= "0010"; wait for 20 ns;
        assert Result = "00000110" report "FAIL: 3x2" severity error;

        -- 15 x 15 = 225 (max case)
        A <= "1111"; B <= "1111"; wait for 20 ns;
        assert Result = "11100001" report "FAIL: 15x15" severity error;

        -- 3 x 3 = 9 (from ROM: R1=15=-1 in 4-bit, R2 counts 3,2,1)
        A <= "0011"; B <= "0011"; wait for 20 ns;
        assert Result = "00001001" report "FAIL: 3x3" severity error;

        assert false report "Multiplier_TB: All tests PASS" severity note;
        wait;
    end process;

end Behavioral;