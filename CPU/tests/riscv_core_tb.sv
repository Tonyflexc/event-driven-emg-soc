
`timescale 1ns/1ps

module riscv_core_tb;

    logic clk = 0;
    logic rst;

    riscv_core dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        rst = 1;

        // Initialize data memory
        dut.data_mem.mem[0] = 32'd7;
        dut.data_mem.mem[1] = 32'd5;
        dut.data_mem.mem[3] = 32'd99;

        #12;
        rst = 0;

        // Execute the instruction sequence
        repeat (10) @(posedge clk);
        #1;

        // Verify results
        if (dut.data_mem.mem[2] !== 32'd12)
            $fatal(1, "Failed: ADD/store");

        if (dut.data_mem.mem[3] !== 32'd99)
            $fatal(1, "Failed: BEQ did not skip store");

        if (dut.data_mem.mem[4] !== 32'd12)
            $fatal(1, "Failed: load/store after branch");

        if (dut.pc !== 32'd36)
            $fatal(1, "Failed: final PC");

        $display("PASS: CPU executed test program correctly!");
        $finish;
    end

    initial begin
    $display("Simulation started");
    #1;
    $display("Reached 1 ns");
    end

    always @(negedge clk) begin
    $display("PC=%h Instr=%h ALUCtrl=%d A=%h B=%h Result=%h",
        dut.pc, dut.instr, dut.alu_ctrl,
        dut.dp.rd1, dut.dp.src_b, dut.alu_result);
end

endmodule
