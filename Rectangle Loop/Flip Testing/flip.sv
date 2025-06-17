module flip #(
    parameter ROWS = 4,
    parameter COLS = 4
)(
    input logic clk,
    input logic [(ROWS*COLS)-1:0] m_in,
    input logic [1:0] r1, r2, c1, c2,
    input logic enable,
    output logic [(ROWS*COLS)-1:0] m_out,
    output logic flip_done
);
    logic [(ROWS*COLS)-1:0] mask1, mask2, mask3, mask4;
    logic [(ROWS*COLS)-1:0] finalMask;
    logic [(ROWS-1):0] index1, index2, index3, index4;

    always_comb begin
        index1 = (ROWS * COLS - 1) - (r1 * COLS + c1);
        index2 = (ROWS * COLS - 1) - (r1 * COLS + c2);
        index3 = (ROWS * COLS - 1) - (r2 * COLS + c1);
        index4 = (ROWS * COLS - 1) - (r2 * COLS + c2);

        mask1 = 1 << index1;
        mask2 = 1 << index2;
        mask3 = 1 << index3;
        mask4 = 1 << index4;
    end

    assign finalMask = mask1 | mask2 | mask3 | mask4;

    always_ff @(posedge clk) begin
        if (enable) begin
          m_out      <= m_in ^ finalMask;
          flip_done  <= 1;
        end
        else flip_done <= 0;
    end
endmodule
