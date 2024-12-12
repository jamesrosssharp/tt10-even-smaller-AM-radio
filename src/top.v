/* vim: set et ts=4 sw=4: */

/*
	Tiny AM SDR

top.v: Top level

Copyright 2023 J.R.Sharp

*/

module top (
	input	clk,
	input	RSTb,
	output  COMP_OUT,
	output 	reg PWM_OUT,
	input   COMP_IN,

	input 	SCK,
	input	MOSI,
	input	CS

);

wire [15:0] phase_inc;
wire [1:0]  gain_spi;

spi spi0
(
    clk,
    RSTb,
    MOSI,
    SCK,
    CS,

    phase_inc,
    gain_spi

);

wire [3:0] if_out;
wire signed [3:0] cos_out;

/* Mix and direct convert*/
rf_mixer_nco nco0
(
    clk,
    RSTb,
    COMP_IN,
    COMP_OUT,
    phase_inc,
    if_out,
    cos_out
);

wire signed [5:0] if_filt_out;

/* Low pass filter */
if_filter filt0
(
    clk,
    RSTb,
    if_out,
    if_filt_out,
    gain_spi
);

wire [7:0] env_det_out;

envelope_detector det0
(
    clk,
    RSTb,
    if_filt_out,
    env_det_out
);

reg [7:0] count; 

always @(posedge clk) begin
	if (RSTb == 1'b0) begin
		count <= 8'd0;
		PWM_OUT <= 1'b0;
	end else begin
		count <= count + 1;
		PWM_OUT <= (count < env_det_out) ? 1'b1 : 1'b0;
	end	
end

endmodule
