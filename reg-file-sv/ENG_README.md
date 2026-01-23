# Register File (SystemVerilog)

A simple 32-bit register file implemented in SystemVerilog.
This project was created as a preparatory step before designing an AXI-Lite slave.

---

## Overview
- 4 × 32-bit registers
- Byte-addressed register map
- Synchronous active-low reset
- Write path using `always_ff`
- Read path using `always_comb`
- Self-checking testbench with assertions

---

## Register Map

| Address | Register |
|--------:|----------|
| 0x00 | reg0 |
| 0x04 | reg1 |
| 0x08 | reg2 |
| 0x0C | reg3 |

---

## Design Architecture
- Address decoding based on byte addressing
- Register index derived from `addr[3:2]`
- Invalid address access blocked using `addr_valid`
- Write operation gated by `we && addr_valid`
- Read operation enabled only when `re && addr_valid`

---

## Verification
The design is verified using a self-checking testbench.

### Test Scenarios
- Reset behavior verification
- Write → Read → Assert sequence
- Invalid address write blocked
- Invalid address read returns zero

Assertions are used to automatically detect failures without manual waveform inspection.

---

## Simulation
- Tool: Vivado XSim (Behavioral Simulation)
- Result: **ALL TESTS PASSED**

Waveform and simulation results are available in the `sim/` directory.

---

## Purpose
This project focuses on understanding the fundamentals of:
- Address decoding
- Register-based storage
- Separation of sequential and combinational logic
- Assertion-based verification

It serves as a foundation for extending the design into an AXI-Lite slave.

---

