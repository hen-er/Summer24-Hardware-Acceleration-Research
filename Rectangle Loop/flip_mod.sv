module flip
  #(parameter int ROWS = 4,
    parameter int COLS = 4) // arbitrary sizes
  (input logic [ROWS][COLS] m_in,
   input logic [1:0] r1,
   input logic [1:0] r2,
   input logic [1:0] c1,
   input logic [1:0] c2,
   output logic [ROWS][COLS] m_out);
    
  logic clk;
  
    // generate a mask which places 1's at the flip coords and 0's everywhere else
    // declare matrix-length mask
    logic [ROWS][COLS] mask;
    // loop through each index
  // use a variable (looping) to check if the current index is equal to the length of the whole array
  // loop when variable looping is 0
  always @(posedge clk) begin
        
    // use mux to assign the proper value for the location
      
    
    // XOR the mask with the original matrix
endmodule
    
    
module mux(
  input logic [1:0] r1, 
  input logic [1:0] r2, 
  input logic [1:0] c1, 
  input logic [1:0] c2, 
  input logic [1:0] row, 
  input logic [1:0] col,
  output logic out);
  
  // translate the r
  out = ((row == r1) && (col == c1) ||
        ((row == r1) && (col == c2) ||
        ((row == r2) && (col == c1) ||
         ((row == r2) && (col == c2) ? 1'b1 : 1'b0;
  
endmodule
      
