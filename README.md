# RISC-9 — A 32-Bit RISC-V Processor in SystemVerilog

> A simple single-cycle RISC-V processor designed and implemented in SystemVerilog to explore instruction execution, processor datapath design, control logic, and hardware simulation.

---

## Architecture

The following diagram shows the high-level architecture of the RISC-9 processor.

![RISC-9 Architecture](Risc%209.png)

## 📁 Project Structure

## Diagram represents the organization of the RISC-9 project:

![RISC-9 Project Structure](Documentation/Structure.png)

## Process Execution

The RISC-9 processor follows the basic instruction execution cycle used by a RISC-V processor. The process starts with a program written in assembly language and ends with the result being stored in a register or memory.

### 1. Write the Program

The program is first written using RISC-V assembly instructions.

```asm
addi x1, x0, 5
addi x2, x0, 10
add  x3, x1, x2
```

These instructions tell the processor what operations need to be performed.

### 2. Convert the Program to Machine Code

The assembly instructions are converted into machine code that the processor can understand. The machine code is stored in hexadecimal format inside `program.hex`.

```text
00500093
00A00113
002081B3
```

### 3. Load the Instructions

The hexadecimal instructions are loaded into the Instruction Memory using `$readmemh`.

```systemverilog
$readmemh("program/program.hex", memory);
```

This allows the processor to access the program while it is running.

### 4. Fetch the Instruction

The Program Counter (PC) keeps track of the current instruction. It starts at address `0` and normally moves to the next instruction by increasing by `4`, since each RISC-V instruction is 32 bits long.

### 5. Decode the Instruction

Once an instruction is fetched, the Decoder breaks it into different fields such as `opcode`, `rd`, `rs1`, `rs2`, `funct3`, and `funct7`.

These fields help the processor understand what the instruction is supposed to do.

### 6. Generate Control Signals

The Control Unit uses the decoded instruction to decide how the different parts of the processor should work.

It determines whether the instruction needs the ALU, registers, or memory and generates the required control signals.

### 7. Read the Required Data

The Register File provides the values required by the instruction.

For example, for:

```asm
add x3, x1, x2
```

the processor reads the values stored in `x1` and `x2` and sends them to the ALU.

### 8. Generate the Immediate Value

Some instructions contain a constant value called an immediate. The Immediate Generator extracts this value from the instruction and prepares it for use by the processor.

For example:

```asm
addi x1, x0, 5
```

uses `5` as its immediate value.

### 9. Execute the Operation

The ALU performs the operation required by the instruction.

The RISC-9 ALU supports operations such as:

* Addition
* Subtraction
* AND
* OR
* XOR
* SLT

For example:

```asm
add x3, x1, x2
```

If `x1 = 5` and `x2 = 10`:

```text
5 + 10 = 15
```

The result is then written to `x3`.

### 10. Access Memory When Required

Some instructions need to access Data Memory.

Load instructions read data from memory, while store instructions write data to memory. Instructions such as `add` and `sub` do not require Data Memory.

### 11. Write Back the Result

After execution, the result is sent back to the Register File.

Depending on the instruction, the result can come from either:

* The ALU
* Data Memory

The correct result is selected by the Write-Back MUX and stored in the destination register.

### 12. Move to the Next Instruction

Once the current instruction has been completed, the processor moves to the next instruction.

In the current RISC-9 implementation, this is normally done using:

```text
PC = PC + 4
```

The same process then continues for the next instruction.

### Overall Flow

```text
Assembly Program
       ↓
Machine Code
       ↓
Instruction Memory
       ↓
Fetch
       ↓
Decode
       ↓
Read Registers / Generate Immediate
       ↓
Execute
       ↓
Memory Access (if required)
       ↓
Write Back
       ↓
Next Instruction
```

In simple terms, RISC-9 **takes an instruction, understands what it means, gets the required data, performs the operation, stores the result, and then moves on to the next instruction.**

![RISC-9 Project Structure](Documentation/Visual.png)



## Overview

**RISC-9** is a 32-bit RISC-V processor implemented using **SystemVerilog**.

The project focuses on understanding how a processor works internally, starting from a RISC-V assembly program and moving through instruction fetching, decoding, register operations, execution, memory access, and write-back.

The processor is designed as a collection of modular hardware components that are individually testable and then integrated into a complete CPU.

