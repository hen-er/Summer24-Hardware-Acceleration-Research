`timescale 1ns/1ps

module flip_top #(
  parameter ADDR_W     = 8,
  parameter DATA_WIDTH = 8,
  parameter ROWS       = 4,
  parameter COLS       = 4
)(
  input  logic                   clk,
  input  logic                   reset_n,
  input  logic                   start,
  input  logic [ADDR_W-1:0]      base_addr,
  input  logic [1:0]             r1, r2, c1, c2,
  output logic                   done,

  output logic                   bram_we,
  output logic [ADDR_W-1:0]      bram_addr,
  output logic [DATA_WIDTH-1:0]  bram_din,
  input  logic [DATA_WIDTH-1:0]  bram_dout
);

  // Instantiate BRAM port
  bram_port bram_u (
    .clk (clk),
    .write_en (bram_we),
    .address (bram_addr),
    .data_in (bram_din),
    .data_out (bram_dout)
  );

  // Instantiate the flip‐controller (which internally hooks the adapter + flip)
  flip_controller #(
    .ROWS       (ROWS),
    .COLS       (COLS),
    .DATA_WIDTH (DATA_WIDTH)
  ) ctrl_u (
    .clk       (clk),
    .start     (start),
    .base_addr (base_addr),
    .r1        (r1),
    .r2        (r2),
    .c1        (c1),
    .c2        (c2),
    .done      (done),
    .bram_we   (bram_we),
    .bram_addr (bram_addr),
    .bram_din  (bram_din),
    .bram_dout (bram_dout)
  );

endmodule
