module tb_up_down_counter;
    logic clk;
    logic reset;
    logic up_down;
    logic [2:0] count;

    // Instantiate the counter
    up_down_counter uut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period clock
    end

    // Stimulus
    initial begin
        // Monitor the signals
        $monitor("Time: %0t | Reset: %b | Up_Down: %b | Count-b: %b Count-h: %h", $time, reset, up_down, count,count);

        // Apply stimulus
        reset = 1; up_down = 0;
        #10; reset = 0; // Release reset
        #50; up_down = 1; // Count up
        #50; up_down = 0; // Count down
        #50; $stop; // End simulation
    end

    // Display the count value at every clock edge
    always @(posedge clk) begin
        if ((up_down & (count ==0))|(~up_down & (count ==0)))$display("At time %0t the counter rolled back, Count = %b", $time, count);
    end
endmodule
