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
  logic [15:0] mask1, mask2, mask3, mask4;
  logic [3:0] index1, index2, index3, index4;
    
  always_comb begin
        mask1 = mask1 + 1;
        index1 = 15 - (c1*ROWS + r1);
        mask1 = (15'b1 << index1);
      
        mask2 = mask2 + 1;
        index2 = 15 - (c2*ROWS + r1);
        mask2 = (15'b1 << index2);
    
        mask3 = mask3 + 1;
        index3 = 15 - (c1*ROWS + r2);
        mask3 = (15'b1 << index3);
      
        mask4 = mask4 + 1;
        index4 = 15 - (c2*ROWS + r2);  
        mask4 = (15'b1 << index4); 
  end

  
  logic [15:0] finalMask;
  assign finalMask = mask1 + mask2 + mask3 + mask4;
 
  // XOR the mask with the original matrix
  assign m_out = m_in ^ finalMask;
    
endmodule
