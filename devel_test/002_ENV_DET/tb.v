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
  wire signed [5:0] ifreq;
  wire signed [7:0] env_out;
  wire [1:0] gain_spi = 2'b00;

  
  envelope_detector env_det (
    clk,
    rst_n,
    ifreq,
    env_out
  ); 

endmodule
