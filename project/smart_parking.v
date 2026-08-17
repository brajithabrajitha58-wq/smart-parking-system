`timescale 1ns/1ps

module smart_parking #(
    parameter NUM_SLOTS = 4
)(
    input  wire                   clk,
    input  wire                   reset,

    // Vehicle detection
    input  wire                   entry_sensor,
    input  wire                   exit_sensor,

    // Outputs
    output reg  [NUM_SLOTS-1:0]   slot_status,
    output reg  [2:0]             available_slots,
    output reg                    parking_full,
    output reg                    entry_gate,
    output reg                    exit_gate
);

    integer i;
    reg entry_sensor_d;
    reg exit_sensor_d;

    // Previous sensor states
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            entry_sensor_d <= 1'b0;
            exit_sensor_d  <= 1'b0;
        end
        else begin
            entry_sensor_d <= entry_sensor;
            exit_sensor_d  <= exit_sensor;
        end
    end

    // Parking control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            slot_status    <= {NUM_SLOTS{1'b0}};
            available_slots <= NUM_SLOTS;
            parking_full   <= 1'b0;
            entry_gate     <= 1'b0;
            exit_gate      <= 1'b0;
        end
        else begin

            // Default gate state
            entry_gate <= 1'b0;
            exit_gate  <= 1'b0;

            // Vehicle entering
            if (entry_sensor && !entry_sensor_d) begin

                // Check whether parking is available
                if (available_slots > 0) begin

                    // Find first free parking slot
                    for (i = 0; i < NUM_SLOTS; i = i + 1) begin
                        if (!slot_status[i]) begin
                            slot_status[i] <= 1'b1;
                            i = NUM_SLOTS; // Stop after first free slot
                        end
                    end

                    entry_gate <= 1'b1;
                end
                else begin
                    parking_full <= 1'b1;
                    entry_gate   <= 1'b0;
                end
            end

            // Vehicle exiting
            if (exit_sensor && !exit_sensor_d) begin

                // Find first occupied slot and free it
                for (i = 0; i < NUM_SLOTS; i = i + 1) begin
                    if (slot_status[i]) begin
                        slot_status[i] <= 1'b0;
                        i = NUM_SLOTS; // Stop after first occupied slot
                    end
                end

                exit_gate <= 1'b1;
            end

            // Update number of available slots
            case (slot_status)
                4'b0000: available_slots <= 4;
                4'b0001,
                4'b0010,
                4'b0100,
                4'b1000: available_slots <= 3;

                4'b0011,
                4'b0101,
                4'b0110,
                4'b1001,
                4'b1010,
                4'b1100: available_slots <= 2;

                4'b0111,
                4'b1011,
                4'b1101,
                4'b1110: available_slots <= 1;

                4'b1111: available_slots <= 0;

                default: available_slots <= 0;
            endcase

            // Full indication
            if (slot_status == {NUM_SLOTS{1'b1}})
                parking_full <= 1'b1;
            else
                parking_full <= 1'b0;
        end
    end

endmodule