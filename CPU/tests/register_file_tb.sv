`timescale 1ns/1ps

module register_file_tb;

    logic clk = 0;
    logic we3;
    logic [4:0] a1, a2, a3;
    logic [31:0] wd3, rd1, rd2;

    //instantiating register file
    register_file #(.N(32)) dut(
        .clk(clk),
        .we3(we3),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .wd3(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    //generating 10ns period
    always #5 clk = ~clk;

    initial begin
        //initialzing inputs
        we3 = 1;
        a1 = 5;
        a2 = 0;
        a3 = 5;
        wd3 = 100;

        //Test 1: writing to a register
        @(posedge clk);
        #1;
        if (rd1 !== 32'd100)
            $fatal(1, "Register write failed");

        //Test 2: write enable
        @(negedge clk);
        we3 = 0;
        a1 = 5;
        a2 = 0;
        a3 = 5;
        wd3 = 200;

        @(posedge clk);
        #1;
        if (rd1 !== 32'd100)
            $fatal(1, "Write enable failed");


        $display("All tests passed!");
        $finish;
        
    end

    
endmodule