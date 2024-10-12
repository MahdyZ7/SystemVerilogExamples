module block_nonblock_3;
  logic  a, b, c, d;

  initial begin
    // Monitor the values of a, b, c, and d
    $monitor("Time=%0t: a=%0d, b=%0d, c=%0d, d=%0d", $time, a, b, c, d);
	$dumpfile("dump.vcd"); $dumpvars;
    // Initial values
    a = 0; b = 0; c = 0; d = 0;
	#1;
    // First change: mix of blocking and non-blocking
    a = 1; // Blocking
    b <= a; // Non-blocking
    c = b; // Blocking
    d <= c; // Non-blocking
    #1; // Wait for one time unit

    // Second change: different pattern
    a <= 0; // Non-blocking
    b = a; // Blocking
    c <= b; // Non-blocking
    d = c; // Blocking
    #1; // Wait for one time unit

    // Third change: different pattern
    a = 1; // Blocking
    b <= a; // Non-blocking
    c = b; // Blocking
    d <= c; // Non-blocking
    #1; // Wait for one time unit

    // Fourth change: different pattern
    a <= 0; // Non-blocking
    b = a; // Blocking
    c <= b; // Non-blocking
    d = c; // Blocking
    #1; // Wait for one time unit
  end
endmodule