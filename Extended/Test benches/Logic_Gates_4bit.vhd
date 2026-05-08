library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;

entity LogicGates_TB is
end LogicGates_TB;

architecture Behavioral of LogicGates_TB is

    component Logic_Gates_4bit
        Port (A,B:in data_bus;
              AND_Result,OR_Result,XOR_Result:out data_bus);
    end component;

    signal A, B                    : data_bus;
    signal AND_R, OR_R, XOR_R      : data_bus;

begin

    UUT: Logic_Gates_4bit port map (
        A=>A, B=>B,
        AND_Result=>AND_R, OR_Result=>OR_R, XOR_Result=>XOR_R
    );

    process
    begin
        -- 1010 AND 1100 = 1000
        -- 1010 OR  1100 = 1110
        -- 1010 XOR 1100 = 0110
        A <= "1010"; B <= "1100"; wait for 20 ns;
        assert AND_R = "1000" report "FAIL: AND" severity error;
        assert OR_R  = "1110" report "FAIL: OR"  severity error;
        assert XOR_R = "0110" report "FAIL: XOR" severity error;

        -- 1111 AND 0000 = 0000
        -- 1111 OR  0000 = 1111
        -- 1111 XOR 0000 = 1111
        A <= "1111"; B <= "0000"; wait for 20 ns;
        assert AND_R = "0000" report "FAIL: AND all-zero" severity error;
        assert OR_R  = "1111" report "FAIL: OR  all-one"  severity error;
        assert XOR_R = "1111" report "FAIL: XOR all-one"  severity error;

        -- 1111 AND 1111 = 1111
        -- 1111 OR  1111 = 1111
        -- 1111 XOR 1111 = 0000
        A <= "1111"; B <= "1111"; wait for 20 ns;
        assert AND_R = "1111" report "FAIL: AND same"  severity error;
        assert OR_R  = "1111" report "FAIL: OR  same"  severity error;
        assert XOR_R = "0000" report "FAIL: XOR same=0" severity error;

        assert false report "LogicGates_TB: All tests PASS" severity note;
        wait;
    end process;

end Behavioral;