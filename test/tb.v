`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // ----------------------------------------------------
  // Wave dump
  // ----------------------------------------------------
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
  end

  // ----------------------------------------------------
  // Signals
  // ----------------------------------------------------
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // ----------------------------------------------------
  // DUT (IMPORTANT: match your TOP MODULE NAME)
  // Replace tt_um_fibonacci_counter if your repo uses different name
  // ----------------------------------------------------
  tt_um_fibonacci_counter user_project (

`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in   (ui_in),
      .uo_out  (uo_out),
      .uio_in  (uio_in),
      .uio_out (uio_out),
      .uio_oe  (uio_oe),
      .ena     (ena),
      .clk     (clk),
      .rst_n   (rst_n)
  );

  // ----------------------------------------------------
  // Clock generation (100 MHz equivalent: 10ns period)
  // ----------------------------------------------------
  always #5 clk = ~clk;

  // ----------------------------------------------------
  // Stimulus
  // ----------------------------------------------------
  initial begin
    // init
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 8'b0;
    uio_in = 8'b0;

    // apply reset for a few cycles
    repeat (3) @(posedge clk);
    rst_n = 1;

    // enable Fibonacci counter
    ui_in[0] = 1'b1;

    // run for observation
    repeat (30) @(posedge clk);

    // pause counter
    ui_in[0] = 1'b0;

    repeat (10) @(posedge clk);

    // resume counter
    ui_in[0] = 1'b1;

    repeat (20) @(posedge clk);

    $finish;
  end

endmodule
