module parser_wrapper(
    input         clk,
    input         reset,
    input         start,
    output [3:0] leds
);
    reg [7:0]  base_addr;
    reg [1:0]  r1, r2, c1, c2;
    wire [15:0] flipped_data;
    wire done; //make output later
    
    //edge-detect on start to create a one-cycle pulse
    reg start_d, start_p;
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            start_d <= 0;
            start_p <= 0;
        end
        else begin
            start_p <= start & ~start_d;
            start_d <= start;
            base_addr <= 0;
            r1        <= 1;
            r2        <= 3;
            c1        <= 1;
            c2        <= 2;
        end
    end
    
    assign leds = flipped_data[3:0];

    flip_controller #(
			  .ROWS (4),
			  .COLS (4),
			  .DATA_WIDTH (8)
			  ) controller_inst (
        .clk(clk),
        .reset(reset),
        .start(start_p),
        .base_addr(base_addr),
        .r1(r1),
        .r2(r2),
        .c1(c1),
        .c2(c2),
        .done(done),
        .flipped_out(flipped_data)
    );

endmodule
