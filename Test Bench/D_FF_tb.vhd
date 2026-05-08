library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF_tb is
-- Test benches usually have no ports
end D_FF_tb;

architecture Behavioral of D_FF_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component D_FF
        Port (
            D   : in  STD_LOGIC;
            CLK : in  STD_LOGIC;
            RST : in  STD_LOGIC;
            Q   : out STD_LOGIC
        );
    end component;

    -- Signals to connect to UUT
    signal D   : std_logic := '0';
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal Q   : std_logic;

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: D_FF Port map (
          D   => D,
          CLK => CLK,
          RST => RST,
          Q   => Q
        );

    -- Clock process definitions
    CLK_process : process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- 1. Apply Reset
        RST <= '1';
        wait for 20 ns;	
        
        RST <= '0';
        wait for 10 ns;

        -- 2. Test Data Input
        D <= '1';
        wait for 20 ns; -- Observe Q change on rising edge
        
        D <= '0';
        wait for 20 ns;
        
        D <= '1';
        wait for 5 ns;  -- Change D mid-clock cycle
        
        -- 3. Test Asynchronous Reset
        RST <= '1';     -- Reset should drop Q to '0' immediately
        wait for 10 ns;
        
        RST <= '0';
        D <= '1';
        
        -- End simulation
        wait;
    end process;

end Behavioral;