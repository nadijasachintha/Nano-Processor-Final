----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 05:25:31 PM
-- Design Name: 
-- Module Name: D_FF - Behavioral
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

entity D_FF is
    Port (
        D   : in  STD_LOGIC;
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        Q   : out STD_LOGIC
    );
end D_FF;

architecture Behavioral of D_FF is
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            Q <= '0';
        elsif rising_edge(CLK) then
            Q <= D;
        end if;
    end process;
end Behavioral;