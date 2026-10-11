`timescale 1ns/1ps

module event_detector_tb;

    logic clk = 0;
    logic rst;
    logic [7:0] sample;
    logic sample_valid;
    logic active;

    event_detector dut (
        .clk(clk),
        .rst(rst),
        .sample(sample),
        .sample_valid(sample_valid),
        .active(active)
    );

    always #5 clk = ~clk;

    initial begin
    rst = 1;
    sample = 0;
    sample_valid = 0;

    repeat (2) @(negedge clk);
    rst = 0;

    @(negedge clk);
    sample = 8'd10;
    sample_valid = 1;

    @(negedge clk);
    sample_valid = 0;

    @(negedge clk);
    sample = -8'd20;
    sample_valid = 1;

    @(negedge clk);
    sample_valid = 0;

    @(negedge clk);
    sample = 8'd80;
    sample_valid = 1;

    @(negedge clk);
    sample_valid = 0;

    @(negedge clk);
    sample = 8'd0;
    sample_valid = 1;

    repeat (64) @(negedge clk);
    sample_valid = 0;

    @(negedge clk);
    sample = -8'd2;
    sample_valid = 1;

    repeat (256) @(negedge clk);
    sample_valid = 0;

    @(negedge clk);
    sample = 8'd127;
    sample_valid = 0;

    repeat (10) @(negedge clk);

    @(negedge clk);
    sample = 8'h80;
    sample_valid = 1;

    repeat (64) @(negedge clk);
    sample_valid = 0;

    @(negedge clk);
    rst = 1;
    sample_valid = 0;

    @(negedge clk);
    rst = 0;
    sample = 8'd10;
    sample_valid = 1;

    @(negedge clk);
    sample_valid = 0;

    @(negedge clk);
    $display("sum = %0d, active = %0b",
             dut.current_sum, active);
    
    // Reset, then reach 80 while Idle.
    @(negedge clk);
    rst = 1;
    sample_valid = 0;

    @(negedge clk);
    rst = 0;
    sample = 8'd80;
    sample_valid = 1;

    @(negedge clk);
    sample_valid = 0;
    $display("Idle at 80: sum = %0d, active = %0b",
            dut.current_sum, active);

    // Start a fresh test.
    @(negedge clk);
    rst = 1;

    @(negedge clk);
    rst = 0;
    sample = 8'd101;
    sample_valid = 1;

    // Fill the remaining 63 window positions with zeros.
    @(negedge clk);
    sample = 8'd0;

    repeat (63) @(negedge clk);

    // The window now contains 101 followed by 63 zeros.
    // Replace the oldest sample, 101, with 80.
    sample = 8'd80;

    @(negedge clk);
    sample_valid = 0;
    $display("Active at 80: sum = %0d, active = %0b",
            dut.current_sum, active);

    $finish;
end

endmodule