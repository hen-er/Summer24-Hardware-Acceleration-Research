`timescale 1ns / 1ps

module flip_controller #(
    parameter ROWS      = 4,
    parameter COLS      = 4,
    parameter DATA_WIDTH= 8)
    (
    input  logic         clk,
    input  logic         start,
    input  logic [7:0]   base_addr,
    input  logic [1:0]   r1, r2, c1, c2,
    output logic         done,
    
    input logic [7:0] bram_dout,
    output logic [7:0] bram_addr,
    output logic [7:0] bram_din,
    output logic bram_we 
    );
    
    
    //wires to/from adapter
    logic adapter_ready;
    logic flip_enable;
    logic rd_cmd, wr_cmd;
    logic [ROWS*COLS-1:0] word_in, word_out;
    
    //adapter
    wowi_adapter #(
    .DATA_WIDTH(DATA_WIDTH),
    .WORD_BYTES((ROWS*COLS)/DATA_WIDTH) // e.g. 16 bytes / 8 = 2?
    ) adapter (
    .st_read  (rd_cmd),
    .st_write (wr_cmd),
    .base_addr   (base_addr),
    .write_data  (word_out),
    .read_data   (word_in),
    .ready       (adapter_ready),
    .bram_dout  (bram_dout),    // from BRAM port module
    .bram_addr  (bram_addr),    // back out to BRAM port module
    .bram_din   (bram_din),
    .bram_we    (bram_we)
    );
    
    //flip mod
    flip #(.ROWS(ROWS), .COLS(COLS)) flip_u (
    .m_in (word_in),
    .r1   (r1), .r2(r2), .c1(c1), .c2(c2), .enable(flip_enable),
    .m_out(word_out)
    );
    
    //states
    typedef enum logic [2:0] {S_IDLE, S_READ, S_FLIP, S_WAIT_FLIP, S_WRITE, S_DONE} state_t;
    state_t state, next;


    always_ff @(posedge clk) state <= next;
		
		// FSM logic (combinational part)
    always_comb begin
	   flip_enable = 1'b0;
	   next = state;
	   rd_cmd = 0;
	   wr_cmd = 0;
	   done = 0;
		
		case (state)
		  S_IDLE: if (start) next = S_READ;
		  
		  S_READ: begin
		    rd_cmd = 1;
		    if (adapter_ready) next = S_FLIP;
		  end
		
		  S_FLIP: begin
		    flip_enable = 1'b1;  // assert enable for 1 cycle
		    next = S_WAIT_FLIP;
		  end
		
		  S_WAIT_FLIP: begin
		    // wait one cycle for registered output to stabilize
		    next = S_WRITE;
		  end
		
		  S_WRITE: begin
		    wr_cmd = 1;
		    if (adapter_ready) next = S_DONE;
		  end
		
		  S_DONE: begin
			  done = 1;
			  next = S_IDLE;
		  end
		
		  default: next = S_IDLE;
		endcase
    end
endmodule
   
