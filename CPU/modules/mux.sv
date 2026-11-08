module mux #(parameter N = 32)(
    input  logic [N-1:0] d0, d1,
    input  logic sel,
    output logic [N-1:0] y
);

    assign y = sel ? d1 : d0;

endmodule