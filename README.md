#  32-bit Atomic Arithmetic and Logic Unit(ALU) 

This project implements a **32-bit Atomic Arithmetic Logic Unit (ALU)** with an integrated **state-based controller**, **register file**, and **seven-segment display driver**.  
It supports arithmetic, logical, and **atomic compare-and-swap (CAS)** operations. The design is fully modular, verified through testbenches, and simulated using **QuestaSim/ModelSim**.  

---

##  Features

- **32-bit ALU** supporting:
  - Addition, subtraction, increment
  - Bitwise AND, OR, XOR, NOT
  - Condition flags: Carry (C), Overflow (O), Zero (Z), Negative (N)
- **Atomic Compare-and-Swap (CAS)** instruction
- **State-based Controller** for instruction decoding and execution
- **8×32-bit Register File** initialized from external `.mem` file
- **Seven-Segment Display Driver** for showing register contents in real time
- **Top Module Integration** connecting ALU, controller, memory, and display
- **Comprehensive Testbenches** for each module and system-level verification
- **Makefile** for automated compilation and simulation with QuestaSim

---

## 📁 Project Structure

```
32_bits_Atomic_ALU/
├── alu.sv
├── constraints.xdc
├── controller.sv
├── display_driver.sv
├── display_driver_tb.sv
├── Makefile
├── memory.sv
├── README.md
├── register_init.mem
├── state_based_controller.sv
├── state_based_controller_tb.sv
├── topmodule.sv
└── topmodule_tb.sv
```

---

## 🧠 Supported Instructions

| Opcode  | Operation | Description                          |
|---------|-----------|--------------------------------------|
| `000`   | ADD       | `y = a + b`                         |
| `001`   | SUB       | `y = a - b`                         |
| `010`   | INC       | `y = a + 1`                         |
| `011`   | AND       | `y = a & b`                         |
| `100`   | OR        | `y = a \| b`                        |
| `101`   | XOR       | `y = a ^ b`                         |
| `110`   | NOT       | `y = ~a`                            |
| `111`   | CAS       | Atomic compare-and-swap (`R1 ↔ R3`) |

---



## Authors  
- Muhammad Waleed Akram  
- Abdul-Muiz  
- Ali Tahir  

Undergraduate Students of the Department of Electrical Engineering , UET Lahore

---

## Summary  
This project delivers a **modular 32-bit Atomic ALU** with an integrated **state-based controller, register file, and display driver**.  
It supports a range of arithmetic, logical, and atomic operations, making it a practical design for exploring computer architecture concepts.  
The implementation emphasizes **clarity, modularity, and verifiability**, providing a solid foundation for further extensions such as pipelining or additional instruction support.  


Fell free to Contact Us !
---