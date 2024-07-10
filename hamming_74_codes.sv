`timescale 1ns / 1ps
//

module hamming_74(
    input [3:0] SW,//switches
    input [3:0] BTN,//buttons
    //the following outputs would be handy in simulation but pose an issue for synthesis
    //as they need to be connected to pins
    //output logic [3:0] data, 
    //output logic error_index,
    output logic [3:0] LED
    );
    //intermediary variables
    logic [7:1] encoded_data, noisy_data;
    logic [3:0] data; //will hold the final, decoded/corrected message
    
    initial encoded_data = '0;
    initial noisy_data = '0;   
    initial data = '0;
    
    encoder enc(SW[3:0], encoded_data);//encoder
    
    fault_injector noise(encoded_data, BTN, noisy_data);//fault injector
    
    decoder dec(noisy_data, data);//decoder
    
    //LEDs SHOULD reflect the original message as indicated by swithes
    always_comb 
    begin
        LED[0] = data[0];
        LED[1] = data[1];        
        LED[2] = data[2];
        LED[3] = data[3];
    end
endmodule