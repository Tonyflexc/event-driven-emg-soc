module counter (
    input  logic       clk,
    input  logic       reset,
    input  logic       sample_valid,
    output logic [5:0] count,
    output logic       window_done
);

    always_ff @(posedge clk) begin
        if (reset)
            count <= 6'd0;
        else if (sample_valid)
            count <= count + 6'd1;
        // Otherwise, count keeps its previous value.
    end

    assign window_done = !reset && sample_valid && (count == 6'd63);

endmodule