```text
RISC-V Assembly Program
          ↓
      Machine Code
          ↓
   Instruction Memory
          ↓
        Fetch
          ↓
        Decode
          ↓
   Register / Immediate
          ↓
       Execute
          ↓
   Memory Access
          ↓
      Write Back
          ↓
   Next Instruction
```

---

## Objectives

The main objectives of RISC-9 are:

* Understand the RISC-V Instruction Set Architecture (ISA).
* Understand 32-bit RISC-V instruction encoding.
* Design processor components using SystemVerilog.
* Build a basic single-cycle CPU datapath.
* Implement instruction decoding and control logic.
* Understand register and memory operations.
* Execute RISC-V instructions through the processor.
* Verify individual hardware modules using testbenches.
* Simulate the complete processor.
* Analyze processor behavior using waveform visualization.
* Establish a foundation for future processor extensions.

---

## Architecture

RISC-9 follows a basic **single-cycle processor architecture**.

Each instruction passes through the major stages of the processor within the execution cycle.

```text
                         ┌──────────────────────┐
                         │   Program Counter    │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │  Instruction Memory  │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │       Decoder        │
                         └──────────┬───────────┘
                                    │
                   ┌────────────────┴────────────────┐
                   │                                 │
                   ▼                                 ▼
          ┌─────────────────┐              ┌────────────────────┐
          │  Control Unit   │              │ Immediate Generator│
          └────────┬────────┘              └──────────┬─────────┘
                   │                                  │
                   │                                  │
                   ▼                                  ▼
             ┌────────────────────────────────────────────┐
             │                 Register File               │
             └──────────────────────┬─────────────────────┘
                                    │
                                    ▼
                              ┌─────────────┐
                              │     ALU     │
                              └──────┬──────┘
                                     │
                                     ▼
                              ┌─────────────┐
                              │ Data Memory │
                              └──────┬──────┘
                                     │
                                     ▼
                              ┌─────────────┐
                              │  Write Back │
                              └──────┬──────┘
                                     │
                                     ▼
                              Register File
```

---

## Project Structure

```text
RISC-9/
│
├── rtl/
│   ├── program_counter.sv
│   ├── instruction_memory.sv
│   ├── decoder.sv
│   ├── immediate_generator.sv
│   ├── register_file.sv
│   ├── alu.sv
│   ├── control_unit.sv
│   ├── data_memory.sv
│   └── cpu.sv
│
├── sim/
│   ├── program_counter_tb.sv
│   ├── instruction_memory_tb.sv
│   ├── decoder_tb.sv
│   ├── immediate_generator_tb.sv
│   ├── register_file_tb.sv
│   ├── alu_tb.sv
│   ├── control_unit_tb.sv
│   ├── data_memory_tb.sv
│   └── cpu_tb.sv
│
├── program/
│   ├── program.s
│   └── program.hex
│
├── Documentation/
│   └── Structure.png
│
└── README.md
```

### Directory Description

| Directory        | Purpose                                                 |
| ---------------- | ------------------------------------------------------- |
| `rtl/`           | Register Transfer Level SystemVerilog processor modules |
| `sim/`           | Simulation testbenches                                  |
| `program/`       | RISC-V assembly and machine-code programs               |
| `Documentation/` | Project diagrams and documentation                      |
| `README.md`      | Project documentation                                   |

---

## Processor Components

| Module                   | Description                                                               |
| ------------------------ | ------------------------------------------------------------------------- |
| `program_counter.sv`     | Maintains the address of the current instruction                          |
| `instruction_memory.sv`  | Stores and provides RISC-V instructions                                   |
| `decoder.sv`             | Extracts instruction fields such as opcode, registers and function fields |
| `immediate_generator.sv` | Generates immediate values from RISC-V instructions                       |
| `register_file.sv`       | Provides 32 general-purpose 32-bit registers                              |
| `alu.sv`                 | Performs arithmetic and logical operations                                |
| `control_unit.sv`        | Generates control signals for instruction execution                       |
| `data_memory.sv`         | Handles processor memory read and write operations                        |
| `cpu.sv`                 | Integrates all processor components into the complete CPU                 |

---

## Instruction Execution

RISC-9 follows the basic instruction execution process:

```text
Fetch
  ↓
Decode
  ↓
Register Read
  ↓
Immediate Generation
  ↓
Execute
  ↓
Memory Access
  ↓
Write Back
  ↓
Next Instruction
```

### 1. Fetch

