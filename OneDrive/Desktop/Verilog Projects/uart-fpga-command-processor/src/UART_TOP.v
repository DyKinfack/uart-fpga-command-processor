`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dylann Kinfack
// 
// Create Date: 06.12.2025 19:36:31
// Design Name: uart-fpga-command-processor
// Module Name: UART_TOP
// Project Name: uart-fpga-command-processor
// Target Devices: Spartan-7
// Tool Versions: Vivado 2020.2
// Description: 
// EN: Top-level module integrating UART TX, UART RX, decoder and ALU into a complete processing pipeline.
// DE: Top-Level-Modul zur Integration von UART-TX, UART-RX, Decoder und ALU in einer durchgängigen Verarbeitungskette.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_TOP(
    input clk,
    input reset,
    input [7:0] data,
    input TX_start,
    output [7:0] result
    );
    
    wire TX; 
    wire TX_q_busy;
    UART_TX uart_tx(
                .clk(clk), 
                .reset(reset),
                .TX_start(TX_start), 
                .TX_data(data), 
                .TX(TX),
                .q_busy(TX_q_busy)
                );
                    
    
    // UART TX mit UART RX connect
    wire rx_valid; wire [7:0] rx_data;
    UART_RX uart_rx(
                 .clk(clk), 
                 .reset(reset), 
                 .rx(TX), 
                 .rx_data(rx_data),
                 .rx_valid(rx_valid)
                 );
    
    //UART RX with decoder connected
    wire cmd_ack; wire cmd_valid;
    wire [1:0] opcode; wire [2:0] op1; wire [2:0] op2; 
    
    decoder decoder1(
                  .clk(clk), 
                  .reset(reset),
                  .rx_valid(rx_valid),
                  .data(rx_data),
                  .cmd_ack(cmd_ack), 
                  .cmd_valid(cmd_valid),
                  .opcode(opcode), 
                  .operand1(op1),
                  .operand2(op2)
                  );
                     
                     
    //Decoder with ALU connected
    wire START_TX;
    ALU alu(
                .clk(clk), 
                .reset(reset), 
                .cmd_valid(cmd_valid),
                .opcode(opcode), 
                .op1(op1), 
                .op2(op2),
                .cmd_ack(cmd_ack), 
                .start_TX(START_TX),
                .result(result)
                );
                      
    
endmodule
