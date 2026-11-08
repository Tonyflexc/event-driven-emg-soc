module register_file #(parameter N = 32)
                      (input logic clk, we3,
                       input logic [4:0] a1, a2, a3,
                       input logic [N-1:0] wd3,
                       output logic [N-1:0] rd1, rd2
                      );

                logic [N-1:0] register [0:31];

                assign rd1 = (a1 == 0) ? '0 : register[a1];
                assign rd2 = (a2 == 0) ? '0 : register[a2];
                    

                always_ff @( posedge clk ) begin 
                    if (we3 && a3 != '0)
                        register[a3] <= wd3;
                    
                end

endmodule