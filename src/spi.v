/* vim: set et ts=4 sw=4: */

/*
	1-bit AM radio

spi.v: SPI configuration

*/

module spi
(
    input CLK,
    input RSTb,
    input MOSI,
    input SCK,
    input CS,

    output [15:0] phase_inc,
    output [2:0]  gain

);

localparam state_idle = 2'b00;
localparam state_rx   = 2'b01;
localparam state_done = 2'b10;

reg [23:0] shift_reg;

reg [1:0] state = state_idle;

reg CS_q;
reg CS_qq;
reg CS_qqq;

reg SCK_q;
reg SCK_qq;
reg SCK_qqq;

reg MOSI_q;
reg MOSI_qq;

assign phase_inc = shift_reg[15:0];
assign gain = shift_reg[18:16];

always @(posedge CLK)
begin
    if (RSTb == 1'b0) begin
        state       <= state_idle;

        shift_reg  <= 24'h030987;

        CS_q    <= 1'b0;
        CS_qq   <= 1'b0;
        CS_qqq  <= 1'b0;

        SCK_q   <= 1'b0;
        SCK_qq  <= 1'b0;
        SCK_qqq <= 1'b0;

        MOSI_q  <= 1'b0;
        MOSI_qq <= 1'b0;

    end
    else begin
        CS_q    <= CS;
        CS_qq   <= CS_q;
        CS_qqq  <= CS_qq;

        SCK_q   <= SCK;
        SCK_qq  <= SCK_q;
        SCK_qqq <= SCK_qq;

        MOSI_q  <= MOSI;
        MOSI_qq <= MOSI_q;

        case (state)
            state_idle:
                if (CS_qq == 1'b0 && CS_qqq == 1'b1) begin // falling edge of chip select
                    state       <= state_rx;
                    shift_reg   <= 24'd0;
                end
            state_rx: begin
                if (SCK_qq == 1'b1 && SCK_qqq == 1'b0) begin // rising edge
                    shift_reg <= {shift_reg[22:0], MOSI_qq};     
                end

                if (CS_qq == 1'b1 && CS_qqq == 1'b0) begin
                    state <= state_done;
                end
            end
            state_done: begin
                state <= state_idle;
            end
            default:
                state <= state_idle;
        endcase
    end        
end

endmodule
