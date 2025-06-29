module rectlooptb();
 // parameters
  parameter MATRIX_ROW = 2;
  parameter MATRIX_COL = 2;
  
  // inputs
  logic clk, reset; 
  logic [11:0] param;
  logic m[2][2];
  
  // outputs
  logic m_outm[2][2];
  logic m_expected[2][2];

 logic [31:0] vectorindex, errors; // to keep counters as we iterate over testvecto
logic [99:0] testvectors[10000:0];

 // instantiate DUT
  rectangle_loop_2 dut(clk, param, m, m_outm);

 // generate clock
 always 
   begin
 	clk = 1; #5; clk = 0; #5;
 end

 // load TVs and pulse reset
 initial begin
  $readmemb("rect_loop_tv.tv", testvectors);
 vectorindex = 0; errors = 0;
 reset = 1; #22; reset = 0;
 end

 // apply testvectors on rising edge of clk
 always @(posedge clk) begin
   #1; {clk, param, m, m_expected} = testvectors[vectorindex];
 end

 // check results on falling edge of clk
 always @(negedge clk) begin
 if (~reset) begin // skip during reset
  if (m_outm !== m_expected) begin // check result
 $display("Unexpected Result with inputs = %h", {clk, param, m});
    $display(" Expected %h, got %h", m_expected, m_outm);
 errors = errors + 1;
 end
 vectorindex = vectorindex + 1; //iterate to next testvector
 end
 end 
 initial begin
 $dumpfile("dump.vcd");
 $dumpvars;
 #500
 $finish;
 end

endmodule
