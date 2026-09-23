module slider #(parameter N = 14) 
              ( input logic [7:0] new_magnitude, old_magnitude,
                input logic [N-1:0] current_sum,
                output logic [N-1:0] next_sum);


    logic [N-1:0] extended_new;
    logic [N-1:0] extended_old;

    assign extended_new = {6'b0, new_magnitude};
    assign extended_old = {6'b0, old_magnitude};

    assign next_sum = current_sum + extended_new - extended_old;
endmodule