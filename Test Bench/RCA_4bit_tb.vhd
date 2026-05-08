library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Used for easy incrementing of test vectors

entity RCA_4bit_tb is
-- Empty entity
end RCA_4bit_tb;

architecture Behavioral of RCA_4bit_tb is

    -- Component Declaration
    component RCA_4bit
        Port (
            A    : in  STD_LOGIC_VECTOR(3 downto 0);
            B    : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC_VECTOR(3 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    -- Signals to connect to UUT
    signal A    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal B    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Cin  : STD_LOGIC := '0';
    signal Sum  : STD_LOGIC_VECTOR(3 downto 0);
    signal Cout : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: RCA_4bit Port map (
          A    => A,
          B    => B,
          Cin  => Cin,
          Sum  => Sum,
          Cout => Cout
        );

    -- Stimulus process
    stim_proc: process
    begin		
        -- Case 1: Simple addition (2 + 3)
        A <= "0010"; B <= "0011"; Cin <= '0';
        wait for 10 ns;
        
        -- Case 2: Addition with Carry-in (5 + 5 + 1)
        A <= "0101"; B <= "0101"; Cin <= '1';
        wait for 10 ns;

        -- Case 3: Maximum values without Carry-out (7 + 8)
        A <= "0111"; B <= "1000"; Cin <= '0';
        wait for 10 ns;

        -- Case 4: Addition resulting in Carry-out (15 + 1)
        A <= "1111"; B <= "0001"; Cin <= '0';
        wait for 10 ns;

        -- Case 5: Maximum possible sum (15 + 15 + 1)
        A <= "1111"; B <= "1111"; Cin <= '1';
        wait for 10 ns;

        -- Case 6: Zero addition
        A <= "0000"; B <= "0000"; Cin <= '0';
        wait for 10 ns;

        -- Stop simulation
        wait;
    end process;

end Behavioral;