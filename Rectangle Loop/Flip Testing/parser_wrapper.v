module parser_wrapper(
    input         clk,
    input         start,
    input  [15:0] from_pc,
    output        done,
    output [15:0] to_pc
);
    reg [7:0]  base_addr;
    reg [1:0]  r1, r2, c1, c2;

    always @(posedge clk) begin
        base_addr <= from_pc[15:8];
        r1        <= from_pc[7:6];
        r2        <= from_pc[5:4];
        c1        <= from_pc[3:2];
        c2        <= from_pc[1:0];
    end

    wire [15:0] flipped_data;

    flip_controller #(
			  .ROWS (4),
			  .COLS (4),
			  .DATA_WIDTH (8)
			  ) controller_inst (
        .clk(clk),
        .start(start),
        .base_addr(base_addr),
        .r1(r1),
        .r2(r2),
        .c1(c1),
        .c2(c2),
        .done(done),
        .flipped_out(flipped_data)
    );

    assign to_pc = flipped_data;
endmodule
