library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;

entity tb_Address_Selector is
-- Testbench has no ports
end tb_Address_Selector;

architecture Behavioral of tb_Address_Selector is

    -- Component Declaration for the Unit Under Test (UUT)
    component Address_Selector
        Port (
            A   : in  instruction_address;
            B   : in  instruction_address;
            Sel : in  STD_LOGIC;
            Y   : out instruction_address
        );
    end component;

    -- Signals to connect to UUT
    signal A_test   : instruction_address := (others => '0');
    signal B_test   : instruction_address := (others => '0');
    signal Sel_test : STD_LOGIC := '0';
    signal Y_test   : instruction_address;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Address_Selector
        port map (
            A   => A_test,
            B   => B_test,
            Sel => Sel_test,
            Y   => Y_test
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize inputs
        A_test <= "001"; -- Example: PC + 1
        B_test <= "111"; -- Example: Jump target
        
        -- Test Case 1: Select A (Sel = '0')
        Sel_test <= '0';
        wait for 10 ns;
        -- Expected Y should be "001"

        -- Test Case 2: Select B (Sel = '1')
        Sel_test <= '1';
        wait for 10 ns;
        -- Expected Y should be "111"

        -- Test Case 3: Change B while Sel is '1'
        B_test <= "101";
        wait for 10 ns;
        -- Expected Y should follow B and be "101"

        -- Test Case 4: Change A while Sel is '1'
        A_test <= "010";
        wait for 10 ns;
        -- Expected Y should remain "101" because Sel is still '1'

        -- Test Case 5: Switch back to A
        Sel_test <= '0';
        wait for 10 ns;
        -- Expected Y should now be "010"

        wait;
    end process;

end Behavioral;