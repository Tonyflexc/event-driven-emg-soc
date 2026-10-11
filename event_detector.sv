module event_detector (
    input  logic       clk,
    input  logic       rst,
    input  logic [7:0] sample,
    input  logic       sample_valid,
    output logic       active
);

    logic [7:0] new_magnitude;

    magnitude #(.N(8)) mag_unit (
        .new_sample(sample),
        .out(new_magnitude)
);

    logic [7:0] old_sample;

    buffer #(.DATA_WIDTH(8),
             .ADDR_WIDTH(7)) buffer_unit (
        .clk(clk), 
        .rst(rst),                    
        .wr_en(sample_valid),
        .w_data(sample),
        .event_detector_rd_data(old_sample),
        .accel_rd_addr(7'd0),
        .accel_rd_data(),
        .current_w_ptr()

);

    logic [7:0] old_magnitude;

    magnitude #(.N(8)) oldmag_unit (
        .new_sample(old_sample),
        .out(old_magnitude)
);

    logic [13:0] current_sum, next_sum;

    slider #(.N(14)) slider_unit (
        .new_magnitude(new_magnitude),
        .old_magnitude(old_magnitude),
        .current_sum(current_sum),
        .next_sum(next_sum)
);

    register #(.N(14)) accum_reg (
        .clk(clk),
        .en(sample_valid),
        .rst(rst),
        .d(next_sum),
        .q(current_sum)
);

    logic [13:0] threshold_value;
    logic        above_threshold;

    threshold_mux #(.N(14)) threshold_unit (
        .sel(active),
        .t(threshold_value)
);

    comparator #(.N(14)) compare_unit (
        .s(next_sum),
        .t(threshold_value),
        .out(above_threshold)
);

    fsm state_unit (
        .clk(clk),
        .rst(rst),
        .sample_valid(sample_valid),
        .a(above_threshold),
        .y(active)
);
endmodule