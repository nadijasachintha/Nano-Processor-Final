----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 05:40:37 PM
-- Design Name: 
-- Module Name: Load_Selector - Behavioral
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


entity Load_Selector is
    Port (
        A : in  data_bus;    -- ALU result
        B : in  data_bus;    -- immediate value
        L : in  STD_LOGIC;   -- load select from decoder
        Y : out data_bus
    );
end Load_Selector;

architecture Behavioral of Load_Selector is
begin
    Y <= B when L = '1' else A;
end Behavioral;


