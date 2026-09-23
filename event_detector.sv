module event_detector (
    input  logic       clk,
    input  logic       reset,
    input  logic [7:0] sample,
    input  logic       sample_valid,
    output logic       active
);

    logic [7:0] magnitude_value;

    magnitude #(.N(8)) mag_unit (
        .in(sample),
        .out(magnitude_value)
);


    logic [13:0] stored_sum; // running total from the register
    logic [13:0] next_sum;   // adder result

    adder #(.N(14)) add_unit (
        .a({6'b000000, magnitude_value}), // extend 8 bits to 14
        .b(stored_sum),                    // previous accumulated sum
        .sum(next_sum)
);

    logic [13:0] register_d;
    logic        window_done;

    mux #(.N(14)) mux_unit (
        .in1(14'b0),
        .in2(next_sum),
        .sel(window_done),
        .out(register_d)
);

    register #(.N(14)) accum_reg (
        .clk(clk),
        .en(sample_valid),
        .reset(reset),
        .d(register_d),
        .q(stored_sum)
);
 
    logic [5:0] count;

    counter count_unit (
        .clk(clk),
        .reset(reset),
        .sample_valid(sample_valid),
        .count(count),
        .window_done(window_done)
);

    logic [13:0] threshold_value;
    logic        above_threshold;

    threshold_mux #(.N(14)) threshold_unit (
        .sel(active),
        .t(threshold_value)
);

    comparator #(.N(14)) compare_unit (
        .s(stored_sum),
        .t(threshold_value),
        .out(above_threshold)
);

    fsm state_unit (
        .clk(clk),
        .reset(reset),
        .a(above_threshold),
        .y(active)
);
endmodule