-- ============================================================
-- 11. PROGRAM ROM  (8 x 12-bit, Lookup Table)
--
--  Program: compute 1+2+3 = 6, store in R7
--  (Adapted from friend's working program structure)
--
--  Addr | Assembly       | Binary
--  -----|----------------|------------
--   0   | MOVI R7, 3    | 101110000011
--   1   | MOVI R1, 1    | 100010000001
--   2   | NEG  R1       | 010010000000
--   3   | MOVI R2, 3    | 100100000011
--   4   | ADD  R2, R1   | 000100010000  <- loop: R2 = R2 + R1(=-1)
--   5   | ADD  R7, R2   | 001110100000  <- R7 accumulates R2
--   6   | JZR  R2, 6    | 110100000110  <- if R2=0 stop (halt loop)
--   7   | JZR  R0, 4    | 110000000100  <- always loop back to 4
--
--  Trace:
--   R7=3, R1=1, R1=NEG=-1, R2=3
--   Loop1: R2=3+(-1)=2, R7=3+2=5,  JZR R2 no jump
--   Loop2: R2=2+(-1)=1, R7=5+1=6,  JZR R2 no jump
--   Loop3: R2=1+(-1)=0, R7=6+0=6,  JZR R2 JUMP to 6 (halt)
--   Halt:  addr 6 jumps to itself forever, R7 = 6
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.buses.all;

entity Program_ROM is
    Port (
        ROM_address : in  instruction_address;
        I           : out instruction_bus
    );
end Program_ROM;

architecture Behavioral of Program_ROM is
    type rom_type is array (0 to 7) of std_logic_vector(11 downto 0);
    signal rom_data : rom_type := (
        "101110000011",  -- 0: MOVI R7, 3
        "100010000001",  -- 1: MOVI R1, 1
        "010010000000",  -- 2: NEG  R1
        "100100000011",  -- 3: MOVI R2, 3
        "000100010000",  -- 4: ADD  R2, R1
        "001110100000",  -- 5: ADD  R7, R2
        "110100000110",  -- 6: JZR  R2, 6  (halt: jump to self)
        "110000000100"   -- 7: JZR  R0, 4  (loop back)
    );
begin
    I <= rom_data(to_integer(unsigned(ROM_address)));
end Behavioral;
