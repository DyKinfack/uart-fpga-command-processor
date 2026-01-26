`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2026 20:05:28
// Design Name: 
// Module Name: UART_TOP_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_TOP_tb();
 
    reg clk;
    reg reset;
    reg TX_start;
    reg [7:0] data;
    wire [7:0] result;
    
    
     // DUT
    UART_TOP dut (
        .clk(clk),
        .reset(reset),
        .data(data),
        .TX_start(TX_start),
        .result(result)
    );

    // 100 MHz Clock
    always #5 clk = ~clk;

always @(posedge clk)
    if(dut.decoder1.cmd_valid)
        $display("CMD_VALID HIGH");
        
        
    initial begin
    
    $monitor("TX=%b \t", dut.uart_tx.TX);
        // Init
        clk = 0;
        reset = 0;
        TX_start = 0;
        data = 8'h00;

        // Reset phase
        #2000;
        reset = 1;

        // Wait for system to stabilize
        #2000;

        // -----------------------------
        // Send command: opcode=01, op1=2, op2=3
        // -----------------------------
        data = 8'h2b; // 00101011
        TX_start = 1;
        #100;
        TX_start = 0;
        
        #2000;
        
        wait(dut.uart_tx.q_busy==0)
        
        #30000;

        // Wait long enough for UART + ALU
        //#900_000;   // 200 µs (safe for UART)

        $display("RESULT = %h", result);

        #100;
        $stop;
    end
endmodule