The **Program Counter (PC)** stores the address of the instruction that needs to be executed.

The processor initially starts from:

```text
PC = 0
```

For sequential execution, the current implementation calculates:

```text
PC = PC + 4
```

Since a standard RISC-V instruction is 32 bits, each instruction occupies 4 bytes.

---

### 2. Decode

The fetched 32-bit instruction is passed to the **Decoder**.

The Decoder extracts important instruction fields:

```text
opcode
rd
rs1
rs2
funct3
funct7
```

These fields tell the processor what operation should be performed and which registers are involved.

---

### 3. Control

The **Control Unit** interprets the instruction's opcode and function fields.

It generates signals that determine how the datapath should operate.

Examples include:

```text
RegWrite
ALUSrc
MemRead
MemWrite
MemToReg
Branch
ALUControl
```

---

### 4. Register Read

The Register File contains:

```text
32 registers
32 bits per register
```

For example:

```asm
add x3, x1, x2
```

If:

```text
x1 = 5
x2 = 10
```

the Register File provides:

```text
Read Data 1 = 5
Read Data 2 = 10
```

These values are then provided to the ALU.

Register `x0` is hardwired to zero.

---

### 5. Immediate Generation

Some RISC-V instructions contain immediate values.

For example:

```asm
addi x1, x0, 5
```

The Immediate Generator extracts and sign-extends the immediate value:

```text
Immediate = 5
```

The processor currently includes support for:

```text
I-Type
S-Type
B-Type
U-Type
J-Type
```

---

### 6. Execute

The **Arithmetic Logic Unit (ALU)** performs the required operation.

The current ALU supports:

```text
ADD
SUB
AND
OR
XOR
SLT
```

For example:

```asm
add x3, x1, x2
```

with:

```text
x1 = 5
x2 = 10
```

produces:

```text
ALU Result = 15
```

---

### 7. Memory Access

Memory instructions use the **Data Memory**.

For a store instruction:

```text
Register Data
      ↓
Data Memory
      ↓
Memory
```

For a load instruction:

```text
Memory
   ↓
Data Memory
   ↓
Write Back
```

The ALU calculates the effective memory address.

---

### 8. Write Back

The result is written back into the destination register.

The Write-Back MUX selects between:

```text
ALU Result
     OR
Memory Data
```

The selected value is then written to the Register File.

---

## RISC-V Instruction Support

The current processor implements a basic subset of the RISC-V ISA.

### R-Type

```text
ADD
SUB
AND
OR
XOR
SLT
```

### I-Type Arithmetic

```text
ADDI
ANDI
ORI
XORI
SLTI
```

### Memory Operations

The current datapath and control logic include basic support for:

```text
LOAD
STORE
```

### Branch Recognition

Branch instructions are recognized by the Control Unit.

However, branch-based PC redirection is not yet implemented in the current CPU.

---

## Program Execution Flow

RISC-9 programs are written using RISC-V assembly language.

Example:

```asm
addi x1, x0, 5
addi x2, x0, 10
add  x3, x1, x2
sub  x4, x2, x1
```

The assembly program is stored in:

```text
program/program.s
```

The assembly instructions are converted into 32-bit machine-code representations stored in:

```text
program/program.hex
```

The complete process is:

```text
              program.s
                  │
                  ▼
          RISC-V Assembler
                  │
                  ▼
            Machine Code
                  │
                  ▼
             program.hex
                  │
                  ▼
        Instruction Memory
                  │
                  ▼
               CPU
                  │
                  ▼
        Register / Memory
             Results
```

---

## Loading Instructions

The processor loads machine-code instructions into Instruction Memory using:

```systemverilog
$readmemh("program/program.hex", memory);
```

`$readmemh` is a SystemVerilog/Verilog system task that reads hexadecimal values from a file and places them into a memory array.

In simple terms:

```text
program.hex
     ↓
 $readmemh
     ↓
Instruction Memory
     ↓
     CPU
```

---

## Simulation and Verification

Simulation is used to verify the behavior of the processor before considering further hardware implementation.

Each major component has an associated testbench.

```text
RTL Module
    +
Testbench
    ↓
Icarus Verilog
    ↓
Simulation
    ↓
Console Output
    +
Waveform
```

Examples:

```text
alu.sv
   +
alu_tb.sv
   ↓
ALU Verification
```

and:

```text
cpu.sv
   +
cpu_tb.sv
   ↓
Complete CPU Verification
```

