module magnitude #(parameter N = 8) 
                  (input logic [N-1:0] new_sample,
                   output logic [N-1:0] out);

    always_comb begin
        if (new_sample[N-1] == 1'b0) begin  
            out = new_sample; // Positive number, output as is
        end else begin
            out = ~new_sample + 1'b1; // Negative number, take two's complement
        end
    end
endmodule
