`timescale 1ns / 1ps


module fault_injector(
    input logic [7:1] encoded_data,//data that has its parity bits set
    input logic [3:0] BTN,//buttons with which we'll "inject" the error
    output logic [7:1] noisy_data
    );
    
    initial noisy_data = '0;
    
    //each button corresponds to error in a certain bit of the message
    //introducing the error like this makes the program more deterministic
    always_comb
    begin
        case (BTN)
            4'b0001: noisy_data = {encoded_data[7:4], encoded_data[3]^1, encoded_data[2:1]};
            4'b0010: noisy_data = {encoded_data[7:6], encoded_data[5]^1, encoded_data[4:1]};
            4'b0100: noisy_data = {encoded_data[7], encoded_data[6]^1, encoded_data[5:1]};
            4'b1000: noisy_data = {encoded_data[7]^1, encoded_data[6:1]};
            default: noisy_data = encoded_data;
        endcase
    end    
endmodule
