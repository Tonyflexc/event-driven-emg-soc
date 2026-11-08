module ext (input logic [31:0] instr,
            input logic [2:0] immsrc,
            output logic [31:0] immext
            );

        always_comb begin 
            case (immsrc)
                0: immext = {{20{instr[31]}}, instr[31:20]};
                1: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
                2: immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
                3: immext = {instr[31:12], 12'b0};
                4: immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
                default: immext = '0;
            endcase
            
        end

endmodule