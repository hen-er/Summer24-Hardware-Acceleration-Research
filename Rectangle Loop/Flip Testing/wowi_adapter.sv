`timescale 1ns / 1ps

module wowi_adapter #(
    parameter DATA_WIDTH = 8,
    parameter WORD_BYTES = 2)
    (
    input logic clk, 
    input logic st_read, //assert fetch word
    input logic st_write, // assert write word
    input logic [7:0] base_addr, //byte address of first elt
    input logic [WORD_BYTES*DATA_WIDTH-1:0] write_data,
    output logic [WORD_BYTES*DATA_WIDTH-1:0] read_data,
    output logic ready,         // pulses high one cycle when read_data valid or write done

    //bram connections
    input logic [(DATA_WIDTH-1):0] bram_dout,
    output logic [(DATA_WIDTH-1):0] bram_addr,
    output logic [(DATA_WIDTH-1):0] bram_din,
    output logic bram_we
    );
    
    //states
    typedef enum logic [1:0] {IDLE, READ, WRITE} state_t;
    state_t state, next;
    logic [1:0] count;   
    
    always_ff @(posedge clk) begin
    state <= next;
    if (state == READ)  read_data[count*DATA_WIDTH +: DATA_WIDTH] <= bram_dout;
    if (state == WRITE) bram_din <= write_data[count*DATA_WIDTH +: DATA_WIDTH];
    end
    
    always_comb begin
    //defaults
    next     = state;
    ready    = 1'b0;
    bram_we  = 1'b0;
    
    case (state)
      IDLE: begin
        if (st_read)  next = READ;
        else if (st_write) next = WRITE;
      end
    
      READ: begin
        bram_addr = base_addr + count; //should this be count*datawidth
        if (count == WORD_BYTES-1) begin
          ready = 1;
          next  = IDLE;
        end
      end
    
      WRITE: begin
        bram_we   = 1;
        bram_addr = base_addr + count;
        if (count == WORD_BYTES-1) begin
          ready = 1;
          next  = IDLE;
        end
      end
    endcase
    end
    
    // count logic
    always_ff @(posedge clk) begin
    if (state == IDLE)       count <= 0;
    else if (state != next) count <= count + 1;
    end
    
    
endmodule
