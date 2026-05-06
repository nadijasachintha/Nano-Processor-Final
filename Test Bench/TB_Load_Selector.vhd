----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 05:43:00 PM
-- Design Name: 
-- Module Name: TB_Load_Selector - Behavioral
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
entity TB_Load_Selector is
end TB_Load_Selector;

architecture Behavioral of TB_Load_Selector is

    component Load_Selector
        Port (
            A : in data_bus;
            B : in data_bus;
            L : in STD_LOGIC;
            Y : out data_bus
        );
    end component;

    signal A_tb : data_bus := (others => '0');
    signal B_tb : data_bus := (others => '0');
    signal L_tb : STD_LOGIC := '0';
    signal Y_tb : data_bus;

begin

    uut: Load_Selector
        port map (
            A => A_tb,
            B => B_tb,
            L => L_tb,
            Y => Y_tb
        );

    stim_proc: process
    begin
        
        -- Test 1: Select A
        A_tb <= "1010";
        B_tb <= "1100";
        L_tb <= '0';
        wait for 100ns;

        -- Test Case 2: L = 1 ? Y should output B
        A_tb <= "0110";
        B_tb <= "1111";
        L_tb <= '1';
        wait for 100ns;

        -- Test Case 3
        A_tb <= "0001";
        B_tb <= "1011";
        L_tb <= '0';
        wait for 100ns;

        -- Test Case 4
        A_tb <= "1110";
        B_tb <= "0101";
        L_tb <= '1';
        wait for 100ns;

        -- Test Case 5
        A_tb <= "0011";
        B_tb <= "1000";
        L_tb <= '0';
        wait for 100ns;

        wait;
    end process;

end Behavioral;