module with_fork_join;
  // Declare variables
  int a, b, c;
  int x, y, z;
  bit clk;
  // Clock signal generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 time units clock period
  end
  // Task 1: Uses blocking assignments
  task automatic task1;
    begin
      $display("Task 1 started at time %0t, a= %0d, b= %0d, c=a+b= %0d", $time,a,b,c);
      a= 10; b = 20; c = a + b; // Blocking assignment
      $display("Task 1 finished at time %0t, a= %0d, b= %0d, c=a+b= %0d", $time,a,b,c);
    end
  endtask
  // Task 2: Uses non-blocking assignments
  task automatic task2;
    begin
      $display("Task 2 started at time %0t, x= %0d, y= %0d, z=x+y= %0d", $time,x,y,z);
      x <= 30; y <= 40; z <= x + y; // Non-blocking assignment
      $display("Task 2 finished at time %0t, x= %0d, y= %0d, z=x+y= %0d", $time,x,y,z);
    end
  endtask
  // Initial block to demonstrate without and with fork and join
  initial begin

	$dumpvars;
    $display("--------------------------------------------");
    $display(" Start of Fork AND JOin");   
    // Initialize variables
    a = 0; b = 0; c = 0; x = 0; y = 0; z = 0;
    // Display initial values
    $display("Initial values before fork-join: a = %0d, b = %0d, c = %0d,  x = %0d, y = %0d, z = %0d", a, b, c, x, y, z);

    fork
      task1(); // Fork Task 1
      #10;
      task2(); // Fork Task 2
    join
   // Display final values after tasks
    $display("After tasks run: a = %0d, b = %0d, c = %0d,  x = %0d, y = %0d, z = %0d", a, b, c, x, y, z);

    // Wait for a clock edge to ensure non-blocking assignments are updated
    @(posedge clk);
    // Display final values
    $display("-------------");
    $display("Final values after fork-join and 1 clk cycle:\n a = %0d, b = %0d, c = %0d,  x = %0d, y = %0d, z = %0d", a, b, c, x, y, z);
    @(posedge clk); $finish;
  
  end
endmodule
