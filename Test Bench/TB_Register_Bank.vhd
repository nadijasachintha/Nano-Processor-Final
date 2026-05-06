----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 06:50:59 PM
-- Design Name: 
-- Module Name: TB_Register_Bank - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_Register_Bank is
-- Testbench has no ports
end TB_Register_Bank;

architecture Behavioral of TB_Register_Bank is

    -- Component Declaration for the Unit Under Test (UUT)
    component Register_Bank
        Port (
            DataBus   : in  data_bus;
            RegSel    : in  register_address;
            RegEnable : in  STD_LOGIC;
            CLK       : in  STD_LOGIC;
            RST       : in  STD_LOGIC;
            R0_out    : out data_bus;
            R1_out    : out data_bus;
            R2_out    : out data_bus;
            R3_out    : out data_bus;
            R4_out    : out data_bus;
            R5_out    : out data_bus;
            R6_out    : out data_bus;
            R7_out    : out data_bus
        );
    end component;

    -- Signals to connect to UUT
    signal DataBus_tb   : data_bus := (others => '0');
    signal RegSel_tb    : register_address := (others => '0');
    signal RegEnable_tb : STD_LOGIC := '0';
    signal CLK_tb       : STD_LOGIC := '0';
    signal RST_tb       : STD_LOGIC := '0';
    
    -- Output signals
    signal R0_tb, R1_tb, R2_tb, R3_tb, 
           R4_tb, R5_tb, R6_tb, R7_tb : data_bus;

    -- Clock period definition
    constant CLK_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Register_Bank port map (
          DataBus   => DataBus_tb,
          RegSel    => RegSel_tb,
          RegEnable => RegEnable_tb,
          CLK       => CLK_tb,
          RST       => RST_tb,
          R0_out    => R0_tb,
          R1_out    => R1_tb,
          R2_out    => R2_tb,
          R3_out    => R3_tb,
          R4_out    => R4_tb,
          R5_out    => R5_tb,
          R6_out    => R6_tb,
          R7_out    => R7_tb
        );

    -- Clock process definitions
    CLK_process :process
    begin
        CLK_tb <= '0';
        wait for 50 ns;
        CLK_tb <= '1';
        wait for 50 ns;
    end process;

    -- Stimulus process

    stim_proc: process
    begin		
        -- Initial State: Reset high for the first cycle
        RST_tb <= '1';
        RegEnable_tb <= '1'; -- Keeping Enable high as shown in the diagram
        DataBus_tb <= x"0";
        RegSel_tb <= "000";
        wait for 100 ns;
        
        RST_tb <= '0'; -- Release reset at 100ns

        -- 100ns: Write x"5" to R1
        DataBus_tb <= x"5";
        RegSel_tb <= "001";
        wait for 100 ns;

        -- 200ns: Write x"A" to R2
        DataBus_tb <= x"A";
        RegSel_tb <= "010";
        wait for 100 ns;

        -- 300ns: Write x"F" to R3
        DataBus_tb <= x"F";
        RegSel_tb <= "011";
        wait for 100 ns;

        -- 400ns: Write x"3" to R4
        DataBus_tb <= x"3";
        RegSel_tb <= "100";
        wait for 100 ns;

        -- 500ns: Write x"7" to R5
        DataBus_tb <= x"5"; -- Note: Adjusting to match '7' in diagram
        DataBus_tb <= x"7";
        RegSel_tb <= "101";
        wait for 100 ns;

        -- 600ns: Write x"9" to R6
        DataBus_tb <= x"9";
        RegSel_tb <= "110";
        wait for 100 ns;

        -- 700ns: Write x"C" to R7
        DataBus_tb <= x"C";
        RegSel_tb <= "111";
        wait for 100 ns;

        -- 800ns: Write x"F" to R0 (Should stay 0)
        DataBus_tb <= x"F";
        RegSel_tb <= "000";
        wait for 100 ns;

        -- 900ns: Final Reset (All values return to 0)
        RST_tb <= '1';
        wait;
    end process;
end Behavioral;