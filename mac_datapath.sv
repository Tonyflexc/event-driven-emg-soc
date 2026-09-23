module mac_datapath ( input logic clk, rst_n, load_bias,
                      input logic signed [7:0] x, w,
                      input logic signed [31:0] bias,
                      output logic signed [31:0] current_acc
);

                logic signed [31:0] next_acc_wire;

                mac_unit #(.N(8)) math_guy (
                    .x (x),
                    .w (w),
                    .current_acc (current_acc),
                    .next_acc (next_acc_wire)
                );

                acc_register storage_guy (
                    .clk (clk),
                    .rst_n (rst_n),
                    .bias (bias),
                    .load_bias (load_bias),
                    .next_acc (next_acc_wire),
                    .current_acc (current_acc)
                );

endmodule