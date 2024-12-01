/* vim: set et ts=4 sw=4: */

/*
	Tiny AM SDR

envelope_detector.v: Envelope Detector

Copyright 2023 J.R.Sharp

*/

module envelope_detector (
    input clk,
    input RSTb,
    input signed [7:0]  ifreq,
    output reg signed [7:0] env_out
); 

wire [3:0] env_det = (ifreq < 0) ? -ifreq : ifreq;

// Uncomment this to meet timing in ice40 FPGA
/*reg [7:0] env_det;

always @(posedge clk)
begin
    if (RSTb == 1'b0) begin
        env_det <= 8'd0;
    end else begin
        if (ifreq < 0)
            env_det <= -ifreq;
        else
            env_det <= ifreq;
    end
end*/

/* Low pass filter */

/* Filter formula:
*
*   1024 * yn0 = (1023) yn_1 + (1) xn
*
*/

reg [19:0] yn_1;
wire [9:0] alpha = 10'd1023;
wire [29:0] alpha_yn_1 = alpha * yn_1;
wire [19:0] sum = alpha_yn_1[29:10] + env_det;

always @(posedge clk)
begin
    if (RSTb == 1'b0) begin
        yn_1 <= 20'd0;
    end else begin    
        yn_1 <= sum;
        env_out <= yn_1[17:10];
    end        
end


endmodule
