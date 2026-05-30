/*
 * Fibonacci Counter - TinyTapeout Design
 * Copyright (c) 2026
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_fibonacci_counter (
    input  wire [7:0] ui_in,    // optional control inputs
    output wire [7:0] uo_out,   // Fibonacci output
    input  wire [7:0] uio_in,   // unused IO input
    output wire [7:0] uio_out,  // unused IO output
    output wire [7:0] uio_oe,   // IO direction control
    input  wire       ena,      // always 1 when enabled
    input  wire       clk,
    input  wire       rst_n
);

    // ----------------------------------------------------
    // Internal registers for Fibonacci sequence
    // ----------------------------------------------------
    reg [7:0] a;
    reg [7:0] b;

    // Optional enable control (use ui_in[0])
    wire enable = ui_in[0];

    // ----------------------------------------------------
    // Fibonacci sequence logic:
    // a <= b
    // b <= a + b (mod 256)
    // ----------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a <= 8'd0;
            b <= 8'd1;
        end else if (ena && enable) begin
            a <= b;
            b <= a + b;
        end
    end

    // Output current Fibonacci state
    assign uo_out = b;

    // Unused IOs
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Prevent unused warnings
    wire _unused = &{ena, clk, rst_n, ui_in[7:1], uio_in};

endmodule
