# 16-bit Hierarchical Arithmetic Logic Unit (ALU)

A modular 16-bit ALU implementation designed and verified in Intel Quartus Prime / ModelSim.

## Architecture Overview
The design follows a bottom-up hierarchical structure:
1. **1-bit ALU Slice:** 
   - Supports logic operations: `AND`, `OR`, `NOR`, `NAND`, `XOR`
   - Supports arithmetic operations: `ADD`, `SUB` (via two's complement using `Bnegate`/`CarryIn`)
   - Uses multiplexers for operation selection and inversion controls (`Ainvert`, `Binvert`).

2. **Control Circuit & 16-bit Cascading:**
   - A dedicated control circuit translates the 3-bit `opcode` into control signals (`Ainvert`, `Binvert`, `CarryIn`, `Operation[1..0]`).
   - 16 individual 1-bit ALU slices are cascaded with carry-chain propagation.
   - Includes overflow detection logic for signed arithmetic.

## Supported Operations & Opcodes
| Opcode | Operation | Function |
| :---: | :--- | :--- |
| `000` | **AND** | Bitwise conjunction |
| `001` | **OR** | Bitwise disjunction |
| `010` | **ADD** | Arithmetic addition ($A + B$) |
| `011` | **SUB** | Arithmetic subtraction ($A - B$) |
| `100` | **NOR** | Bitwise NOR |
| `101` | **NAND** | Bitwise NAND |
| `110` | **XOR** | Bitwise XOR |

## RTL Schematics
### 1-bit ALU Slice
![1-bit ALU RTL](docs/alu_1bit_rtl.png)

### 16-bit Hierarchical ALU
![16-bit ALU RTL](docs/alu_16bit_rtl_full.png)

## Verification & Simulation
All operations have been verified through functional timing simulations (Waveform Editor):
- **Addition & Subtraction:** Verified with carry propagation and overflow flag assertion.
- **Bitwise Operations:** Verified against test vectors for all 16 bits.