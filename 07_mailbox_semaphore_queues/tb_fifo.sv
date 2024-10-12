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
      wr_en <= 1;
      wr_data <= data;
      @(posedge clk);
      wr_en <= 0;
    end
  endtask

  // Consumer task
  task consumer();
    int data;
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
    end
  endtask

  // Main test
  initial begin
    mb = new();
    sem = new(1);
    // No need to call new() for data_queue, as it grows dynamically

    fork
      producer();
      consumer();
    join

    // Wait for FIFO to be empty after consumption
    wait (empty);
    $display("All data consumed.");
    $stop;
  end
endmodule
