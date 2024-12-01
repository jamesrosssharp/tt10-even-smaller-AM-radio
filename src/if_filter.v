/* vim: set et ts=4 sw=4: */

/*

    Tiny AM SDR

if_filter.v: 455kHz IF filter

Copyright 2023 J.R.Sharp

*/

module if_filter
(
    input clk,
    input RSTb,
    input signed [3:0]  if_out,
    output reg signed [7:0] if_filt_out,
    input [2:0] gain_spi
);

reg  signed [13:0] yn_1;
wire  [9:0] alpha = 10'd1023;
wire signed [23:0] alpha_yn_1 = alpha * yn_1;
wire signed [13:0] sum = alpha_yn_1[23:10] + if_out;

always @(posedge clk)
begin
    if (RSTb == 1'b0) begin

        if_filt_out <= 8'd0;
        yn_1 <= 13'd0;

    end else begin

        case (gain_spi)
            3'd0:
                 if_filt_out <= yn_1[12:5];
            3'd1:
                 if_filt_out <= yn_1[11:4];
            3'd2:
                 if_filt_out <= yn_1[10:3];
            3'd3:
                 if_filt_out <= yn_1[9:2];
            3'd4:
                 if_filt_out <= yn_1[8:1];
            default:
                 if_filt_out <= yn_1[7:0];
        endcase

        yn_1 <= sum;
    end 
end

endmodule
