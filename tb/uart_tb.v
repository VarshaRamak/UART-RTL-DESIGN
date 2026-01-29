`timescale 1ns/1ps

module uart_tb;

    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx;
    wire tx_done;
    wire [7:0] rx_data;
    wire rx_done;

    // Clock generation: 50MHz
    always #10 clk = ~clk;

    // Instantiate TX
    uart_tx tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx(tx),
        .tx_done(tx_done)
    );

    // Instantiate RX
    uart_rx rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    initial begin
        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 8'h00;

        #100;
        reset = 0;

        #100;
        tx_data = 8'hA5;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait(rx_done);
        $display("Received Data = %h", rx_data);

        #1000;
        $finish;
    end

endmodule
