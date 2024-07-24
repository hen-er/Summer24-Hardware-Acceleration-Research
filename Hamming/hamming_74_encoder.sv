`timescale 1ns / 1ps


module encoder(
    input logic [3:0] SW,
    output logic [7:1]encoded_data//output variable that will contain our encoded data
    );
    
    always_comb
    begin
    //we get our inputs from the switches as set by the user
        encoded_data[3] = SW[0];
        encoded_data[5] = SW[1];
        encoded_data[6] = SW[2];
        encoded_data[7] = SW[3];
        //setting parity bits by XOR'ing the indices that have their 1st, 2nd and 4th bits "on"
        encoded_data[1] = encoded_data[3] ^ encoded_data[5] ^ encoded_data[7];
        encoded_data[2] = encoded_data[3] ^ encoded_data[6] ^ encoded_data[7];
        encoded_data[4] = encoded_data[5] ^ encoded_data[6] ^ encoded_data[7];
    end                         
    
endmodule
