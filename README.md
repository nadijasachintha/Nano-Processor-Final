# Nano-Processor-Final

A fully functional 4-bit processor designed and implemented in VHDL, synthesized on a Digilent BASYS3 (Xilinx Artix-7) FPGA board. Built gate-up from D flip-flops and ripple-carry adders through to a complete single-cycle CPU with a custom instruction set, extended with a hardware multiplier, comparator, and bitwise logic units.

Originally developed for **CS1050 — Computer Organization and Digital Design** at the **University of Moratuwa**.

---

## What it does

The processor fetches, decodes, and executes one instruction per clock cycle from an 8-slot ROM, using an 8-register bank, a 4-bit ALU, and a fully combinational instruction decoder. As a demo program, it computes **1 + 2 + 3 = 6** using a loop with conditional jumps, and displays the result on LEDs and a 7-segment display.

The `Extended` build adds a 4-bit multiplier, comparator, and bitwise AND/OR/XOR units, all driven by live register values during program execution.

---

## Architecture

- **Type:** Single-cycle, 4-bit data path
- **Registers:** 8 × 4-bit (R0–R7), R0 hardwired to zero
- **Program memory:** 8 × 12-bit ROM (lookup table)
- **Program counter:** 3-bit, supports conditional jump
- **ALU:** 4-bit ripple-carry adder/subtractor with Zero, Carry, and Overflow flags
- **Clock:** 100 MHz board clock divided to 1 Hz for visible step-by-step execution

### Instruction Set

| Instruction | Opcode | Format | Operation |
|---|---|---|---|
| `MOVI R, d` | `10` | `10 RRR 000 dddd` | `R ← d` |
| `ADD Ra, Rb` | `00` | `00 RaRaRa RbRbRb 0000` | `Ra ← Ra + Rb` |
| `NEG R` | `01` | `01 RRR 000 0000` | `R ← −R` (2's complement) |
| `JZR R, d` | `11` | `11 RRR 000 0ddd` | `if R = 0: PC ← d` |

---

## Repository Structure

```
Nano-Processor-Final/
├── components/                    # Base processor — one folder per module
│   ├── Add_Sub_4bit/               # 4-bit ALU (add/subtract unit)
│   ├── Address_Selector/           # PC MUX (2-way 3-bit)
│   ├── D_FF/                       # D flip-flop
│   ├── IDecorder/                  # Instruction decoder + opcode logic
│   ├── Load_Selector/              # Data bus MUX (immediate vs ALU)
│   ├── NanoprocessorTop/           # Top-level wrapper (clock divider, LEDs)
│   ├── PC_Adder/                   # 3-bit adder (PC + 1)
│   ├── Packages/                   # buses, constants, ALU_H packages
│   ├── Program counter/            # 3-bit program counter
│   ├── Program_ROM/                # 8x12-bit instruction memory
│   ├── RCA_4bit/                   # 4-bit ripple carry adder
│   ├── Register Bank/              # 8x4-bit register file
│   ├── Register_4bit/              # Single 4-bit register with enable
│   └── Register_Data_MUX/          # 8-way 4-bit MUX
│
├── Extended/                       # Extended version with extra modules
│   ├── Components/                 # Multiplier, Comparator, Logic Gates, etc.
│   ├── Packages/                   # Shared packages for extended build
│   └── Test benches/               # Testbenches for extended components
│
├── Test Bench/                     # Unit + integration testbenches
│   ├── Add_Subtract_Unit_tb.vhd
│   ├── D_FF_tb.vhd
│   ├── IDecoder_TB.vhd
│   ├── RCA_4bit_tb.vhd
│   ├── TB_Load_Selector.vhd
│   ├── TB_Register_Bank.vhd
│   ├── TB_Register_Data_MUX.vhd
│   ├── tb_Address_Selector.vhd
│   ├── tb_NanoprocessorTop.vhd     # Full-system testbench
│   ├── tb_PC_Adder.vhd
│   ├── tb_Program_Counter.vhd
│   └── tb_Program_ROM.vhd
│
└── README.md
```

---

## Getting Started

### Requirements
- [Xilinx Vivado](https://www.xilinx.com/support/download.html) (Design Suite or WebPACK, free)
- Digilent BASYS3 board (optional — simulation works without hardware)

### Simulation

1. Open Vivado, create a new RTL project targeting `Basys3`
2. Add every `.vhd` file from `components/` (and `Extended/Components/` if using the extended build) as **Design Sources**
3. Add the relevant file(s) from `Test Bench/` as **Simulation Sources** — start with `tb_NanoprocessorTop.vhd` for the full system, or any individual `_tb.vhd` file to test one module in isolation
4. Run Behavioral Simulation
5. Check the Tcl Console for the pass/fail report

### Hardware Deployment

1. Add the BASYS3 `.xdc` constraints file as a constraint source
2. Set `NanoprocessorTop` (from `components/NanoprocessorTop/`) as the top module
3. Run Synthesis → Implementation → Generate Bitstream
4. Program the BASYS3 board via Hardware Manager

---

## Board Output

| LEDs | Shows |
|---|---|
| LD0–LD3 | Final result in R7 (binary) |
| LD4–LD11 | Multiplier result, R1 × R2 (8-bit binary) — *Extended build only* |
| LD12 | EQ flag — R1 = R2 — *Extended build only* |
| LD13 | GT flag — R1 > R2 — *Extended build only* |
| LD14 | LT flag — R1 < R2 — *Extended build only* |
| LD15 | ALU carry flag |
| 7-segment | Result display, multiplexed across two digits |

Press **BTNC** to reset and restart the program from address 0.

---

## Testing

Every component has a dedicated testbench in `Test Bench/`, allowing each module — from the `D_FF` up to the full `NanoprocessorTop` — to be verified independently before integration. This bottom-up testing approach made it possible to isolate bugs to a single module rather than debugging the entire data path at once.

---

## What I Learned

- Building combinational and sequential logic from first principles (D flip-flop → ripple-carry adder → ALU)
- Designing a clean instruction decoder with no inferred latches
- Debugging real timing hazards: combinational feedback loops, glitches on status flags, and clock-domain assumptions that only show up in simulation waveforms
- Structuring a multi-module VHDL project with shared packages for type safety across every component
- Writing isolated testbenches per module rather than relying solely on full-system simulation
- The gap between "it works in theory" and "it works on real silicon" — pin constraints, IO bank limits, and board-specific quirks (BASYS3's 16-LED budget and shared IO bank limits)

---

## License

MIT — feel free to use this for learning or as a reference for your own digital design coursework.

---

## Acknowledgements

Built for CS1050, Department of Computer Science and Engineering, University of Moratuwa.
