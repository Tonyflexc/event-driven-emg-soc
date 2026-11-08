`timescale 1ns/1ps

module alu_tb;

    logic [31:0] a, b, result;
    logic [3:0] alu_ctrl;
    logic zero;

    alu #(.N(32)) dut(
        .a(a),
        .b(b),
        .result(result),
        .alu_ctrl(alu_ctrl),
        .zero(zero)
    );

    initial begin
        //ADD test
        a = 15;
        b = 7;
        alu_ctrl = 0;
        #1;

        if (result !== 22)
            $fatal(1, "ADD failed!");

        //SUB test
        a = 15;
        b = 15;
        alu_ctrl = 1;
        #1;

        if (result !== 0 || zero !== 1)
            $fatal(1, "SUB failed!");

        //SLT test
        a = -5;
        b = 3;
        alu_ctrl = 5;
        #1;

        if (result !== 1)
            $fatal(1, "SLT failed!");

        //SLTU test
        a = 32'hFFFFFFFB;
        b = 3;
        alu_ctrl = 6;
        #1;

        if (result !== 0)
            $fatal(1, "SLTU failed!");

        //SLL test
        a = 5;
        b = 3;
        alu_ctrl = 7;
        #1;

        if (result !== 40)
            $fatal(1, "SLL failed!");

        //SRL test
        a = 16;
        b = 2;
        alu_ctrl = 8;
        #1;

        if (result !== 4)
            $fatal(1, "SRL failed!");

        //SRA test
        a = -8;
        b = 2;
        alu_ctrl = 9;
        #1;

        if (result !== -2)
            $fatal(1, "SRA failed!");

        $display("All tests passed!");
        $finish;

    end


endmodule