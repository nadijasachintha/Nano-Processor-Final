# Nanoprocessor — A 4-bit CPU Built from Scratch in VHDL

A fully functional 4-bit processor designed and implemented in VHDL, synthesized on a Digilent BASYS3 (Xilinx Artix-7) FPGA board. Built gate-up from D flip-flops and ripple-carry adders through to a complete single-cycle CPU with a custom instruction set, extended with a hardware multiplier, comparator, and bitwise logic units.

Originally developed for **CS1050 — Computer Organization and Digital Design** at the **University of Moratuwa**.

---

## What it does

The processor fetches, decodes, and executes one instruction per clock cycle from an 8-slot ROM, using an 8-register bank, a 4-bit ALU, and a fully combinational instruction decoder. As a demo program, it computes **1 + 2 + 3 = 6** using a loop with conditional jumps, and displays the result on LEDs and a 7-segment display.

Extended modules add a 4-bit multiplier, comparator, and bitwise AND/OR/XOR — all driven by live register values during program execution.

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

## Block Diagram

```
                 +----------------+
                 |  Program ROM   |
                 |   (8 x 12-bit) |
                 +-------+--------+
                         |
                         v
                 +----------------+        +------------------+
   PC ---------->| Instruction    |------->| Instruction       |
   (3-bit)        |  Bus (12-bit) |        | Decoder           |
                 +----------------+        +---+-----+-----+---+
                                                |     |     |
                      +-------------------------+     |     +-------------------+
                      |                                |                        |
                      v                                v                        v
            +------------------+              +----------------+      +----------------+
            | Register Bank    |<-------------|  Load Selector |<-----|     ALU        |
            | R0-R7 (4-bit ea) |   DataBus    |  (Imm / ALU)   |      | (Add/Subtract) |
            +---+----------+---+              +----------------+      +-------+--------+
                |          |                                                  ^
                v          v                                                  |
          +-----------+ +-----------+                                        |
          | 8-way MUX | | 8-way MUX |----------------------------------------+
          | (Op A)    | | (Op B)    |
          +-----------+ +-----------+
```

---

## Repository Structure

```
nanoprocessor/
├── src/
│   ├── packages.vhd              # buses, constants, ALU_H packages
│   ├── nanoprocessor_pkg.vhd     # All 13 core CPU modules
│   ├── multiplier_comparator.vhd # Multiplier, Comparator, Logic Gates
│   ├── nanoprocessor_ext.vhd     # CPU with R1/R2 exposed for extensions
│   └── nanoprocessor_top.vhd     # Top-level: clock divider + 7-seg + LEDs
├── constraints/
│   └── basys3.xdc                # BASYS3 pin constraints
├── testbench/
│   ├── tb_nanoprocessor.vhd      # Full-system testbench
│   ├── tb_multiplier.vhd         # Multiplier unit test
│   ├── tb_comparator.vhd         # Comparator unit test
│   └── tb_logic_gates.vhd        # Logic gates unit test
└── README.md
```

---

## Getting Started

### Requirements
- [Xilinx Vivado](https://www.xilinx.com/support/download.html) (Design Suite or WebPACK, free)
- Digilent BASYS3 board (optional — simulation works without hardware)

### Simulation

1. Open Vivado, create a new RTL project targeting `xc7a35tcpg236-1`
2. Add all files from `src/` as **Design Sources**
3. Add `testbench/tb_nanoprocessor.vhd` as a **Simulation Source**
4. Run Behavioral Simulation
5. Check the Tcl Console for `PASS: R7 = 6`

### Hardware Deployment

1. Add `constraints/basys3.xdc` as a constraint file
2. Set `NanoprocessorTop` as the top module
3. Run Synthesis → Implementation → Generate Bitstream
4. Program the BASYS3 board via Hardware Manager

---

## Board Output

| LEDs | Shows |
|---|---|
| LD0–LD3 | Final result in R7 (binary) |
| LD4–LD11 | Multiplier result, R1 × R2 (8-bit binary) |
| LD12 | EQ flag — R1 = R2 |
| LD13 | GT flag — R1 > R2 |
| LD14 | LT flag — R1 < R2 |
| LD15 | ALU carry flag |
| 7-segment | R1 × R2 in hexadecimal, two digits multiplexed |

Press **BTNC** to reset and restart the program from address 0.

---

## What I Learned

- Building combinational and sequential logic from first principles (half adders → full adders → ripple-carry adder → ALU)
- Designing a clean instruction decoder with no inferred latches
- Debugging real timing hazards: combinational feedback loops, glitches on status flags, and clock-domain assumptions that only show up in simulation waveforms
- Structuring a multi-file VHDL project with shared packages for type safety
- The gap between "it works in theory" and "it works on real silicon" — pin constraints, IO bank limits, and board-specific quirks (BASYS3 only has 16 LEDs and a shared IO bank budget)

---

## License

MIT — feel free to use this for learning or as a reference for your own digital design coursework.

---

## Acknowledgements

Built for CS1050, Department of Computer Science and Engineering, University of Moratuwa.
