module up_down_counter (
    input logic clk,
    input logic reset,
    input logic up_down, // 1 for up, 0 for down
    output logic [2:0] count
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            count <= 3'b000;
        else if (up_down)
            count <= count + 1;
        else
            count <= count - 1;
    end
endmodule
