library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Use the work library to access your custom types
use work.buses.all;
use work.constants.all;
use work.ALU_H.all;

entity IDecoder_TB is
-- Testbench has no ports
end IDecoder_TB;

architecture Behavioral of IDecoder_TB is

    -- 1. Component Declaration (Matches your entity exactly)
    component IDecoder
        Port (
            I      : in  instruction_bus;
            RCJump : in  data_bus;
            REn    : out register_address;
            RSA    : out register_address;
            RSB    : out register_address;
            OpS    : out Operation_Sel;
            IM     : out data_bus;
            J      : out STD_LOGIC;
            JA     : out instruction_address;
            L      : out STD_LOGIC
        );
    end component;

    -- 2. Internal Signals to connect to the UUT
    signal I_sig      : instruction_bus := (others => '0');
    signal RCJump_sig : data_bus := (others => '0');
    signal REn_sig    : register_address;
    signal RSA_sig    : register_address;
    signal RSB_sig    : register_address;
    signal OpS_sig    : Operation_Sel;
    signal IM_sig     : data_bus;
    signal J_sig      : STD_LOGIC;
    signal JA_sig     : instruction_address;
    signal L_sig      : STD_LOGIC;

begin

    -- 3. Instantiate the Unit Under Test (UUT)
    uut: IDecoder
        Port map (
            I      => I_sig,
            RCJump => RCJump_sig,
            REn    => REn_sig,
            RSA    => RSA_sig,
            RSB    => RSB_sig,
            OpS    => OpS_sig,
            IM     => IM_sig,
            J      => J_sig,
            JA     => JA_sig,
            L      => L_sig
        );

    -- 4. Stimulus Process
    stim_proc: process
    begin
        -- Initial State
        wait for 100 ns;

        -- TEST 1: MOVI (Move Immediate)
        -- Op: MOVI_OP, Reg: 3, Imm: 7
        I_sig <= MOVI_OP & "011" & "000" & "0111"; 
        wait for 20 ns;

        -- TEST 2: ADD
        -- Op: ADD_OP, RSA: 1, RSB: 2
        I_sig <= ADD_OP & "001" & "010" & "0000";
        wait for 20 ns;

        -- TEST 3: JZR (Jump Taken)
        -- Op: JZR_OP, RSA: 4, JA: 5
        I_sig <= JZR_OP & "100" & "0000" & "101";
        RCJump_sig <= "0000"; -- Input is Zero, Jump should be '1'
        wait for 20 ns;

        -- TEST 4: JZR (Jump NOT Taken)
        RCJump_sig <= "0001"; -- Input is NOT Zero, Jump should be '0'
        wait for 20 ns;

        -- End Simulation
        wait;
    end process;

end Behavioral;