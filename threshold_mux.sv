module threshold_mux # (parameter N = 14)
                   (input logic sel,
                    output logic [N-1:0] t
                   );

            localparam logic [N-1:0] H = 100; // placeholder for test 
            localparam logic [N-1:0] L = 60; // placeholder for test

            assign t = sel ? L : H;
endmodule