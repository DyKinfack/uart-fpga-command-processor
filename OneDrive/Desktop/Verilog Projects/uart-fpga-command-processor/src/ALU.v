`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dylann Kinfack
// 
// Design Name: uart-fpga-command-processor
// Module Name: ALU
// Project Name: uart-fpga-command-processor
// Target Devices: Spartan-7
// Tool Versions: Vivado 2020.2
// Description: 
// EN: Synchronous ALU module performing arithmetic operations (add, subtract, multiply, divide) and generating result data for transmission.
// DE: Synchrones ALU-Modul zur Ausführung arithmetischer Operationen (Add, Sub, Mul, Div). Erzeugt Ergebnisdaten und steuert die Rückübertragung.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU( 
    input clk, 
    input reset,
    input cmd_valid,
    input [1:0] opcode,
    input [2:0] op1,
    input [2:0] op2,
    output reg start_TX,
    output reg cmd_ack,
    output reg [7:0] result 
    );

    
//    reg [2:0] op_1;
//    reg [2:0] op_2;
//    reg [1:0] OPCODE;
//    always @(posedge clk) begin
//        if(cmd_valid && !cmd_ack) begin
//             $display("ALU ACTIVE: opcode=%b op1=%d op2=%d", opcode, op1, op2);
//       end
//    end


    always @(posedge clk) begin
        if(!reset) begin
            start_TX<=0;
            cmd_ack <=0;
            result <=0;
            end
            
        else  begin
            cmd_ack <=0;
            start_TX <=0; 
            
          if(cmd_valid) begin 
//            $display("time=%d \t ALU ACTIVE: opcode=%b op1=%d op2=%d",$time,
//              opcode, op1, op2); 
            case(opcode)
            2'd0: result <= op1 + op2;
            2'd1: result <= op1 - op2;
            2'd2: result <= op1 * op2;
            2'd3: result <= (op2 !=0)? op1 / op2: 8'hFF;
            endcase
            
            cmd_ack<=1;
            start_TX <=1;
            end 
        end
     end
           
endmodule
