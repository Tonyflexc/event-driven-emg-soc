module comparator #( parameter N = 14)
                   ( input logic [N-1:0] s, t,
                     output logic out
                   );

            assign out = (s > t);
endmodule