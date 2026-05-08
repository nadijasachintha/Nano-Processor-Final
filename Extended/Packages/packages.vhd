-- ============================================================
--  PACKAGE: buses
--  Defines all custom types used across the nanoprocessor
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package buses is
    subtype data_bus         is std_logic_vector(3 downto 0);  -- 4-bit data
    subtype instruction_bus  is std_logic_vector(11 downto 0); -- 12-bit instruction
    subtype instruction_address is std_logic_vector(2 downto 0); -- 3-bit PC address
    subtype register_address is std_logic_vector(2 downto 0);  -- 3-bit register select
end package buses;


-- ============================================================
--  PACKAGE: constants
--  Opcode constants and control signal constants
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package constants is
    -- Opcodes (bits 11-10 of instruction)
    constant MOVI_OP : std_logic_vector(1 downto 0) := "10";
    constant ADD_OP  : std_logic_vector(1 downto 0) := "00";
    constant NEG_OP  : std_logic_vector(1 downto 0) := "01";
    constant JZR_OP  : std_logic_vector(1 downto 0) := "11";

    -- Load select constants
    constant Immediate_Load : std_logic := '1';  -- route immediate to data bus
    constant Register_Load  : std_logic := '0';  -- route ALU result to data bus
end package constants;


-- ============================================================
--  PACKAGE: ALU_H
--  ALU operation select type and constants
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package ALU_H is
    subtype Operation_Sel is std_logic;
    constant AU_ADD_SIGNAL : std_logic := '0';  -- Add
    constant AU_SUB_SIGNAL : std_logic := '1';  -- Subtract
end package ALU_H;