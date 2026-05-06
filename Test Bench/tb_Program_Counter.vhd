library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;

entity tb_Program_Counter is
-- Testbench has no ports
end tb_Program_Counter;

architecture Behavioral of tb_Program_Counter is

    -- Component Declaration
    component Program_Counter
        Port (
            D   : in  instruction_address;
            CLK : in  STD_LOGIC;
            RST : in  STD_LOGIC;
            Q   : out instruction_address
        );
    end component;

    -- Signals for interfacing with UUT
    signal D_test   : instruction_address := (others => '0');
    signal CLK_test : STD_LOGIC := '0';
    signal RST_test : STD_LOGIC := '0';
    signal Q_test   : instruction_address;

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Program_Counter
        port map (
            D   => D_test,
            CLK => CLK_test,
            RST => RST_test,
            Q   => Q_test
        );

    -- Clock Generation Process
    clk_process : process
    begin
        while now < 200 ns loop -- Limit simulation time
            CLK_test <= '0';
            wait for CLK_PERIOD/2;
            CLK_test <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- Stimulus Process
    stim_proc: process
    begin		
        -- Initial Reset
        RST_test <= '1';
        wait for 20 ns;
        RST_test <= '0';
        wait for 10 ns;

        -- Test Case 1: Load "011"
        D_test <= "011";
        wait for CLK_PERIOD; -- Wait for rising edge

        -- Test Case 2: Load "101"
        D_test <= "101";
        wait for CLK_PERIOD;

        -- Test Case 3: Asynchronous/Synchronous Reset Check
        -- (Depends on how your D_FF is written)
        RST_test <= '1';
        wait for 15 ns;
        RST_test <= '0';
        
        -- Test Case 4: Load "111"
        D_test <= "111";
        wait for CLK_PERIOD;

        wait;
    end process;

end Behavioral;