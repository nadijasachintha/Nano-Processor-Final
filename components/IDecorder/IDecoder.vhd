-- ============================================================
-- 12. INSTRUCTION DECODER  (IDecoder)
--     Matches your friend's port naming exactly
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;
use work.constants.all;
use work.ALU_H.all;

entity IDecoder is
    Port (
        I      : in  instruction_bus;      -- 12-bit instruction
        RCJump : in  data_bus;             -- register check for jump (OperandA)
        REn    : out register_address;     -- register enable (which reg to write)
        RSA    : out register_address;     -- register select A (MUX A)
        RSB    : out register_address;     -- register select B (MUX B)
        OpS    : out Operation_Sel;        -- ALU operation select
        IM     : out data_bus;             -- immediate value
        J      : out STD_LOGIC;           -- jump flag
        JA     : out instruction_address;  -- jump address
        L      : out STD_LOGIC            -- load select
    );
end IDecoder;

architecture Behavioral of IDecoder is
    signal IEn : STD_LOGIC_VECTOR(1 downto 0);
    signal RCJ : data_bus;
    constant Jump    : STD_LOGIC := '1';
    constant NotJump : STD_LOGIC := '0';
begin
    IEn <= I(11 downto 10);
    RCJ <= RCJump;

    decode: process(IEn, RCJ, I)
    begin
        -- Safe defaults
        REn <= "000";
        RSA <= "000";
        RSB <= "000";
        OpS <= AU_ADD_SIGNAL;
        IM  <= "0000";
        J   <= NotJump;
        JA  <= "000";
        L   <= Register_Load;

        case IEn is
            when MOVI_OP =>
                J   <= NotJump;
                IM  <= I(3 downto 0);
                L   <= Immediate_Load;
                REn <= I(9 downto 7);

            when ADD_OP =>
                J   <= NotJump;
                OpS <= AU_ADD_SIGNAL;
                RSA <= I(9 downto 7);
                RSB <= I(6 downto 4);
                REn <= I(9 downto 7);
                L   <= Register_Load;

            when NEG_OP =>
                J   <= NotJump;
                OpS <= AU_SUB_SIGNAL;
                RSA <= "000";           -- R0 = 0 always
                RSB <= I(9 downto 7);
                REn <= I(9 downto 7);
                L   <= Register_Load;

            when JZR_OP =>
                RSA <= I(9 downto 7);
                REn <= "000";           -- no register write
                L   <= Register_Load;
                if RCJ = "0000" then
                    J  <= Jump;
                    JA <= I(2 downto 0);
                else
                    J  <= NotJump;
                end if;

            when others =>
                null;
        end case;
    end process decode;
end Behavioral;
