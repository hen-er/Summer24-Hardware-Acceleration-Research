`timescale 1ns / 1ps


module decoder(
    input logic [7:1] encoded_data,//the data has its parity bits set BUT might have a fault injected
    output logic [3:0] data//original message as set by switches
    );
    
    logic error_index = 7'b0000_000;
    logic [7:1] corrected_data;
    initial corrected_data = '0;
    
    always_comb 
    begin
    error_index = ^encoded_data;//the error is spelled out by the XOR of the whole block
    if (error_index != 7'b0) corrected_data = error_index ^ encoded_data;
    else corrected_data = encoded_data;
    end
    
    //only selecting message bits, excluding redundant parity bits
    assign data = {encoded_data[7:5], encoded_data[3]};
    
endmodule