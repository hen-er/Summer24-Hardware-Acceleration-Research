module flip_tb();
    
    // params
    parameter ROW = 4;
    parameter COL = 4;
    
    // inputs
    logic clk, reset;
    logic [15:0] m_in;
    logic [1:0] r1, r2, c1, c2;
    
    // outputs
    logic [15:0] m_out;
    logic [15:0] m_exp;
    
    logic [99:0] testvectors[1000:0];
    integer vectorindex, errors;
    
    flip #(.ROWS(ROW), .COLS(COL)) dut(
        .m_in(m_in),
        .r1(r1),
        .r2(r2),
        .c1(c1),
        .c2(c2),
        .m_out(m_out)
    );
    
     // Clock generation: 10ns period
    always begin
        clk = 1; #5; clk = 0; #5;
    end
    
    initial begin
        $readmemb("flip_tv.mem", testvectors);
        vectorindex = 0;
        errors = 0;
        reset = 1;
        #22;
        reset = 0;
    end
    
    always @(posedge clk) begin
        #1;
        {m_in, r1, r2, c1, c2, m_exp} = testvectors[vectorindex];
    end
    
    // Compare results on falling edge of clk
    always @(negedge clk) begin
        if (~reset) begin // Skip checking during reset
            if (m_out !== m_exp) begin // Compare DUT output with expected output
                $display("Error at vector %0d:", vectorindex);
                $display("  Inputs: m_in = %b, r1=%d, r2=%d, c1=%d, c2=%d",
                  m_in, r1, r2, c1, c2);
                $display("  Expected m_out = %b", m_exp);
                $display("  Got      m_out = %b", m_out);
                errors = errors + 1;
            end
            vectorindex = vectorindex + 1; // Move to next test case
        end
    end


  // Dump waveforms and terminate simulation
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        #500;
        $display("Simulation finished with %0d errors.", errors);
        $finish;
    end
     
endmodule
