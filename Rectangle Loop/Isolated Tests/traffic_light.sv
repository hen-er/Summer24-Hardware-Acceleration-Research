`timescale 1ns / 1ps

module traffic_light(input clk, input reset, input P, output logic t_r, output logic t_g, output logic t_b, output logic p_r, output logic p_g, output logic p_b);
   
    typedef enum logic [2:0] {S0, S1, S2, S3} state;
    state curr, next;
   
    reg [24:0] t_delay = 24'b0;
    reg [24:0] p_delay = 24'b0;
   
    always_ff @(posedge clk, posedge reset)
        if (reset) curr <= S0;
        else begin
            curr <= next;
            case (curr)
                S1: t_delay <= t_delay + 1;
                S3: p_delay <= p_delay + 1;
                default: begin
                    t_delay <= 24'b0;
                    p_delay <= 24'b0;
                end
            endcase
        end
       
    always_comb
        case (curr)
            S0: begin
                if (P) next = S1;
                else next = S0;
                end
            S1: begin
                if (t_delay[24]) next = S2;
                else next = S1;
               // t_delay = t_delay+1;
                end
            S2: begin
                if (P) next = S2;
                else next = S3;
                end
            S3: begin
                if (p_delay[24]) next = S0;
                else next = S3;
               // p_delay = p_delay + 1;
                end
            default: next = S0;
        endcase    
     
     assign t_g = (curr == S0);
     assign p_g = (curr == S2);
     assign t_r = (curr == S3 | curr == S2);
     assign p_r = (curr == S0 | curr == S1);
     assign t_b = (curr == S1);
     assign p_b = (curr == S3);
     
endmodule
