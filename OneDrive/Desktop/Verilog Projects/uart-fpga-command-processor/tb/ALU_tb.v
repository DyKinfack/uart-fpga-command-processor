`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2026 12:14:36
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb();
    reg clk; 
    reg reset;
    reg cmd_valid;
    reg [1:0] opcode;
    reg [2:0] op1;
    reg [2:0] op2;
    wire start_TX;
    wire cmd_ack;
    wire [5:0] result;
    
    ALU dut(.clk(clk), .reset(reset),
            .cmd_valid(cmd_valid), .opcode(opcode),
            .op1(op1), .op2(op2), .start_TX(start_TX),
            .cmd_ack(cmd_ack), .result(result));
            
   //clock generation
   always #10 clk=~clk;
   
   initial begin
   
   $monitor("time=%d \t cmd_ack=%b \t opcode=%b \t op1=%b \t op2=%b \t result=%b \t start_TX=%b", $time, cmd_ack, opcode, op1, op2, result, start_TX);
   clk=0;
   reset=0;
   cmd_valid=0;
   
   #40 reset=1;
   opcode=2'd0; op1=3'd3; op2=3'd3;
   
   #20 cmd_valid=1;
   
   #20 cmd_valid =0; // only one cycle high
   
   #80 $stop;
   
   end
endmodule
