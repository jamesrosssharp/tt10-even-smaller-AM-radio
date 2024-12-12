`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  wire signed [3:0] if_out;
  wire signed [5:0] if_filt_out;
  wire [1:0] gain_spi = 2'b00;

  // Replace tt_um_example with your module name:
if_filter if0
(
    clk,
    rst_n,
    if_out,
    if_filt_out,
    gain_spi
);

endmodule
