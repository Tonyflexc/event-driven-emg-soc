module control_unit (input  logic [31:0] instr,
                     output logic        regwr, memwr, alusrc, rsltsrc, branch,
                     output logic [2:0]  immsrc,
                     output logic [3:0]  alu_ctrl
                    );

                logic [1:0] aluop;

                main_decoder main_dec (
                    .op(instr[6:0]),
                    .regwr(regwr),
                    .memwr(memwr),
                    .alusrc(alusrc),
                    .rsltsrc(rsltsrc),
                    .branch(branch),
                    .immsrc(immsrc),
                    .aluop(aluop)
                );

                alu_decoder alu_dec (
                    .aluop(aluop),
                    .funct3(instr[14:12]),
                    .funct7b5(instr[30]),
                    .alu_ctrl(alu_ctrl)
                );

endmodule