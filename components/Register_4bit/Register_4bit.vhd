----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 06:32:05 PM
-- Design Name: 
-- Module Name: Register_4bit - Behavioral
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
entity Register_4bit is
    Port (
        D      : in  data_bus;
        CLK    : in  STD_LOGIC;
        RST    : in  STD_LOGIC;
        Enable : in  STD_LOGIC;
        Q      : out data_bus
    );
end Register_4bit;

architecture Behavioral of Register_4bit is
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            Q <= (others => '0');
        elsif rising_edge(CLK) then
            if Enable = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end Behavioral;
