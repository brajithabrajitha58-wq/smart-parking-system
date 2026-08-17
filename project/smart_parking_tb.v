`timescale 1ns/1ps

module smart_parking_tb;

    parameter NUM_SLOTS = 4;

    reg clk;
    reg reset;
    reg entry_sensor;
    reg exit_sensor;

    wire [NUM_SLOTS-1:0] slot_status;
    wire [2:0] available_slots;
    wire parking_full;
    wire entry_gate;
    wire exit_gate;

    // Instantiate DUT
    smart_parking #(
        .NUM_SLOTS(NUM_SLOTS)
    ) DUT (
        .clk(clk),
        .reset(reset),
        .entry_sensor(entry_sensor),
        .exit_sensor(exit_sensor),
        .slot_status(slot_status),
        .available_slots(available_slots),
        .parking_full(parking_full),
        .entry_gate(entry_gate),
        .exit_gate(exit_gate)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Display
    initial begin
        $monitor(
            "Time=%0t | Entry=%b | Exit=%b | Slots=%b | Available=%d | Full=%b | EntryGate=%b | ExitGate=%b",
            $time,
            entry_sensor,
            exit_sensor,
            slot_status,
            available_slots,
            parking_full,
            entry_gate,
            exit_gate
        );
    end

    // Test sequence
    initial begin

        clk = 0;
        reset = 1;
        entry_sensor = 0;
        exit_sensor = 0;

        // Reset
        #10;
        reset = 0;

        // Vehicle 1 enters
        #10;
        entry_sensor = 1;
        #10;
        entry_sensor = 0;

        // Vehicle 2 enters
        #10;
        entry_sensor = 1;
        #10;
        entry_sensor = 0;

        // Vehicle 3 enters
        #10;
        entry_sensor = 1;
        #10;
        entry_sensor = 0;

        // Vehicle 4 enters
        #10;
        entry_sensor = 1;
        #10;
        entry_sensor = 0;

        // Try another vehicle when parking is full
        #10;
        entry_sensor = 1;
        #10;
        entry_sensor = 0;

        // Vehicle exits
        #10;
        exit_sensor = 1;
        #10;
        exit_sensor = 0;

        // Another vehicle exits
        #10;
        exit_sensor = 1;
        #10;
        exit_sensor = 0;

        // Vehicle enters again
        #10;
        entry_sensor = 1;
        #10;
        entry_sensor = 0;

        #20;

        $finish;
    end

endmodule