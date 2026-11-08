module adder #(parameter N = 32)(
    input  logic [N-1:0] a, b,
    output logic [N-1:0] sum
);

    assign sum = a + b;

endmodule