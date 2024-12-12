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

localparam BITS = 14;
localparam MBITS = 8;

reg  signed [BITS - 1:0] yn_1;
wire [MBITS - 1:0] alpha = 9'd255;
wire signed [BITS + MBITS - 1 :0] sum_1 = yn_1 * alpha;

wire signed [BITS - 1:0] sum = sum_1[BITS + MBITS - 1: MBITS] + {{BITS - 4{if_out[3]}}, if_out};

always @(posedge clk)
begin
    if (RSTb == 1'b0) begin

        if_filt_out <= 6'd0;
        yn_1 <= {BITS {1'b0}};

    end else begin

        case (gain_spi)
            2'd0:
                 if_filt_out <= yn_1[BITS - 1: BITS - 6];
            2'd1:
                 if_filt_out <= yn_1[BITS - 2: BITS - 7];
            2'd2:
                 if_filt_out <= yn_1[BITS - 3: BITS - 8];
            default:
                 if_filt_out <= yn_1[BITS - 4: BITS - 9];
        endcase

        yn_1 <= sum;
    end 
end

endmodule
