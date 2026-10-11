module fsm (input logic clk, rst, a, sample_valid,
            output logic y
            );

    typedef enum logic {S0, S1} statetype;
    statetype state, nextstate;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) state <= S0;

        else if (sample_valid)
            state <= nextstate;
         end
    always_comb begin
        case (state)
            S0: if (a) nextstate = S1;
                else   nextstate = S0;

            S1: if (a) nextstate = S1;
                else   nextstate = S0;

            default: nextstate = S0;
        endcase
    end

    assign y = (state == S1);
endmodule