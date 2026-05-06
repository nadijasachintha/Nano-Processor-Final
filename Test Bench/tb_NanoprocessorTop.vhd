library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;

entity tb_NanoprocessorTop is
-- Testbench has no ports
end tb_NanoprocessorTop;

architecture Behavioral of tb_NanoprocessorTop is

    -- Component Declaration
    component NanoprocessorTop
        Port (
            CLK_100MHz : in  STD_LOGIC;
            RST        : in  STD_LOGIC;
            R7_LED     : out STD_LOGIC_VECTOR(3 downto 0);
            Zero_LED   : out STD_LOGIC;
            Carry_LED  : out STD_LOGIC;
            seg        : out STD_LOGIC_VECTOR(6 downto 0);
            dp         : out STD_LOGIC;
            an         : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Inputs
    signal CLK_in : STD_LOGIC := '0';
    signal RST_in : STD_LOGIC := '0';

    -- Outputs
    signal R7_out    : STD_LOGIC_VECTOR(3 downto 0);
    signal Zero_out  : STD_LOGIC;
    signal Carry_out : STD_LOGIC;
    signal Seg_out   : STD_LOGIC_VECTOR(6 downto 0);
    signal DP_out    : STD_LOGIC;
    signal AN_out    : STD_LOGIC_VECTOR(3 downto 0);

    -- Clock period (100MHz = 10ns)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: NanoprocessorTop
        port map (
            CLK_100MHz => CLK_in,
            RST        => RST_in,
            R7_LED     => R7_out,
            Zero_LED   => Zero_out,
            Carry_LED  => Carry_out,
            seg        => Seg_out,
            dp         => DP_out,
            an         => AN_out
        );

    -- Clock generation
    clk_process : process
    begin
        CLK_in <= '0';
        wait for CLK_PERIOD/2;
        CLK_in <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- Step 1: System Reset
        RST_in <= '1';
        wait for 50 ns;
        RST_in <= '0';
        
        -- Note: Because of the clock divider (49,999,999), 
        -- the slow_clk will take a very long time to toggle in simulation.
        -- For simulation testing, you usually reduce that number to 4 or 10.
        
        wait;
    end process;

end Behavioral;