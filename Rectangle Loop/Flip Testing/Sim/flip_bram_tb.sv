`timescale 1ns/1ps

module tb_parser_wrapper;

  logic clk = 0;
  logic reset;
  logic start;
  wire done;
  wire [3:0] leds;

  parser_wrapper dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .leds(leds)
  );

  always #5 clk = ~clk;

  initial begin
    reset = 1;
    start = 0;

    repeat (2) @(posedge clk);
    reset = 0;

    repeat (2) @(posedge clk);

    // first flip
    @(posedge clk);
    start <= 1;
    @(posedge clk);
    start <= 0;

    wait (dut.controller_inst.done);  // wait for first flip to complete
    $display("First flip done! LEDs = %b", leds);

    // idle time before starting again
    repeat (2) @(posedge clk);

    // second flip 
    @(posedge clk);
    start <= 1;
    @(posedge clk);
    start <= 0;

    wait (dut.controller_inst.done);  // wait for second flip to complete
    $display("Second flip done! LEDs = %b", leds);

    repeat (20) @(posedge clk);
    $finish;
  end

endmodule
