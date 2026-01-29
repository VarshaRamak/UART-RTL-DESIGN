// UART Transmitter RTL
// Sends 8-bit data using UART 8N1 protocol

module uart_tx (
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_done
);

    // FSM state encoding
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    // Default UART idle state
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= IDLE;
            tx        <= 1'b1;
            tx_done   <= 1'b0;
            bit_count <= 4'd0;
            shift_reg <= 8'd0;
        end else begin
            case (state)

                IDLE: begin
                    tx      <= 1'b1;
                    tx_done <= 1'b0;
                    if (tx_start) begin
                        shift_reg <= tx_data;
                        state     <= START;
                    end
                end

                START: begin
                    tx    <= 1'b0;   // Start bit
                    state <= DATA;
                end

                DATA: begin
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    bit_count <= bit_count + 1;

                    if (bit_count == 4'd7) begin
                        bit_count <= 4'd0;
                        state <= STOP;
                    end
                end

                STOP: begin
                    tx      <= 1'b1;  // Stop bit
                    tx_done <= 1'b1;
                    state   <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
