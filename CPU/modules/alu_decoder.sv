module alu_decoder (input  logic [1:0] aluop,
                    input  logic [2:0] funct3,
                    input  logic       funct7b5,
                    output logic [3:0] alu_ctrl
                    );

                always_comb begin
                    alu_ctrl = 4'd0;  // Default: ADD
                    
                    case (aluop)
                         2'b00: alu_ctrl = '0;
                         2'b01: alu_ctrl = 4'b0001;
                         2'b10: begin
                            case (funct3)
                                3'b000: alu_ctrl = funct7b5 ? 4'd1 : 4'd0;
                                3'b111: alu_ctrl = 4'b0010;
                                3'b110: alu_ctrl = 4'b0011;
                                3'b100: alu_ctrl = 4'b0100;
                                3'b010: alu_ctrl = 4'b0101;
                                3'b011: alu_ctrl = 4'b0110;
                                3'b001: alu_ctrl = 4'b0111;
                                3'b101: alu_ctrl = funct7b5 ? 4'b1001 : 4'b1000;
                            endcase
                         end
                        default: ;
                    endcase
                end

endmodule