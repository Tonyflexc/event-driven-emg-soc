module mac_unit #(parameter N = 8) 
                 ( input logic signed [N-1:0] x, w,
                   input logic signed [31:0] current_acc,
                   output logic signed [31:0] next_acc
                );

                logic signed [2*N-1:0] product;

                assign product = x * w;

                assign next_acc = current_acc + product;
    
endmodule