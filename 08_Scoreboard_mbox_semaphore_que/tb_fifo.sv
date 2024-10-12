class scoreboard;
  // Data structure to store expected results
  int unsigned expected_results[$];
  // Data structure to store actual results
  int unsigned actual_results[$];

  // Method to add expected results
  function void addExpectedResult(int unsigned result);
    expected_results.push_back(result);
  endfunction

  // Method to add actual results
  function void addActualResult(int unsigned result);
    actual_results.push_back(result);
  endfunction

  // Method to check if the scoreboard is correct
  function bit isScoreboardCorrect();
    return (expected_results == actual_results);
  endfunction

  // Method to display the scoreboard status
  function void displayStatus();
    $display("Expected Results: %p", expected_results);
    $display("Actual Results: %p", actual_results);
    if (isScoreboardCorrect()) begin
      $display("Scoreboard is correct.");
    end else begin
      $display("Scoreboard is not correct.");
    end
  endfunction
endclass

module tb_fifo;
  // Parameters
  parameter DATA_WIDTH = 8;
  parameter DEPTH = 16;

  // Signals
  logic clk;
  logic rst_n;
  logic wr_en;
  logic rd_en;
  logic [DATA_WIDTH-1:0] wr_data;
  logic [DATA_WIDTH-1:0] rd_data;
  logic full;
  logic empty;

  // Instantiate FIFO
  fifo #(DATA_WIDTH, DEPTH) uut (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generation
  initial begin
    rst_n = 0;
    #10 rst_n = 1;
  end

  // Mailbox and Semaphore
  mailbox #(int) mb;
  semaphore sem;
  scoreboard sb;

  // Declare an integer queue
  int data_queue[$]; // Correct syntax for a queue of integers (no need for new)

  // Producer task
  task producer();
    int data;
    for (int i = 0; i < DEPTH; i++) begin
      data = $urandom_range(0, 255);
      @(posedge clk);
      while (full) @(posedge clk); // Wait until FIFO is not full
      sem.get();
      mb.put(data);
      data_queue.push_back(data); // Push data to queue
      sem.put();
	  sb.addExpectedResult(data);
      wr_en <= 1;
      wr_data <= data;
      @(posedge clk);
      wr_en <= 0;
    end
  endtask


// Scoreboard variables
  int transactions;
  int errors;


  // Consumer task
  task consumer();

    int data;
	int queue_data;
    for (int i = 0; i < DEPTH; i++) begin
      @(posedge clk);
      while (empty) @(posedge clk); // Wait until FIFO is not empty
      sem.get();
      mb.get(data);
      sem.put();
      rd_en <= 1;
      @(posedge clk);
      rd_en <= 0;
      $display("Consumed data: %0d", data);
	  //fixed mismatch
      @(posedge clk);
	  sb.addActualResult(rd_data);

	//Scoreboard checking
	queue_data = data_queue.pop_front;
      if (rd_data !== queue_data) begin
        $display("Error: Expected %0d, got %0d", queue_data , rd_data);          errors = errors + 1;
      end  else $display("Info: Transaction No. %0d, Expected %0d, got %0d", queue_data, transactions, rd_data);
	  transactions +=1 ;
    end
  endtask

  // Main test
  initial begin
    mb = new();
    sem = new(1);
	sb = new();
    // No need to call new() for data_queue, as it grows dynamically

    fork
      producer();
      consumer();
    join

    // Wait for FIFO to be empty after consumption
    wait (empty);
    $display("All data consumed.");
    $display("Total transactions: %0d", transactions);
    $display("Total errors: %0d", errors);
	sb.displayStatus();
    $stop;
  end
endmodule
