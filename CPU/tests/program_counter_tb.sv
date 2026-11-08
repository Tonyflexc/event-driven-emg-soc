`timescale 1ns/1ps

module program_counter_tb;

    logic clk = 0;
    logic rst, en;
    logic [31:0] d, q;

    //instantiating program counter
    program_counter #(.N(32)) dut(
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d),
        .q(q)
    );

    //generating 10ns period
    always #5 clk = ~clk;

    initial begin
        //initialzing inputs
        rst = 0;
        en = 0;
        d = 0;

        //Test 1: Asynchronous resets
        #2 rst = 1;
        #1;
        if (q !== 32'd0)
            $fatal(1, "Reset failed");

        //Test 2: Loading new PC value
        @(negedge clk);
        rst = 0;
        en = 1;
        d = 32'd100;

        @(posedge clk);
        #1;
        if (q !== 32'd100)
            $fatal(1, "PC update failed");

        //Test 3: Hold previous value
        @(negedge clk);
        rst = 0;
        en = 0;
        d = 32'd200;
        
        @(posedge clk);
        #1;
        if (q !== 32'd100)
            $fatal(1, "PC hold failed");

        //Test 4: reset between clock edges
        #3 rst = 1;
        #1;
        if (q !== '0)
            $fatal(1, "Async reset failed");

        $display("All PC tests passed!");
        $finish;
        
    end

    
endmodule