---

## Testbenches

The project includes testbenches for:

```text
program_counter_tb.sv
instruction_memory_tb.sv
decoder_tb.sv
immediate_generator_tb.sv
register_file_tb.sv
alu_tb.sv
control_unit_tb.sv
data_memory_tb.sv
cpu_tb.sv
```

Testing modules independently makes debugging easier before integrating them into the complete processor.

---

## Waveform Analysis

The processor can be analyzed using simulation waveforms.

Important signals include:

```text
Clock
Reset
Program Counter
Instruction
Opcode
Register Values
ALU Inputs
ALU Result
Control Signals
Memory Signals
Write-Back Data
```

GTKWave can be used to inspect how these signals change during instruction execution.

This makes it possible to observe the processor's internal datapath rather than only looking at the final output.

---

## Software and Tools

### Development

* SystemVerilog
* Visual Studio Code
* Git
* GitHub

### Simulation

* Icarus Verilog
* GTKWave

### RISC-V Toolchain

A RISC-V assembler/toolchain can be used to convert assembly programs into machine-code representations.

Typical tools include:

```text
riscv64-unknown-elf-as
riscv64-unknown-elf-gcc
riscv64-unknown-elf-objdump
```

---

## Running the Project

### 1. Install Icarus Verilog

On macOS:

```bash
brew install icarus-verilog
```

Verify the installation:

```bash
iverilog -V
```

---

### 2. Install GTKWave

```bash
brew install --cask gtkwave
```

---

### 3. Simulate an Individual Module

For example, to simulate the ALU:

```bash
iverilog -g2012 -o alu_sim rtl/alu.sv sim/alu_tb.sv
```

Run the simulation:

```bash
vvp alu_sim
```

---

### 4. Simulate the Complete CPU

Compile all processor modules:

```bash
iverilog -g2012 -o cpu_sim \
rtl/program_counter.sv \
rtl/instruction_memory.sv \
rtl/decoder.sv \
rtl/immediate_generator.sv \
rtl/register_file.sv \
rtl/alu.sv \
rtl/control_unit.sv \
rtl/data_memory.sv \
rtl/cpu.sv \
sim/cpu_tb.sv
```

Run:

```bash
vvp cpu_sim
```

The testbench displays the final register values and processor state.

---

## Project Outcome

RISC-9 establishes a functional foundation for understanding and implementing a RISC-V processor at the hardware level.

The project demonstrates how a RISC-V instruction moves through the major stages of a CPU, from instruction fetch and decoding to register operations, ALU execution, memory access, and write-back.

The processor has been designed as a modular SystemVerilog implementation, where individual components can be developed, tested, and integrated into the complete CPU datapath.

The current implementation provides the following capabilities:

* 32-bit RISC-V instruction processing.
* Modular single-cycle CPU architecture.
* Instruction fetching from Instruction Memory.
* Instruction field decoding.
* Immediate value generation.
* Register read and write operations.
* ALU-based arithmetic and logical execution.
* Basic memory access.
* Control signal generation.
* Register write-back.
* Assembly-to-machine-code execution flow.
* Individual module verification through testbenches.
* Complete CPU simulation.
* Internal signal analysis through waveforms.

The project also provides a practical foundation for moving toward more advanced processor architectures.

---

## What Can Be Done With the Current Implementation?

The current RISC-9 implementation can be used as a foundation for progressively building a more capable processor.

### 1. Execute Real RISC-V Programs

The processor can be extended and tested using actual RISC-V assembly programs.

For example:

```asm
addi x1, x0, 10
addi x2, x0, 20
add  x3, x1, x2
sub  x4, x2, x1
```

Expected register state:

```text
x1 = 10
x2 = 20
x3 = 30
x4 = 10
```

This creates a complete path from:

```text
Assembly
   ↓
Machine Code
   ↓
Instruction Memory
   ↓
CPU
   ↓
Register Results
```

---

### 2. Add Branch Instructions

The next major improvement can be branch support:

```text
BEQ
BNE
BLT
BGE
```

This requires:

```text
Branch Immediate
      ↓
Branch Target
      ↓
Branch Condition
      ↓
PC Selection
```

This will allow the processor to execute conditional control flow.

---

### 3. Add Jump Instructions

The processor can later be extended with:

```text
JAL
JALR
```

This will allow function calls and non-sequential program execution.

---

### 4. Expand Toward RV32I

