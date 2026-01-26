`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2026 19:33:46
// Design Name: 
// Module Name: decoder_tb
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


module decoder_tb();

    reg clk;
    reg reset;
    reg rx_valid;
    reg cmd_ack;
    reg [7:0] data;
    wire  cmd_valid; 
    wire [1:0] opcode;
    wire [2:0] operand1;
    wire [2:0] operand2;
    
    decoder dut(.clk(clk), .reset(reset), .rx_valid(rx_valid), 
                .cmd_ack(cmd_ack), .cmd_valid(cmd_valid), .data(data),
                .opcode(opcode), .operand1(operand1),.operand2(operand2));
                
    always #10 clk=~clk;
    
    initial begin
        reset =0;
        clk=0;
        cmd_ack=0;
        rx_valid=0;
        
        $monitor("time=%d \t opcode=%b \t operand1=%b \t operand2=%b", $time, opcode, operand1, operand2);
        
        #20 reset=1;
        
        #20 data=8'hAA;
        rx_valid=1;
        
        #20 rx_valid=0;
        
        #60 cmd_ack=1;
        
        #20 cmd_ack=0;
        
        #80 reset=0;
        
        #1000 $stop;    
    end
endmodule
