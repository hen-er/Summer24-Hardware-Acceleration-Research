`timescale 1ns / 1ps

module bram_port(
    input clk, 
    input write_en, 
    input ena,
    input [7:0]address, 
    input [7:0]data_in, 
    output [7:0]data_out
    );
    
    blk_mem_gen_1 bram(.clka(clk),.addra(address),.dina(data_in),.douta(data_out),.wea(write_en), .ena(ena));
    
endmodule
