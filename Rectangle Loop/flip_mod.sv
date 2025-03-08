module flip
  #(parameter int ROWS = 4,
    parameter int COLS = 4) // arbitrary sizes
  (input logic [15:0] m_in,
   input logic [1:0] r1,
   input logic [1:0] r2,
   input logic [1:0] c1,
   input logic [1:0] c2,
   output logic [15:0] m_out);
    
  logic clk;
  
  // generate a mask which places 1's at the flip coords and 0's everywhere else
  
  // XOR the matrix with the index lengthened to match the form of the matrix as a string
  // creating a mask for every (r,c) combo
  logic [15:0] mask1;
  assign mask1 = mask1 + 1;
  logic index1 = 15 - (c1*ROWS + r1);
  assign mask1 = (15'b1 << index1);
  
  logic [15:0] mask2;
  assign mask2 = mask2 + 1;
  logic index2 = 15 - (c2*ROWS + r1);
  assign mask2 = (15'b1 << index2);

  logic [15:0] mask3;
  assign mask3 = mask3 + 1;
  logic index3 = 15 - (c1*ROWS + r2);
  assign mask3 = (15'b1 << index3);
  
  logic [15:0] mask4;
  assign mask4 = mask4 + 1;
  logic index4 = 15 - (c2*ROWS + r2);
  assign mask4 = (15'b1 << index4);
  
  logic [15:0] finalMask;
  assign finalMask = mask1 + mask2 + mask3 + mask4;
 
  // XOR the mask with the original matrix
  m_out = m_in ^ finalMask;
    
endmodule
