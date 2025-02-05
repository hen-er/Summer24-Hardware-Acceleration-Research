`timescale 1ns / 1ps


module rectangle_loop_2
    #(parameter 
      MATRIX_ROW = 2,
      MATRIX_COL = 2)
     (input logic clk,
      input logic [63:0] param,
      input logic m[MATRIX_ROW][MATRIX_COL], /*note that if param is also responsible for matrix dimensions, we need to do something abt this*/
      output logic m_outm[MATRIX_ROW][MATRIX_COL]);
      
      logic [11:0] iterations = 0; //do I do assign statement?
      typedef enum {INIT_ONE, INIT_ZERO, CKBD, FAIL} states; //should I diff between types of states?
      logic r1, r2, c1, c2; //define lenght later
      states state;
      
      always @(posedge clk)
        begin
        //i think i need another case here 
            if (iterations != param[11:0]) //going for num iterations
                begin
                    //choose r1, c1 using LFSR
                    if (m[r1][c1] == 0) 
                        state = INIT_ZERO;
                    else 
                        state = INIT_ONE;
                    
                    case (state)
                        INIT_ZERO: begin
                        //given c1, choose r2 s.t. m[r2][c1] = 1
                        //given r2, now choose c2 s.t. m[r2][c2] = 0
                        if (m[r1][c2] == 1) 
                            state = CKBD;
                        else 
                            state = FAIL;
                        end
                        
                        INIT_ONE: begin
                        //given r1, choose c2 s.t. m[r1][c2] = 0
                        //given c2, now choose r2 s.t. m[r2][c1] = 1
                        if (m[r2][c1] == 0) 
                            state = CKBD; //we have 
                        else 
                            state = FAIL;
                        end
                        
                        CKBD: begin //this is where we swap
                        m_outm[r1][c1] <= ~m_outm[r1][c1];
                        m_outm[r1][c2] <= ~m_outm[r1][c2];
                        m_outm[r2][c1] <= ~m_outm[r2][c1];
                        m_outm[r2][c2] <= ~m_outm[r2][c2];
                        
                        iterations <= iterations + 1;
                        end
                        
                        FAIL: begin
                        //case assignment to make it jump to top
                        end
                    endcase
                end
        end
        
        //im thinking of addic an INIT case that i initially reset to that is basically the state where i choose the first r1 and c1
        //that we we solve the issue with jumping to the top of the fsm
         
endmodule