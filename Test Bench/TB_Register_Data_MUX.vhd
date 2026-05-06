----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 06:07:06 PM
-- Design Name: 
-- Module Name: TB_Register_Data_MUX - Behavioral
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
entity TB_Register_Data_MUX is
-- No ports in a testbench
end TB_Register_Data_MUX;

architecture Behavioral of TB_Register_Data_MUX is

    -- Component Declaration
    component Register_Data_MUX
        Port (
            I0, I1, I2, I3,
            I4, I5, I6, I7 : in  data_bus;
            Sel             : in  register_address;
            Y               : out data_bus
        );
    end component;

    -- Signal Declarations
    -- Ensure these match the types in your packages.vhd
    signal I0_tb, I1_tb, I2_tb, I3_tb, 
           I4_tb, I5_tb, I6_tb, I7_tb : data_bus := (others => '0');
    signal Sel_tb : register_address := (others => '0');
    signal Y_tb    : data_bus;

begin

    -- Instantiate UUT
    UUT: Register_Data_MUX
        port map (
            I0 => I0_tb, I1 => I1_tb, I2 => I2_tb, I3 => I3_tb,
            I4 => I4_tb, I5 => I5_tb, I6 => I6_tb, I7 => I7_tb,
            Sel => Sel_tb,
            Y => Y_tb
        );

    -- Stimulus Process
    stim_proc: process
    begin
        -- Initialize inputs with 4-bit hex values to avoid the "8 elements" error
        -- If your data_bus is 4 bits, use "1010" or x"A". 
        -- If it is 3 bits, use "111".
        I0_tb <= "0000"; I1_tb <= "0001"; I2_tb <= "0010"; I3_tb <= "0011";
        I4_tb <= "0100"; I5_tb <= "0101"; I6_tb <= "0110"; I7_tb <= "0111";

        wait for 100 ns;

        -- Testing each select line
        Sel_tb <= "000"; wait for 20 ns;
        Sel_tb <= "001"; wait for 20 ns;
        Sel_tb <= "010"; wait for 20 ns;
        Sel_tb <= "011"; wait for 20 ns;
        Sel_tb <= "100"; wait for 20 ns;
        Sel_tb <= "101"; wait for 20 ns;
        Sel_tb <= "110"; wait for 20 ns;
        Sel_tb <= "111"; wait for 20 ns;

        wait;
    end process;

end Behavioral;