module flip_controller #(
    parameter ROWS = 4,
    parameter COLS = 4,
    parameter DATA_WIDTH = 8
)(
    input  logic clk,
    input  logic start,
    input  logic [7:0] base_addr,
    input  logic [1:0] r1, r2, c1, c2,
    output logic done,
    output logic [ROWS*COLS-1:0] flipped_out
);
    logic adapter_ready, adapter_done, flip_enable;
    logic rd_cmd, wr_cmd;
    logic [ROWS*COLS-1:0] word_in, word_out;

    // Word Width Adapter
    wowi_adapter #(
        .DATA_WIDTH(DATA_WIDTH),
        .WORD_BYTES((ROWS*COLS)/DATA_WIDTH)
    ) adapter (
        .clk(clk),
        .st_read(rd_cmd),
        .st_write(wr_cmd),
        .base_addr(base_addr),
        .write_data(word_out),
        .read_data(word_in),
        .flip_ready(adapter_ready),
        .wrt_done(adapter_done)
    );

    // Flip Module
    flip #(.ROWS(ROWS), .COLS(COLS)) flip_u (
        .clk(clk),
        .m_in(word_in),
        .r1(r1), .r2(r2), .c1(c1), .c2(c2),
        .enable(flip_enable),
        .m_out(word_out),
        .flip_done(flip_done)
    );

    typedef enum logic [2:0] {S_IDLE, S_READ, S_FLIP, S_WAIT_FLIP, S_WRITE, S_DONE} state_t;
    state_t state, next;

    always_ff @(posedge clk) begin
        state <= next;
        case (state)
            S_READ: begin
                rd_cmd <= 1;
                flip_enable <= 0;
                wr_cmd <=  0;
                done <= 0;
            end
            S_FLIP: begin
                rd_cmd <= 0;
                flip_enable <= 1;
                wr_cmd <=  0;
                done <= 0;
            end
            S_WRITE: begin
                rd_cmd <= 0;
                flip_enable <= 0;
                wr_cmd <=  1;
                done <= 0;
            end
            S_DONE: begin
                rd_cmd <= 0;
                flip_enable <= 0;
                wr_cmd <=  0;
                done <= 1;
            end
            
        endcase
    end
    
    always_comb begin

        case (state)
            S_IDLE: begin
                if (start) next = S_READ; //instead of start, this would ideally be based on # of flips needed
                else next = S_IDLE;
            end
            
            S_READ: begin
                if (adapter_ready) next = S_FLIP;
                else next = S_READ;
            end

            S_FLIP: next = S_WAIT_FLIP;

            S_WAIT_FLIP: begin
                if (flip_done) next = S_WRITE;
                else next = S_WAIT_FLIP;
            end

            S_WRITE: begin
                if (adapter_done) next = S_DONE;
                else next = S_WRITE;
            end

            S_DONE: next = S_IDLE;
            
            default: next = S_IDLE;
            
        endcase
    end

    assign flipped_out = word_out; //maybe should make this sync too?
endmodule
