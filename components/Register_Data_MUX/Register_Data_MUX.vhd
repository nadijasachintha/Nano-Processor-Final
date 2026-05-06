----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 06:05:23 PM
-- Design Name: 
-- Module Name: Register_Data_MUX - Behavioral
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
entity Register_Data_MUX is
    Port (
        I0, I1, I2, I3, I4, I5, I6, I7 : in  data_bus;
        Sel             : in  register_address;
        Y               : out data_bus
    );
end Register_Data_MUX;

architecture Behavioral of Register_Data_MUX is
begin
    process(I0,I1,I2,I3,I4,I5,I6,I7,Sel)
    begin
        case Sel is
            when "000"  => Y <= I0;
            when "001"  => Y <= I1;
            when "010"  => Y <= I2;
            when "011"  => Y <= I3;
            when "100"  => Y <= I4;
            when "101"  => Y <= I5;
            when "110"  => Y <= I6;
            when others => Y <= I7;
        end case;
    end process;
end Behavioral;