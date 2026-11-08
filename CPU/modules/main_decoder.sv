module main_decoder (input  logic [6:0] op,
                     output logic regwr, memwr, alusrc, rsltsrc, branch,
                     output logic [2:0] immsrc, 
                     output logic [1:0] aluop
                    );

                always_comb begin
                    //defaults
                    regwr = 0;
                    memwr = 0;
                    alusrc = 0;
                    rsltsrc = 0;
                    branch = 0;
                    immsrc = 0;
                    aluop = 0;

                    case (op)
                         7'b0000011: begin //lw
                            regwr = 1;
                            alusrc = 1;
                            rsltsrc = 1;
                         end
                         7'b0100011: begin //sw
                            immsrc = 3'b001;
                            alusrc = 1;
                            memwr = 1;
                         end
                         7'b0110011: begin // R-type
                            regwr = 1;
                            aluop = 2'b10;
                         end
                         7'b1100011: begin //beq
                            immsrc = 3'b010;
                            branch = 1;
                            aluop = 2'b01;
                         end
                        default: ;
                    endcase
                    
                end
    
endmodule