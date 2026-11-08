module datapath (input  logic        clk, rst,
                 input  logic [31:0] instr, mem_rd,
                 input  logic        regwr, alusrc, rsltsrc, branch,
                 input  logic [2:0]  immsrc,
                 input  logic [3:0]  alu_ctrl,
                 output logic [31:0] pc, alu_result, write_data
                );

            logic [31:0] pc_next, pc_plus4, pc_target;
            logic [31:0] immext;
            logic        zero, pcsrc;

            assign pcsrc = branch & zero;

            program_counter #(.N(32)) pc_reg (
                .clk(clk),
                .rst(rst),
                .en(1'b1),
                .d(pc_next),
                .q(pc)
            );

            adder #(.N(32)) pc4_adder (
                .a(pc),
                .b(32'd4),
                .sum(pc_plus4)
            );

            adder #(.N(32)) branch_adder (
                .a(pc),
                .b(immext),
                .sum(pc_target)
            );

            mux #(.N(32)) pc_mux (
                .d0(pc_plus4),
                .d1(pc_target),
                .sel(pcsrc),
                .y(pc_next)
            );

            ext extender (
                .instr(instr),
                .immsrc(immsrc),
                .immext(immext)
            );

            logic [31:0] rd1, result, src_b;

            register_file rf (
                .clk(clk),
                .a1(instr[19:15]),
                .a2(instr[24:20]),
                .a3(instr[11:7]),
                .wd3(result),
                .we3(regwr),
                .rd1(rd1),
                .rd2(write_data)
            );

            mux #(.N(32)) alu_mux (
                .d0(write_data),
                .d1(immext),
                .sel(alusrc),
                .y(src_b)
            );

            alu #(.N(32)) alu (
                .a(rd1),
                .b(src_b),
                .alu_ctrl(alu_ctrl),
                .result(alu_result),
                .zero(zero)
            );

            mux #(.N(32)) rslt_mux (
                .d0(alu_result),
                .d1(mem_rd),
                .sel(rsltsrc),
                .y(result)
            );

endmodule