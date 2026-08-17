# Smart Parking System Using Verilog HDL

## Overview

This project implements a **Smart Parking System** using Verilog HDL. The system automatically manages parking slots based on vehicle entry and exit signals.

The design is suitable for simulation and can be adapted for implementation on an FPGA board.

## Features

* 4 parking slots
* Automatic parking-slot allocation
* Vehicle entry detection
* Vehicle exit detection
* Available-slot indication
* Parking-full indication
* Entry gate control
* Exit gate control
* Synthesizable Verilog RTL
* Simulation testbench

## Project Structure

```text
smart-parking-verilog/
│
├── src/
│   └── smart_parking.v
│
├── tb/
│   └── smart_parking_tb.v
│
└── README.md
```

## Inputs

| Signal         | Description                |
| -------------- | -------------------------- |
| `clk`          | System clock               |
| `reset`        | Active-high reset          |
| `entry_sensor` | Detects a vehicle entering |
| `exit_sensor`  | Detects a vehicle leaving  |

## Outputs

| Signal             | Description                           |
| ------------------ | ------------------------------------- |
| `slot_status[3:0]` | Status of the four parking slots      |
| `available_slots`  | Number of available slots             |
| `parking_full`     | Indicates that all slots are occupied |
| `entry_gate`       | Entry-gate control signal             |
| `exit_gate`        | Exit-gate control signal              |

### Slot Status

```text
0 = Empty
1 = Occupied
```

For example:

```text
slot_status = 0101
```

means slots 1 and 3 are occupied.

## Working Principle

1. The system starts with all parking slots empty.
2. When `entry_sensor` detects a vehicle, the controller searches for the first available slot.
3. The selected slot is marked as occupied.
4. The entry gate is activated.
5. When all four slots are occupied, `parking_full` becomes `1`.
6. Additional vehicles are prevented from entering when the parking area is full.
7. When `exit_sensor` detects a vehicle, the controller releases an occupied slot.
8. The exit gate is activated.
9. The number of available slots is updated.

## Example Simulation

A typical simulation sequence is:

```text
Vehicle 1 enters
Vehicle 2 enters
Vehicle 3 enters
Vehicle 4 enters
Parking becomes FULL
Additional vehicle attempts to enter
Vehicle 1 exits
Vehicle 2 exits
Another vehicle enters
```

Example output:

```text
Time=0   | Entry=0 | Exit=0 | Slots=0000 | Available=4 | Full=0
Time=15  | Entry=1 | Exit=0 | Slots=0001 | Available=4 | Full=0
Time=35  | Entry=1 | Exit=0 | Slots=0011 | Available=3 | Full=0
Time=55  | Entry=1 | Exit=0 | Slots=0111 | Available=2 | Full=0
Time=75  | Entry=1 | Exit=0 | Slots=1111 | Available=1 | Full=0
Time=85  | Entry=0 | Exit=0 | Slots=1111 | Available=0 | Full=1
Time=95  | Entry=1 | Exit=0 | Slots=1111 | Available=0 | Full=1
Time=105 | Entry=0 | Exit=1 | Slots=1110 | Available=0 | Full=1
```

The exact displayed timing may vary depending on the simulator and clock-edge scheduling.

## Simulation

### Using Icarus Verilog

Install Icarus Verilog and run:

```bash
iverilog -o smart_parking_sim \
    src/smart_parking.v \
    tb/smart_parking_tb.v
```

Run the simulation:

```bash
vvp smart_parking_sim
```

### Using GTKWave

If waveform generation is enabled in the testbench:

```bash
gtkwave smart_parking.vcd
```

## Tools

This project can be simulated using:

* Icarus Verilog
* GTKWave
* ModelSim
* QuestaSim
* Vivado
* Intel Quartus

## Applications

The Smart Parking System can be used in:

* Shopping malls
* Offices
* Apartment complexes
* Universities
* Hospitals
* Airports
* Automated parking systems

## Future Enhancements

The project can be extended with:

* 8 or 16 parking slots
* RFID-based vehicle identification
* Ultrasonic parking sensors
* LCD display
* 7-segment display
* Automatic ticket generation
* Mobile/IoT monitoring
* Entry and exit vehicle counters
* FPGA implementation
* Servo-motor-controlled gates

## Author

**Smart Parking System – Verilog HDL Project**

## License

This project is intended for educational and academic purposes.
