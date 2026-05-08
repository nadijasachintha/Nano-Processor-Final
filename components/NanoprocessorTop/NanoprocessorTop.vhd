-- ============================================================
--  NANOPROCESSOR TOP WRAPPER with 7-Segment Display
--  University of Moratuwa CS1050 Lab 9-10
--
--  Displays R7 value (0-9) on rightmost 7-segment digit
--  LEDs LD0-LD3 also show R7 in binary
--  LD14 = Zero flag, LD15 = Carry flag
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.buses.all;

entity NanoprocessorTop is
    Port (
        CLK_100MHz : in  STD_LOGIC;
        RST        : in  STD_LOGIC;
        -- LEDs
        R7_LED     : out STD_LOGIC_VECTOR(3 downto 0);
        Zero_LED   : out STD_LOGIC;
        Carry_LED  : out STD_LOGIC;
        -- 7-segment display
        seg        : out STD_LOGIC_VECTOR(6 downto 0);  -- segments a-g
        dp         : out STD_LOGIC;                      -- decimal point
        an         : out STD_LOGIC_VECTOR(3 downto 0)   -- digit anodes
    );
end NanoprocessorTop;

architecture Behavioral of NanoprocessorTop is

    component Nanoprocessor
        Port (
            CLK       : in  STD_LOGIC;
            RST       : in  STD_LOGIC;
            R7_LED    : out data_bus;
            Zero_LED  : out STD_LOGIC;
            Carry_LED : out STD_LOGIC
        );
    end component;

    signal slow_clk : STD_LOGIC := '0';
    signal count    : integer range 0 to 49999999 := 0;
    signal R7_val   : data_bus;
    signal Z_flag   : STD_LOGIC;
    signal C_flag   : STD_LOGIC;

begin

    -- --------------------------------------------------------
    -- Clock divider: 100MHz -> 1Hz
    -- Change 49999999 to 24999999 for 2Hz (faster execution)
    -- --------------------------------------------------------
    process(CLK_100MHz, RST)
    begin
        if RST = '1' then
            count    <= 0;
            slow_clk <= '0';
        elsif rising_edge(CLK_100MHz) then
            if count = 49999999 then
                count    <= 0;
                slow_clk <= not slow_clk;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    -- --------------------------------------------------------
    -- Nanoprocessor instance
    -- --------------------------------------------------------
    U_NANO: Nanoprocessor port map (
        CLK       => slow_clk,
        RST       => RST,
        R7_LED    => R7_val,
        Zero_LED  => Z_flag,
        Carry_LED => C_flag
    );

    -- --------------------------------------------------------
    -- Connect to LED outputs
    -- --------------------------------------------------------
    R7_LED    <= R7_val;
    Zero_LED  <= Z_flag;
    Carry_LED <= C_flag;

    -- --------------------------------------------------------
    -- 7-Segment decoder for R7 value (0-9, A-F)
    -- Segments: seg(6 downto 0) = g f e d c b a
    -- Active LOW: '0' = segment ON, '1' = segment OFF
    --
    --   Segment layout:
    --       aaa
    --      f   b
    --      f   b
    --       ggg
    --      e   c
    --      e   c
    --       ddd
    --
    --   seg index: 6=g 5=f 4=e 3=d 2=c 1=b 0=a
    -- --------------------------------------------------------
    process(R7_val)
    begin
        case R7_val is
            --                    gfedcba
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when "1010" => seg <= "0001000"; -- A
            when "1011" => seg <= "0000011"; -- b
            when "1100" => seg <= "1000110"; -- C
            when "1101" => seg <= "0100001"; -- d
            when "1110" => seg <= "0000110"; -- E
            when others => seg <= "0001110"; -- F
        end case;
    end process;

    -- Decimal point OFF
    dp <= '1';

    -- Enable only rightmost digit (an[0]), others off
    -- an is active LOW: "1110" enables digit 0 only
    an <= "1110";

end Behavioral;