module top (
    input  logic clk,
    output logic led
);

    logic [3:0] startup_count = 4'd0;
    logic rst;

    always_ff @(posedge clk) begin
        if (startup_count != 4'd15)
           startup_count <= startup_count + 1'b1;
        end

    assign rst = (startup_count != 4'd15);

logic [17:0] sample_timer;
logic sample_valid;

always_ff @(posedge clk) begin
    if (rst)
        sample_timer <= '0;
    else
        sample_timer <= sample_timer + 1'b1;
end

assign sample_valid = !rst && (sample_timer == 18'd0);

logic [7:0] sample_count;
logic [7:0] sample;

always_ff @(posedge clk) begin
    if (rst)
        sample_count <= '0;
    else if (sample_valid)
        sample_count <= sample_count + 1'b1;
end

assign sample = sample_count[7] ? 8'd4 : 8'd0;

event_detector detector_unit (
    .clk(clk),
    .rst(rst),
    .sample(sample),
    .sample_valid(sample_valid),
    .active(led)
);

endmodule