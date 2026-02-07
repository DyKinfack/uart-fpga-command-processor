`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dylann Kinfack
// 
// Design Name: uart-fpga-command-processor
// Module Name: decoder
// Project Name: uart-fpga-command-processor
// Target Devices: Spartan-7
// Tool Versions: Vivado 2020.2
// Description: 
// EN: Decodes received UART data into opcode and operands. Implements a handshake protocol (cmd_valid / cmd_ack) for safe communication with the ALU.
// DE: Dekodiert empfangene UART-Daten in Opcode und Operanden. Implementiert ein Handshake-Protokoll (cmd_valid / cmd_ack) zur sicheren Übergabe an die ALU.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decoder(
    input clk,
    input [7:0] data,
    input rx_valid,
    input cmd_ack,
    input reset,
    output reg [1:0] opcode,
    output reg [2:0] operand1,
    output reg [2:0] operand2,
    output reg cmd_valid
    );
    
    parameter IDLE=2'b00,
              VALID=2'b01;
    
    reg [1:0] state;        
    
    reg [7:0] rx_data;
    
   //command valid logic und acknoleg
    always @(posedge clk) begin
        if(!reset) begin
           cmd_valid<=0;
           rx_data<=0;
           state<=IDLE;
           end
           
        else begin
           case(state)
               IDLE: begin
                if (rx_valid && !cmd_valid) begin
                    rx_data<= data;
                    cmd_valid<=1;
                    state<=VALID;
//              $display("time=%d \t DECODER ACTIVE: opcode=%b op1=%d op2=%d",$time,
//              opcode, operand1, operand2); 
                end
              end
              
              VALID: begin
                    if(cmd_ack && cmd_valid) begin
                    cmd_valid <=0;
                    state<=IDLE;
                    end
                end
            endcase
         end
            
    end
    
    //opcode and operand extractor
    always @(*)
       begin
        if(state ==VALID) begin
            opcode =  rx_data[7:6];
            operand2 = rx_data[5:3];
            operand1 = rx_data[2:0];
          end
       end     
            
endmodule
