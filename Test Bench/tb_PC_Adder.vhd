library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Used for easy incrementing in stimulus
use work.buses.all;

entity tb_PC_Adder is
-- Testbenches do not have ports
end tb_PC_Adder;

architecture Behavioral of tb_PC_Adder is

    -- Component Declaration for the Unit Under Test (UUT)
    component PC_Adder
        Port (
            A   : in  instruction_address;
            Sum : out instruction_address
        );
    end component;

    -- Signals to connect to UUT
    signal A_test   : instruction_address := (others => '0');
    signal Sum_test : instruction_address;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: PC_Adder
        port map (
            A   => A_test,
            Sum => Sum_test
        );

    -- Stimulus process
    stim_proc: process
    begin

        -- Automated Loop to test all possibilities (assuming 3-bit)
        for i in 0 to 7 loop
            A_test <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
        end loop;

        -- Stop simulation
        wait;
    end process;

end Behavioral;