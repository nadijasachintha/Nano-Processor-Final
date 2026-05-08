library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.buses.all;

entity NanoprocessorTop is
    Port (
        CLK_100MHz : in  STD_LOGIC;
        RST        : in  STD_LOGIC;
        -- LD0-LD3: R7 result
        R7_LED     : out STD_LOGIC_VECTOR(3 downto 0);
        -- LD15: Carry flag
        Carry_LED  : out STD_LOGIC;
        -- 7-segment display (multiplexed, shows R1 x R2 in hex)
        seg        : out STD_LOGIC_VECTOR(6 downto 0);
        dp         : out STD_LOGIC;
        an         : out STD_LOGIC_VECTOR(3 downto 0);
        -- LD4-LD11: Multiplier R1 x R2 (8-bit)
        Mul_Result : out STD_LOGIC_VECTOR(7 downto 0);
        -- LD12-LD14: Comparator R1 vs R2
        EQ_LED     : out STD_LOGIC;
        GT_LED     : out STD_LOGIC;
        LT_LED     : out STD_LOGIC
    );
end NanoprocessorTop;

architecture Behavioral of NanoprocessorTop is

    component Nanoprocessor_Ext
        Port (CLK       : in  STD_LOGIC;
              RST       : in  STD_LOGIC;
              R7_LED    : out data_bus;
              Zero_LED  : out STD_LOGIC;
              Carry_LED : out STD_LOGIC;
              R1_out    : out data_bus;
              R2_out    : out data_bus);
    end component;

    component Multiplier_4bit
        Port (A      : in  data_bus;
              B      : in  data_bus;
              Result : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component Comparator_4bit
        Port (A  : in  data_bus;
              B  : in  data_bus;
              EQ : out STD_LOGIC;
              GT : out STD_LOGIC;
              LT : out STD_LOGIC);
    end component;

    component Logic_Gates_4bit
        Port (A          : in  data_bus;
              B          : in  data_bus;
              AND_Result : out data_bus;
              OR_Result  : out data_bus;
              XOR_Result : out data_bus);
    end component;

    -- Clock divider: 100 MHz -> 1 Hz (processor clock)
    signal slow_clk        : STD_LOGIC := '0';
    signal clk_div_count   : integer range 0 to 49999999 := 0;

    -- 7-seg refresh: 100 MHz -> ~500 Hz toggle (~1 kHz refresh)
    signal refresh_counter : integer range 0 to 99999 := 0;
    signal digit_select    : STD_LOGIC := '0';
    signal current_nibble  : STD_LOGIC_VECTOR(3 downto 0);

    -- Internal signals
    signal R7_val          : data_bus;
    signal Z_flag          : STD_LOGIC;
    signal C_flag          : STD_LOGIC;
    signal R1_val          : data_bus;
    signal R2_val          : data_bus;
    signal Mul_sig         : STD_LOGIC_VECTOR(7 downto 0);

    -- Logic gate results (simulation only, not on board)
    signal AND_sig         : data_bus;
    signal OR_sig          : data_bus;
    signal XOR_sig         : data_bus;

begin

    -- --------------------------------------------------------
    -- Processor clock divider: 100 MHz -> 1 Hz
    -- --------------------------------------------------------
    process(CLK_100MHz, RST)
    begin
        if RST = '1' then
            clk_div_count <= 0;
            slow_clk      <= '0';
        elsif rising_edge(CLK_100MHz) then
            if clk_div_count = 49999999 then
                clk_div_count <= 0;
                slow_clk      <= not slow_clk;
            else
                clk_div_count <= clk_div_count + 1;
            end if;
        end if;
    end process;

    -- --------------------------------------------------------
    -- 7-seg refresh counter: ~1 kHz digit switching
    -- --------------------------------------------------------
    process(CLK_100MHz, RST)
    begin
        if RST = '1' then
            refresh_counter <= 0;
            digit_select    <= '0';
        elsif rising_edge(CLK_100MHz) then
            if refresh_counter = 99999 then
                refresh_counter <= 0;
                digit_select    <= not digit_select;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;

    -- --------------------------------------------------------
    -- Component instantiations
    -- --------------------------------------------------------
    U_NANO: Nanoprocessor_Ext port map (
        CLK       => slow_clk,
        RST       => RST,
        R7_LED    => R7_val,
        Zero_LED  => Z_flag,
        Carry_LED => C_flag,
        R1_out    => R1_val,
        R2_out    => R2_val
    );

    U_MUL: Multiplier_4bit port map (
        A      => R1_val,
        B      => R2_val,
        Result => Mul_sig
    );

    U_CMP: Comparator_4bit port map (
        A  => R1_val,
        B  => R2_val,
        EQ => EQ_LED,
        GT => GT_LED,
        LT => LT_LED
    );

    -- Logic gates: internal signals only (visible in simulation)
    U_LOGIC: Logic_Gates_4bit port map (
        A          => R1_val,
        B          => R2_val,
        AND_Result => AND_sig,
        OR_Result  => OR_sig,
        XOR_Result => XOR_sig
    );

    -- --------------------------------------------------------
    -- Board LED outputs
    -- --------------------------------------------------------
    R7_LED     <= R7_val;
    Carry_LED  <= C_flag;
    Mul_Result <= Mul_sig;

    -- --------------------------------------------------------
    -- 7-segment mux: show Mul_Result (R1 x R2) as 2-digit hex
    --
    --  digit_select=0  -> rightmost digit (an="1110") = lower nibble
    --  digit_select=1  -> second digit    (an="1101") = upper nibble
    --
    --  Digits 2 and 3 (an[3:2]) are always off ("11xx")
    -- --------------------------------------------------------
    current_nibble <= Mul_sig(7 downto 4) when digit_select = '1'
                      else Mul_sig(3 downto 0);

    an <= "1101" when digit_select = '1' else "1110";

    process(current_nibble)
    begin
        case current_nibble is
            when "0000" => seg <= "1000000";  -- 0
            when "0001" => seg <= "1111001";  -- 1
            when "0010" => seg <= "0100100";  -- 2
            when "0011" => seg <= "0110000";  -- 3
            when "0100" => seg <= "0011001";  -- 4
            when "0101" => seg <= "0010010";  -- 5
            when "0110" => seg <= "0000010";  -- 6
            when "0111" => seg <= "1111000";  -- 7
            when "1000" => seg <= "0000000";  -- 8
            when "1001" => seg <= "0010000";  -- 9
            when "1010" => seg <= "0001000";  -- A
            when "1011" => seg <= "0000011";  -- B
            when "1100" => seg <= "1000110";  -- C
            when "1101" => seg <= "0100001";  -- D
            when "1110" => seg <= "0000110";  -- E
            when others => seg <= "0001110";  -- F
        end case;
    end process;

    dp <= '1';  -- decimal point off

end Behavioral;