module random_variables_example #(parameter int NUM_CYCLES = 10);

  // Declare variables
  bit [7:0] rand_byte;
  int rand_int;
  bit [3:0] rand_nibble;
  logic reset;
  // Clock signal for assertions
  bit clk;
  initial clk = 0;
  always #5 clk = ~clk; // 10 time units clock period

  // Randomize the variables and run assertions for NUM_CYCLES clock cycles
  initial begin
    reset = rand_byte[0];
    for (int i = 0; i < NUM_CYCLES; i++) begin
      @(posedge clk); // Wait for the positive edge of the clock

      if (!std::randomize(rand_byte) || !std::randomize(rand_int) || !std::randomize(rand_nibble)) begin
        $display("Randomization failed at cycle %0d!", i);
      end else begin
        $display("Cycle %0d: rand_byte = %0d, rand_int = %0d, rand_nibble = %0d", i, rand_byte, rand_int, rand_nibble);
      end

      // Assertions to demonstrate usage
      // Range Check for rand_byte
      assert (rand_byte >= 0 && rand_byte <= 255) else $display("rand_byte out of range at cycle %0d!", i);

      // Non-negative Check for rand_int
      assert (rand_int >= 0) else $display("rand_int is negative at cycle %0d!", i);

      // Range Check for rand_nibble
      assert (rand_nibble >= 0 && rand_nibble <= 15) else $display("rand_nibble out of range at cycle %0d!", i);

      // Implication: If rand_byte is even, then rand_int should be non-negative
      assert (rand_byte % 2 == 0 -> rand_int >= 0) else $display("rand_int is negative when rand_byte is even at cycle %0d!", i);

      // Strong Implication: If rand_byte is odd, then rand_nibble should be less than 8
      // assert (rand_byte % 2 == 1 |-> rand_nibble < 8) else $display("rand_nibble is not less than 8 when rand_byte is odd at cycle %0d!", i);

      // Logical AND: rand_byte should be within range and rand_int should be non-negative
      assert ((rand_byte >= 0 && rand_byte <= 255) && (rand_int >= 0)) else $display("rand_byte or rand_int out of range at cycle %0d!", i);

      // Logical NOT: rand_nibble should not be greater than 15
      assert (!(rand_nibble > 15)) else $display("rand_nibble is greater than 15 at cycle %0d!", i);

      // Clock cycle counting: rand_byte should be less than 128 within 10 clock cycles
      assert property (@(posedge clk) disable iff (reset) (rand_byte < 128) [*10]) else $display("rand_byte is not less than 128 within 10 clock cycles at cycle %0d!", i);
    end
    $stop; // Stop the simulation after NUM_CYCLES clock cycles
  end

endmodule
