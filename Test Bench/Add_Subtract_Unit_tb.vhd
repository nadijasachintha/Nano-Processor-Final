library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;
use work.ALU_H.all;

entity Add_Subtract_Unit_tb is
end Add_Subtract_Unit_tb;

architecture Behavioral of Add_Subtract_Unit_tb is

    -- Component Declaration
    component Add_Subtract_Unit
        Port (
            A        : in  data_bus;
            B        : in  data_bus;
            OpS      : in  Operation_Sel;
            Result   : out data_bus;
            Overflow : out STD_LOGIC;
            Zero     : out STD_LOGIC;
            Carry    : out STD_LOGIC
        );
    end component;

    -- Signals
    signal A_tb, B_tb   : data_bus := (others => '0');
    signal OpS_tb       : Operation_Sel;
    signal Result_tb    : data_bus;
    signal Overflow_tb  : STD_LOGIC;
    signal Zero_tb      : STD_LOGIC;
    signal Carry_tb     : STD_LOGIC;

begin

    -- Instantiate UUT
    UUT: Add_Subtract_Unit
        port map (
            A => A_tb,
            B => B_tb,
            OpS => OpS_tb,
            Result => Result_tb,
            Overflow => Overflow_tb,
            Zero => Zero_tb,
            Carry => Carry_tb
        );

    -- Stimulus process
    stim_proc: process
    begin

        -- =====================
        -- ADDITION TESTS (OpS = 0)
        -- =====================
        OpS_tb <= AU_ADD_SIGNAL;

        -- 0 + 0
        A_tb <= "0000"; B_tb <= "0000";
        wait for 100 ns;

        -- 3 + 2 = 5
        A_tb <= "0011"; B_tb <= "0010";
        wait for 100 ns;

        -- 7 + 1 = 8
        A_tb <= "0111"; B_tb <= "0001";
        wait for 100 ns;

        -- Overflow case (7 + 7)
        A_tb <= "0111"; B_tb <= "0111";
        wait for 100 ns;

        -- =====================
        -- SUBTRACTION TESTS (OpS = 1)
        -- =====================
        OpS_tb <= AU_SUB_SIGNAL;

        -- 5 - 3 = 2
        A_tb <= "0101"; B_tb <= "0011";
        wait for 100 ns;

        -- 3 - 5 (negative result case)
        A_tb <= "0011"; B_tb <= "0101";
        wait for 100 ns;

        -- 0 - 0
        A_tb <= "0000"; B_tb <= "0000";
        wait for 100 ns;

        -- Borrow / carry behavior
        A_tb <= "0000"; B_tb <= "0001";
        wait for 100 ns;

        -- Stop simulation
        wait;

    end process;

end Behavioral;