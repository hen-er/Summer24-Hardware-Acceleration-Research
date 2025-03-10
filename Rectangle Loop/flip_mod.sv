module flip
  #(parameter int ROWS = 4,
    parameter int COLS = 4) // arbitrary sizes
  (input logic [(ROWS*COLS)-1:0] m_in,
   input logic [1:0] r1,
   input logic [1:0] r2,
   input logic [1:0] c1,
   input logic [1:0] c2,
   output logic [(ROWS*COLS)-1:0] m_out);
    
   logic clk;
  
    int SIZE = (ROWS*COLS)-1;
    logic [3:0] index1, index2, index3, index4;
    logic [15:0] mask1, mask2, mask3, mask4;

    always_comb begin
        // Calculate indices for each corner
        index1 = (ROWS * COLS - 1) - (r1 * COLS + c1);
        index2 = (ROWS * COLS - 1) - (r1 * COLS + c2);
        index3 = (ROWS * COLS - 1) - (r2 * COLS + c1);
        index4 = (ROWS * COLS - 1) - (r2 * COLS + c2);

        // Generate masks by shifting 1 to the calculated indices
        mask1 = 16'b1 << index1;
        mask2 = 16'b1 << index2;
        mask3 = 16'b1 << index3;
        mask4 = 16'b1 << index4;
    end

    // Combine masks and XOR with input to flip bits
    logic [15:0] finalMask;
    assign finalMask = mask1 | mask2 | mask3 | mask4;
    
    assign m_out = m_in ^ finalMask;
    
endmodule
