module random_variables_example1 #(parameter int NUM_CYCLES = 10);

  // Declare variables
  bit [2:0] rand_bits; // 3 random bits
  logic reset;
  // Clock signal for assertions
  bit clk;
  initial clk = 0;
  always #5 clk = ~clk; // 10 time units clock period
	logic [7:0] j;

  // Randomize the variables and run assertions for NUM_CYCLES clock cycles
  initial begin
    reset = rand_bits[0];
    for (int i = 0; i < NUM_CYCLES; i++) begin
      @(posedge clk); // Wait for the positive edge of the clock
	j = i;
      if (!std::randomize(rand_bits)) begin
        $display("Randomization failed at cycle %0d!", i);
      end else begin
        $display("Cycle %0d: rand_bits = %0b", i, rand_bits);
      end

    end
    $stop; // Stop the simulation after NUM_CYCLES clock cycles
  end
always @(posedge clk) begin
      // Assertions to demonstrate usage
      // Check individual bits
      assert (rand_bits[0] == 0 || rand_bits[0] == 1) else $display("ASSERTION_FAIL: rand_bits[0] out of range at cycle %0d!", j);
      assert (rand_bits[1] == 0 || rand_bits[1] == 1) else $display("ASSERTION_FAIL: rand_bits[1] out of range at cycle %0d!", j);
      assert (rand_bits[2] == 0 || rand_bits[2] == 1) else $display("ASSERTION_FAIL: rand_bits[2] out of range at cycle %0d!", j);

      // Implication: If rand_bits[0] is 0, then rand_bits[1] should be 1
      //assert (rand_bits[0] == 0 |-> rand_bits[1] == 1) else $display("rand_bits[1] is not 1 when rand_bits[0] is 0 at cycle %0d!", i);
	    assert property (rand_bits[0] == 0 |-> rand_bits[1] == 1) else $display("ASSERTION_FAIL: rand_bits[1] is not 1 when rand_bits[0] is 0 at cycle %0d!", j);

	  
      // Strong Implication: If rand_bits[0] is 1, then rand_bits[2] should be 0
      //assert (rand_bits[0] == 1 |=> rand_bits[2] == 0) else $display("rand_bits[2] is not 0 when rand_bits[0] is 1 at cycle %0d!", i); "Cause syntax error, why ???"
	  assert property (rand_bits[0] == 1 |=> rand_bits[2] == 0) else $display("Implication ASSERTION_FAIL: rand_bits[2] is not 0 when rand_bits[0] is 1 at cycle %0d!", j);

      // Logical AND: rand_bits[0] and rand_bits[1] should both be 1
      assert ((rand_bits[0] == 1) && (rand_bits[1] == 1)) else $display("Strong ASSERTION_FAIL: rand_bits[0] or rand_bits[1] is not 1 at cycle %0d!", j);

      // Logical NOT: rand_bits[2] should not be 1
      assert (!(rand_bits[2] == 1)) else $display("ASSERTION_FAIL: rand_bits[2] is 1 at cycle %0d!", j);

      // Clock cycle counting: rand_bits[0] should be 0 within 10 clock cycles
      assert property (@(posedge clk) disable iff (reset) (rand_bits[0] == 0) [*10]) else $display("ASSERTION_FAIL: rand_bits[0] is not 0 within 10 clock cycles at cycle %0d!", j);
end

endmodule
