module acc_register (
    input  logic        clk,
    input  logic        rst_n,      // Global master reset
    input  logic        load_bias,  // Control line from FSM to load neuron bias
    input  logic signed [31:0] bias,
    input  logic signed [31:0] next_acc,   // From mac_unit output
    output logic signed [31:0] current_acc // Back to mac_unit input
);
    
    always_ff @( posedge clk or negedge rst_n ) begin 
        if (!rst_n) begin
            current_acc <= '0; // Asynchronous Master Reset
        end else begin
            if (load_bias) begin
                current_acc <= bias; // Initialize accumulator with bias
            end else begin
                current_acc <= next_acc; // Normal accumulation latch
            end
        end
    end

endmodule