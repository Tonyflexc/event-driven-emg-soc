module riscv_core (
    input logic clk, rst
);

    // Internal data signals
    logic [31:0] pc, instr;
    logic [31:0] alu_result, write_data, mem_rd;

    // Control signals
    logic       regwr, memwr, alusrc, rsltsrc, branch;
    logic [2:0] immsrc;
    logic [3:0] alu_ctrl;

    // Instruction memory
    im instr_mem (
        .pc(pc),
        .instr(instr)
    );

    // Control unit
    control_unit ctrl (
        .instr(instr),
        .regwr(regwr),
        .memwr(memwr),
        .alusrc(alusrc),
        .rsltsrc(rsltsrc),
        .branch(branch),
        .immsrc(immsrc),
        .alu_ctrl(alu_ctrl)
    );

    // Datapath
    datapath dp (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .mem_rd(mem_rd),
        .regwr(regwr),
        .alusrc(alusrc),
        .rsltsrc(rsltsrc),
        .branch(branch),
        .immsrc(immsrc),
        .alu_ctrl(alu_ctrl),
        .pc(pc),
        .alu_result(alu_result),
        .write_data(write_data)
    );

    // Data memory
    dm data_mem (
        .clk(clk),
        .we(memwr),
        .a(alu_result),
        .wd(write_data),
        .rd(mem_rd)
    );

endmodule
