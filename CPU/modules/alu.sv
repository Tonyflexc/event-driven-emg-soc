module alu #(parameter N = 32)
            (input logic [N-1:0] a, b,
             input logic [3:0] alu_ctrl,
             output logic [N-1:0] result,
             output logic zero
            );

        always @(*) begin 
            case (alu_ctrl)
                0: result = a + b;
                1: result = a - b;
                2: result = a & b;
                3: result = a | b;
                4: result = a ^ b;
                5: result = ($signed(a) < $signed(b));
                6: result = (a < b);
                7: result = a << b[4:0];
                8: result = a >> b[4:0];
                9: result = $signed(a) >>> b[4:0];
                default: result = '0;
            endcase
        end

        assign zero = (result == '0);

endmodule