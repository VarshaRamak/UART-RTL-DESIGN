# UART Controller – RTL Design (Verilog)

## Overview
This project implements a **UART (Universal Asynchronous Receiver Transmitter)** using **Verilog HDL**.
The design includes both **Transmitter (TX)** and **Receiver (RX)** modules following the **8N1 UART protocol**
(8 data bits, no parity, 1 stop bit).
It is intended for **VLSI / ASIC / SoC-level digital design learning and verification**.

---

## Features
- UART Transmitter and Receiver
- FSM-based RTL architecture
- Parameterized baud rate
- Synthesizable Verilog design
- Verilog testbench for functional verification

---

## UART Protocol Details
- Data bits: 8  
- Parity: None  
- Stop bits: 1  
- Idle line state: Logic high  
- Frame format:  
  Start bit (0) → 8 Data bits → Stop bit (1)

---

## Architecture
The design consists of:
- Baud rate generator
- Finite State Machine (FSM) controller
- Shift registers for serial data handling

TX and RX are implemented as independent FSM-based modules.

---

## FSM Description
Each UART module uses a 4-state FSM:
1. IDLE  
2. START  
3. DATA  
4. STOP  

FSM-based control ensures correct timing and synchronization.

---

## Folder Structure
uart-rtl-design/
├── rtl/ # UART TX, RX, and top modules
├── tb/ # Verilog testbench
├── docs/ # Architecture and FSM diagrams
├── waveforms/ # Simulation waveform screenshots
└── README.md

---

## Simulation & Verification
- Functional verification performed using a Verilog testbench
- Clock, reset, and stimulus generated in testbench
- Waveforms confirm correct UART frame timing
- Data transmission and reception verified through simulation

---

## Applications
- SoC communication interfaces
- Debug and console interfaces
- Control logic in hardware accelerators

---

## Tools Used
- Verilog HDL
- Simulation tools (Vivado)

---

## Author
**Varsha R**  
Electronics and Communication Engineering  
Interested in VLSI and digital design
