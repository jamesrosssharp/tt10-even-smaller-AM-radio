/* vim: set et ts=4 sw=4: */

/*
	tiny-am-sdr

rf_mixer_nco.v: Downconvert to IF frequency

License: MIT License

Copyright 2023 J.R.Sharp

*/

module rf_mixer_nco
(
    input  clk,
    input  RSTb,
    input  RF_IN,
    output RF_OUT,
    input  [15:0] phase_inc,
    output reg signed [3:0]  if_out,
    output reg signed [3:0]  cos_out
);

reg rf_a, rf_b;

always @(posedge clk)
begin
    if (RSTb == 1'b0)
    begin
        rf_a <= 1'b0;
        rf_b <= 1'b0;
    end else begin
        rf_a <= RF_IN;
        rf_b <= rf_a;    
    end
end

assign RF_OUT = rf_b;

reg [15:0] nco_phase;

always @(posedge clk)
begin
    if (RSTb == 1'b0)
        nco_phase <= 16'd0;
    else
        nco_phase <= nco_phase + phase_inc;
end

/* COS Lookup table */

reg signed [3:0] mem [0:15];
initial mem[0] = 8'h7;
initial mem[1] = 8'h7;
initial mem[2] = 8'h5;
initial mem[3] = 8'h3;
initial mem[4] = 8'h0;
initial mem[5] = 8'hd;
initial mem[6] = 8'ha;
initial mem[7] = 8'h8;
initial mem[8] = 8'h8;
initial mem[9] = 8'h8;
initial mem[10] = 8'ha;
initial mem[11] = 8'hd;
initial mem[12] = 8'h0;
initial mem[13] = 8'h3;
initial mem[14] = 8'h5;
initial mem[15] = 8'h7;

always @(posedge clk)
begin
    if (rf_b == 1'b0)
        if_out <= mem[nco_phase[15:12]];
    else
        if_out <= -mem[nco_phase[15:12]];
    cos_out <= mem[nco_phase[15:12]]; 
end


endmodule
