library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.all;
use work.ALU_H.all;

entity Nanoprocessor_Ext is
    Port (
        CLK       : in  STD_LOGIC;
        RST       : in  STD_LOGIC;
        R7_LED    : out data_bus;
        Zero_LED  : out STD_LOGIC;
        Carry_LED : out STD_LOGIC;
        R1_out    : out data_bus;
        R2_out    : out data_bus
    );
end Nanoprocessor_Ext;

architecture Structural of Nanoprocessor_Ext is

    component Program_Counter
        Port (D   : in  instruction_address;
              CLK : in  STD_LOGIC;
              RST : in  STD_LOGIC;
              Q   : out instruction_address);
    end component;
    component PC_Adder
        Port (A   : in  instruction_address;
              Sum : out instruction_address);
    end component;
    component Address_Selector
        Port (A, B : in  instruction_address;
              Sel  : in  STD_LOGIC;
              Y    : out instruction_address);
    end component;
    component Program_ROM
        Port (ROM_address : in  instruction_address;
              I           : out instruction_bus);
    end component;
    component IDecoder
        Port (I      : in  instruction_bus;
              RCJump : in  data_bus;
              REn    : out register_address;
              RSA    : out register_address;
              RSB    : out register_address;
              OpS    : out Operation_Sel;
              IM     : out data_bus;
              J      : out STD_LOGIC;
              JA     : out instruction_address;
              L      : out STD_LOGIC);
    end component;
    component Register_Bank
        Port (DataBus   : in  data_bus;
              RegSel    : in  register_address;
              RegEnable : in  STD_LOGIC;
              CLK       : in  STD_LOGIC;
              RST       : in  STD_LOGIC;
              R0_out, R1_out, R2_out, R3_out,
              R4_out, R5_out, R6_out, R7_out : out data_bus);
    end component;
    component Register_Data_MUX
        Port (I0, I1, I2, I3, I4, I5, I6, I7 : in  data_bus;
              Sel : in  register_address;
              Y   : out data_bus);
    end component;
    component Load_Selector
        Port (A, B : in  data_bus;
              L    : in  STD_LOGIC;
              Y    : out data_bus);
    end component;
    component Add_Subtract_Unit
        Port (A, B    : in  data_bus;
              OpS     : in  Operation_Sel;
              Result  : out data_bus;
              Overflow, Zero, Carry : out STD_LOGIC);
    end component;

    signal PC_out     : instruction_address;
    signal PC_plus1   : instruction_address;
    signal PC_next    : instruction_address;
    signal Instr      : instruction_bus;
    signal REn        : register_address;
    signal RSA        : register_address;
    signal RSB        : register_address;
    signal OpS        : Operation_Sel;
    signal IM         : data_bus;
    signal J          : STD_LOGIC;
    signal JA         : instruction_address;
    signal L          : STD_LOGIC;
    signal R0, R1, R2, R3, R4, R5, R6, R7 : data_bus;
    signal OperandA   : data_bus;
    signal OperandB   : data_bus;
    signal ALU_Result : data_bus;
    signal DataBus    : data_bus;
    signal ALU_Zero   : STD_LOGIC;
    signal ALU_Carry  : STD_LOGIC;
    signal ALU_Ovf    : STD_LOGIC;
    signal RegWriteEn : STD_LOGIC;

begin

    U_PC:      Program_Counter  port map (D => PC_next,  CLK => CLK, RST => RST, Q => PC_out);
    U_PCADD:   PC_Adder         port map (A => PC_out,   Sum => PC_plus1);
    U_ADDRSEL: Address_Selector port map (A => PC_plus1, B => JA, Sel => J, Y => PC_next);
    U_ROM:     Program_ROM      port map (ROM_address => PC_out, I => Instr);

    U_DEC: IDecoder port map (
        I => Instr, RCJump => OperandA,
        REn => REn, RSA => RSA, RSB => RSB,
        OpS => OpS, IM => IM, J => J, JA => JA, L => L
    );

    RegWriteEn <= '0' when REn = "000" else '1';

    U_REGBANK: Register_Bank port map (
        DataBus   => DataBus, RegSel => REn, RegEnable => RegWriteEn,
        CLK       => CLK, RST => RST,
        R0_out => R0, R1_out => R1, R2_out => R2, R3_out => R3,
        R4_out => R4, R5_out => R5, R6_out => R6, R7_out => R7
    );

    U_MUXA: Register_Data_MUX port map (
        I0 => R0, I1 => R1, I2 => R2, I3 => R3,
        I4 => R4, I5 => R5, I6 => R6, I7 => R7,
        Sel => RSA, Y => OperandA
    );
    U_MUXB: Register_Data_MUX port map (
        I0 => R0, I1 => R1, I2 => R2, I3 => R3,
        I4 => R4, I5 => R5, I6 => R6, I7 => R7,
        Sel => RSB, Y => OperandB
    );

    U_ALU: Add_Subtract_Unit port map (
        A => OperandA, B => OperandB, OpS => OpS,
        Result   => ALU_Result,
        Overflow => ALU_Ovf,
        Zero     => ALU_Zero,
        Carry    => ALU_Carry
    );

    U_LOADSEL: Load_Selector port map (
        A => ALU_Result, B => IM, L => L, Y => DataBus
    );

    R7_LED    <= R7;
    Zero_LED  <= ALU_Zero;
    Carry_LED <= ALU_Carry;
    R1_out    <= R1;
    R2_out    <= R2;

end Structural;