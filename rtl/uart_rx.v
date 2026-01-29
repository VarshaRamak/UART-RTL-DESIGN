// UART Receiver RTL
// 8N1 UART protocol, 50MHz clock, 9600 baud

module uart_rx (
    input  wire       clk,
    input  wire       reset,
    input  wire       rx,
    output reg [7:0]  rx_data,
    output reg        rx_done
);

    parameter CLOCK_FREQ = 50_000_000;
    parameter BAUD_RATE  = 9600;
    parameter BAUD_COUNT = CLOCK_FREQ / BAUD_RATE;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [12:0] baud_cnt;
    reg        baud_tick;
    reg [3:0]  bit_cnt;
    reg [7:0]  shift_reg;

    // Baud generator
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

    // UART RX FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 4'd0;
            shift_reg <= 8'd0;
            rx_done   <= 1'b0;
            rx_data   <= 8'd0;
        end else begin
            rx_done <= 1'b0;

            if (baud_tick) begin
                case (state)

                    IDLE: begin
                        if (rx == 1'b0)
                            state <= START;
                    end

                    START: begin
                        state <= DATA;
                    end

                    DATA: begin
                        shift_reg <= {rx, shift_reg[7:1]};
                        bit_cnt <= bit_cnt + 1;

                        if (bit_cnt == 4'd7) begin
                            bit_cnt <= 4'd0;
                            state <= STOP;
                        end
                    end

                    STOP: begin
                        rx_data <= shift_reg;
                        rx_done <= 1'b1;
                        state <= IDLE;
                    end

                    default: state <= IDLE;
                endcase
            end
        end
    end

endmodule