The current implementation can be expanded toward the complete **RV32I base instruction set**.

This would make RISC-9 capable of executing a significantly larger range of RISC-V programs.

---

### 5. Improve Memory Support

Memory operations can be expanded to support different data widths:

```text
LB
LH
LW
LBU
LHU

SB
SH
SW
```

This would make the memory subsystem more representative of a complete RISC-V processor.

---

### 6. Improve Verification

The current testbench-based approach can be extended with:

```text
More test programs
      ↓
Expected results
      ↓
Automated checking
      ↓
Waveform analysis
      ↓
Regression testing
```

This can make the processor more reliable as additional instructions are introduced.

---

### 7. Build a Pipelined Processor

Once the single-cycle implementation is stable, RISC-9 can be evolved into a pipelined processor.

A typical five-stage pipeline is:

```text
IF
↓
ID
↓
EX
↓
MEM
↓
WB
```

This introduces more advanced concepts such as:

* Pipeline registers
* Data hazards
* Control hazards
* Forwarding
* Hazard detection
* Pipeline stalls
* Branch handling

---

## Current Capabilities

At the current stage, RISC-9 can:

* Fetch instructions.
* Decode instructions.
* Read registers.
* Generate immediate values.
* Perform ALU operations.
* Access data memory.
* Write results back to registers.
* Execute a basic RISC-V instruction subset.
* Simulate individual modules.
* Simulate the integrated CPU.
* Inspect internal processor signals.

Example instruction sequence:

```asm
addi x1, x0, 5
addi x2, x0, 10
add  x3, x1, x2
sub  x4, x2, x1
and  x5, x1, x2
or   x6, x1, x2
xor  x7, x1, x2
slt  x8, x1, x2
```

Expected results:

```text
x0 = 0
x1 = 5
x2 = 10
x3 = 15
x4 = 5
x5 = 0
x6 = 15
x7 = 15
x8 = 1
```

---

## Current Limitations

RISC-9 is currently a basic single-cycle processor and does not yet implement the complete RV32I instruction set.

Current limitations include:

* Branch PC redirection is not yet implemented.
* `JAL` is not yet implemented.
* `JALR` is not yet implemented.
* Complete RV32I support is not yet available.
* Load/store width handling can be extended.
* The current PC logic normally advances using `PC + 4`.
* Advanced pipeline features are not currently implemented.

The current PC calculation is:

```systemverilog
assign next_pc = pc + 32'd4;
```

Therefore, instructions currently execute sequentially.

---

## Future Development

The planned development path for RISC-9 is:

```text
Basic Single-Cycle CPU
          ↓
Real RISC-V Program Execution
          ↓
Branch Instructions
          ↓
Jump Instructions
          ↓
Expanded Memory Instructions
          ↓
RV32I Support
          ↓
Improved Verification
          ↓
Pipelined CPU
          ↓
Hazard Detection
          ↓
Forwarding
          ↓
Advanced Processor Design
```

The project can therefore evolve from a basic educational processor into a more complete RISC-V CPU architecture.

---

## Learning Outcomes

Through this project, the following concepts are explored:

* RISC-V Instruction Set Architecture
* Instruction encoding
* CPU datapath design
* Register organization
* ALU design
* Control logic
* Immediate generation
* Memory organization
* Instruction fetching
* Instruction decoding
* Single-cycle processor architecture
* SystemVerilog
* Hardware testbenches
* Digital simulation
* Waveform analysis
* Processor verification

---

## Project Goal

The long-term goal of RISC-9 is to evolve from a basic single-cycle RISC-V processor into a more complete and capable processor architecture.

```text
Basic CPU
   ↓
More Instructions
   ↓
RV32I
   ↓
Better Verification
   ↓
Pipelining
   ↓
Hazard Handling
   ↓
Advanced CPU Architecture
```

The project is intended to provide a practical understanding of what happens inside a processor when a program is executed.

At its core, RISC-9 follows a simple idea:

```text
Instruction
    ↓
Understand It
    ↓
Get the Required Data
    ↓
Perform the Operation
    ↓
Access Memory if Required
    ↓
Store the Result
    ↓
Move to the Next Instruction
```

---

## Author

**Gurtaj Singh**
B.Tech Information Technology | NIT Srinagar

RISC-9 is developed as a personal project to explore RISC-V ISA, processor architecture, SystemVerilog-based hardware design, and digital processor simulation.

---

