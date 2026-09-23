module fifo #( parameter DATA_WIDTH = 8,
               parameter ADDR_WIDTH = 7
            ) ( 
                input logic clk, rst_n, wr_en,
                input logic [DATA_WIDTH-1:0] w_data,
                output logic [DATA_WIDTH-1:0] event_detector_rd_data,
                input logic [ADDR_WIDTH-1:0] accel_rd_addr,
                output logic [DATA_WIDTH-1:0] accel_rd_data,
                output logic [ADDR_WIDTH-1:0] current_w_ptr
            );

            localparam DEPTH = 1 << ADDR_WIDTH;
            logic [DATA_WIDTH-1:0] memory_matrix [DEPTH-1:0];
            logic [ADDR_WIDTH-1:0] w_ptr;
            assign current_w_ptr = w_ptr;

            always_ff @( posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    w_ptr <= 0;
                end else if (wr_en) begin
                    memory_matrix[w_ptr] <= w_data;
                    w_ptr                <= w_ptr + 1'b1;
                end 
                
            end

            assign accel_rd_data = memory_matrix[accel_rd_addr];
            assign event_detector_rd_data = memory_matrix[w_ptr-7'b1000000];
endmodule