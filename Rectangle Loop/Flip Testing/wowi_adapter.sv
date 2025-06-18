module wowi_adapter #(
    parameter DATA_WIDTH = 8,
    parameter WORD_BYTES = 2
)(
    input logic clk,
    input logic st_read,
    input logic st_write,
    input logic [7:0] base_addr,
    input logic [WORD_BYTES*DATA_WIDTH-1:0] write_data,
    output logic [WORD_BYTES*DATA_WIDTH-1:0] read_data,
    output logic flip_ready,
    output logic wrt_done
);

    logic [(DATA_WIDTH-1):0] bram_dout;
    logic [(DATA_WIDTH-1):0] bram_addr;
    logic [(DATA_WIDTH-1):0] bram_din;
    logic bram_we;

    bram_port bram_u (
        .clk(clk),
        .write_en(bram_we),
        .address(bram_addr),
        .data_in(bram_din),
        .data_out(bram_dout)
    );

    typedef enum logic [1:0] {IDLE, READ_ADDR, READ_DATA, WRITE} state_t;
    state_t state, next;
    logic [1:0] count;

    always_ff @(posedge clk) begin
        state <= next;
        case (state)
            IDLE: begin
                bram_we <= 0;
                flip_ready <= 0;
                wrt_done <= 0;
                count <= 0;
            end
            
            READ_ADDR: begin
                bram_we <= 0;
                bram_addr = base_addr + count;
            end
        
            READ_DATA: begin
                read_data[count*DATA_WIDTH +: DATA_WIDTH] <= bram_dout;
                if (count == WORD_BYTES-1) flip_ready <= 1;
                count <= count + 1;
            end
            
            WRITE: begin
                bram_we <= 1;
                bram_din <= write_data[count*DATA_WIDTH +: DATA_WIDTH];
                bram_addr <= base_addr + count;
                if (count == WORD_BYTES-1) wrt_done <= 1;
                count <= count + 1;
            end
        endcase
    end

    always_comb begin
        case (state)
            IDLE: begin
                if (st_read)  next = READ_ADDR;
                else if (st_write) next = WRITE;
                else next = IDLE;
            end
            
            READ_ADDR: next = READ_DATA;

            READ_DATA: begin
                if (count == WORD_BYTES-1) next  = IDLE;
                else next = READ_ADDR;
            end

            WRITE: begin
                if (count == WORD_BYTES-1) next  = IDLE;
                else next = WRITE;
            end
            
            default: begin
                next = IDLE;   
            end
        endcase
    end
endmodule
