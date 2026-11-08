module im (input  logic [31:0] pc,
           output logic [31:0] instr
          );

        logic [31:0] mem [0:255];

        initial begin
            $readmemh("program.hex", mem);
        end

        assign instr = mem[pc[9:2]];

endmodule