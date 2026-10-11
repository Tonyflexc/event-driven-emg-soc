module register #( parameter N = 14)
                 ( input logic clk, en, rst,
                   input logic [N-1:0] d,
                   output logic [N-1:0] q
                 );

        always_ff @(posedge clk or posedge rst) begin
            if (rst)
                q <= '0;
            else
                q <= en ? d : q;
        end
  
           
endmodule 