`timescale 1ns / 1ps

module bram_tb;
    
    // inputs
    logic clk, write_en;
    logic [7:0]address;
    logic [7:0]data_in;
    
    // outputs
    logic [7:0]data_out;
    
    bram dut(.clk (clk),
    .write_en (write_en),
    .address  (address),
    .data_in  (data_in),
    .data_out (data_out));
    
    initial
    begin
    clk = 0;
    address = 8'h0;    // First access address 0
    write_en = 0;      // Read from address 0
    #20
    address = 8'h5;    // Change to address 5
    data_in = 8'h67;   // Data to write
    write_en = 1;      // Write to address 5
    #20 
    write_en = 0;      // Read from address 5
    #20
    address = 8'h7;
    #20
    address = 8'h2;
    #20
    address = 8'h2;    // Change to address 5
    data_in = 8'h68;   // Data to write
    write_en = 1;
    #20
    write_en = 0;      // Read from address 5
    end
    
    always #10 clk = ~clk;  //Creates clock of period 20 ns
    
endmodule
