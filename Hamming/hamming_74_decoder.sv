`timescale 1ns / 1ps


module decoder(
    input logic [7:1] encoded_data,//the data has its parity bits set BUT might have a fault injected
    output logic [3:0] data//original message as set by switches
    );
    
    logic [2:0] error_index;//will contain the "syndrome"
    logic [7:1] corrected_data;
    
    //initializing for safety
    initial begin
    corrected_data = '0;
    error_index = '0;
    end
    
    always_comb 
    begin
    error_index = 3'b000;
    corrected_data = encoded_data;
    for (int i = 1; i < 8; i++) begin
    // XOR the index if the bit is set//the error is spelled out by the XOR'ing the on indices
      if (encoded_data[i]) begin
      error_index = error_index ^ i;
      end
      else continue;
    end
    
    if (error_index != 3'b000) begin
        corrected_data[error_index] = corrected_data[error_index] ^ 1;
    end
    end
    
    //only selecting message bits, excluding redundant parity bits
    assign data = {corrected_data[7:5], corrected_data[3]};
    
endmodule
