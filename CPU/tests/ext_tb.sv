
`timescale 1ns/1ps

module ext_tb;

    logic [31:0] instr, immext;
    logic [2:0] immsrc;

    ext dut (
        .instr(instr),
        .immsrc(immsrc),
        .immext(immext)
    );

    initial begin

        // Test 1: I-type, immediate = 12
        instr = '0;
        instr[31:20] = 12'd12;
        immsrc = 0;
        #1;

        if (immext !== 32'd12)
            $fatal(1, "I-type failed!");

        // Test 2: S-type, immediate = -12
        instr = '0;
        instr[31:25] = 7'b1111111;
        instr[11:7] = 5'b10100;
        immsrc = 1;
        #1;

        if (immext !== -12)
            $fatal(1, "S-type failed!");

        // Test 3: B-type, offset = 2048
        instr = '0;
        instr[7] = 1'b1;
        immsrc = 2;
        #1;

        if (immext !== 32'd2048)
            $fatal(1, "B-type failed!");

        // Test 4: U-type
        instr = '0;
        instr[31:12] = 20'hABCDE;
        immsrc = 3;
        #1;

        if (immext !== 32'hABCDE000)
            $fatal(1, "U-type failed!");

        // Test 5: J-type, offset = 2048
        instr = '0;
        instr[20] = 1'b1;
        immsrc = 4;
        #1;

        if (immext !== 32'd2048)
            $fatal(1, "J-type failed!");

        // Test 6: Negative branch offset = -4
        instr = '0;
        instr[31] = 1'b1;
        instr[7] = 1'b1;
        instr[30:25] = 6'b111111;
        instr[11:8] = 4'b1110;
        immsrc = 2;
        #1;

        if (immext !== -4)
            $fatal(1, "Negative B-type failed!");

        // Test 7: Negative jump offset = -4
        instr = '0;
        instr[31] = 1'b1;
        instr[19:12] = 8'hFF;
        instr[20] = 1'b1;
        instr[30:21] = 10'h3FE;
        immsrc = 4;
        #1;

        if (immext !== -4)
            $fatal(1, "Negative J-type failed!");

        $display("All extender tests passed!");
        $finish;

    end

endmodule
