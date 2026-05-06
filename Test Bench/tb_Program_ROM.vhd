library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.buses.all;

entity tb_Program_ROM is
-- Testbench has no ports
end tb_Program_ROM;

architecture Behavioral of tb_Program_ROM is

    -- Component Declaration
    component Program_ROM
        Port (
            ROM_address : in  instruction_address;
            I           : out instruction_bus
        );
    end component;

    -- Signals for UUT
    signal addr_test : instruction_address := (others => '0');
    signal inst_test : instruction_bus;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Program_ROM
        port map (
            ROM_address => addr_test,
            I           => inst_test
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Iterate through all 8 ROM locations
        for i in 0 to 7 loop
            addr_test <= std_logic_vector(to_unsigned(i, 3));
            wait for 20 ns;
        end loop;

        -- Test behavior with an address out of range (if instruction_address > 3 bits)
        -- addr_test <= "1000"; 
        
        wait;
    end process;

end Behavioral;