`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2024 12:30:55 PM
// Design Name: 
// Module Name: hamming_top
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

module hamming_top(input [3:0] btn, input [3:0] a, output [3:0] led
);
    wire [3:0] data; //will hold the final, decoded/corrected message

    hamming_f hamming (btn, a, data);
    
    //LEDs SHOULD reflect the original message as indicated by swithes
    assign led[0] = data[0];
    assign led[1] = data[1];        
    assign led[2] = data[2];
    assign led[3] = data[3];
endmodule