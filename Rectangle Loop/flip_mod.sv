module flip
  (// parameters
    // input matrix, r1, r2, c1, c2
    // output matrix
    
    // loop through each value in m
    // track the current index in blob of bits with (row num * width + col num)
    
    // check if flip needs to happen-
    // willFlip = (currIdx == [r1][c1]|[r1][c2]|[r2][c1]|[r2][c2])
    // checking if at flipping coord
    
    // if statements are not synthesizable, so we use a mux
    // mux to flip based on willFlip
    
    // if true, call another module which does the physical flipping
    

endmodule
    
module flipmux
  (// input: willFlip, matrix, index of flip
    // output: flipped matrix
    
    // takes willFlip and if true, return flipped matrix
    
endmodule
    
module bitflipping
  (// input: matrix, index of flip
    // output: flipped matrix
    
    // must flip only the bit at the index
    
endmodule
