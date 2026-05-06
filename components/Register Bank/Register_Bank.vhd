----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 06:45:49 PM
-- Design Name: 
-- Module Name: Register_Bank - Behavioral
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
entity Register_Bank is
    Port (
        DataBus   : in  data_bus;
        RegSel    : in  register_address;   -- REn from decoder
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
end Register_Bank;

architecture Behavioral of Register_Bank is
    component Register_4bit
        Port (D:in data_bus; CLK:in STD_LOGIC; RST:in STD_LOGIC;
              Enable:in STD_LOGIC; Q:out data_bus);
    end component;
    signal EN : STD_LOGIC_VECTOR(7 downto 0);
begin
    -- 3-to-8 decoder
    EN(0) <= RegEnable when RegSel = "000" else '0';
    EN(1) <= RegEnable when RegSel = "001" else '0';
    EN(2) <= RegEnable when RegSel = "010" else '0';
    EN(3) <= RegEnable when RegSel = "011" else '0';
    EN(4) <= RegEnable when RegSel = "100" else '0';
    EN(5) <= RegEnable when RegSel = "101" else '0';
    EN(6) <= RegEnable when RegSel = "110" else '0';
    EN(7) <= RegEnable when RegSel = "111" else '0';

    R0_out <= "0000";  -- R0 hardwired to 0

    R1: Register_4bit port map (D=>DataBus,CLK=>CLK,RST=>RST,Enable=>EN(1),Q=>R1_out);
    R2: Register_4bit port map (D=>DataBus,CLK=>CLK,RST=>RST,Enable=>EN(2),Q=>R2_out);
    R3: Register_4bit port map (D=>DataBus,CLK=>CLK,RST=>RST,Enable=>EN(3),Q=>R3_out);
    R4: Register_4bit port map (D=>DataBus,CLK=>CLK,RST=>RST,Enable=>EN(4),Q=>R4_out);
    R5: Register_4bit port map (D=>DataBus,CLK=>CLK,RST=>RST,Enable=>EN(5),Q=>R5_out);
    R6: Register_4bit port map (D=>DataBus,CLK=>CLK,RST=>RST,Enable=>EN(6),Q=>R6_out);
    R7: Register_4bit port map (D=>DataBus,CLK=>CLK,RST=>RST,Enable=>EN(7),Q=>R7_out);
end Behavioral;
