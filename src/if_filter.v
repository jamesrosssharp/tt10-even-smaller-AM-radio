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
    output reg signed [5:0] if_filt_out,
    input [1:0] gain_spi
);

reg signed [13:0] yn_1, yn_2;
reg signed [3:0]  xn_1, xn_2;


wire signed [15:0] a1 = -16'd16347;
wire signed [15:0] a2 = 16'd8182;

wire signed [15:0] b0 = 16'd5;
wire signed [15:0] b2 = -16'd5;

wire signed [29:0] mul_a1 = a1 * yn_1;
wire signed [29:0] mul_a2 = a2 * yn_2;

wire signed [23:0] mul_b0 = b0 * (if_out << 4);
wire signed [23:0] mul_b2 = b2 * (xn_2 << 4);


wire signed [25:0] sum = mul_b0 + mul_b2 - mul_a1[29:6] - mul_a2[29:6];

wire signed [20:0] sum_out = sum[20:0];

always @(posedge clk)
begin
    if (RSTb == 1'b0) begin

        if_filt_out <= 6'd0;
        yn_1 <= 14'd0;
        yn_2 <= 14'd0;
        xn_1 <= 4'd0;
        xn_2 <= 4'd0;


    end else begin

        xn_1 <= if_out;
        xn_2 <= xn_1;

        case (gain_spi)
            2'd0:
                 if_filt_out <= sum[21:16];
            2'd1:
                 if_filt_out <= sum[20:15];
            2'd2:
                 if_filt_out <= sum[19:14];
            default:
                 if_filt_out <= sum[18:12];
        endcase

       // Uncomment this to meet timing on FPGA
        //if_filt_out <= sum_out[16:9];
        yn_1 <= sum_out[20:7];
        yn_2 <= yn_1;
    end 
end

endmodule
