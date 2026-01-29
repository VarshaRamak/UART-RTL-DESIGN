// UART Transmitter RTL
// 8N1 UART protocol, 50MHz clock, 9600 baud

module uart_tx (
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_done
);

    // Parameters
    parameter CLOCK_FREQ = 50_000_000;
    parameter BAUD_RATE  = 9600;
    parameter BAUD_COUNT = CLOCK_FREQ / BAUD_RATE;

    // FSM states
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [12:0] baud_cnt;
    reg        baud_tick;
    reg [3:0]  bit_cnt;
    reg [7:0]  shift_reg;

    // Baud rate generator
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            baud_cnt  <= 13'd0;
            baud_tick <= 1'b0;
        end else begin
            if (baud_cnt == BAUD_COUNT - 1) begin
                baud_cnt  <= 13'd0;
                baud_tick <= 1'b1;
            end else begin
                baud_cnt  <= baud_cnt + 1;
                baud_tick <= 1'b0;
            end
        end
    end

    // UART TX FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= IDLE;
            tx        <= 1'b1;
            tx_done   <= 1'b0;
            bit_cnt   <= 4'd0;
            shift_reg <= 8'd0;
        end else begin
            tx_done <= 1'b0;

            if (baud_tick) begin
                case (state)

                    IDLE: begin
                        tx <= 1'b1;
                        if (tx_start) begin
                            shift_reg <= tx_data;
                            state     <= START;
                        end
                    end

                    START: begin
                        tx    <= 1'b0;
                        state <= DATA;
                    end

                    DATA: begin
                        tx <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        bit_cnt <= bit_cnt + 1;

                        if (bit_cnt == 4'd7) begin
                            bit_cnt <= 4'd0;
                            state   <= STOP;
                        end
                    end

                    STOP: begin
                        tx      <= 1'b1;
                        tx_done <= 1'b1;
                        state   <= IDLE;
                    end

                    default: state <= IDLE;
                endcase
            end
        end
    end

endmodule
