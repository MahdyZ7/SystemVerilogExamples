// fixed module name
module tb_fifo_faulty;
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

  // Mailbox, Semaphore, and Queue
  mailbox #(int) mb;            // Mailbox to pass data between producer and consumer
  semaphore sem;                // Semaphore to control access to shared resources
  int data_queue[$];        // Queue to store the produced data for verification

  // Producer task
  task producer();
    int data;
    for (int i = 0; i < DEPTH; i++) begin
      data = $urandom_range(0, 255); // Generate random data
      sem.get();                     // Lock the resource
      mb.put(data);                  // Put data into the mailbox
      sem.put();                     // Unlock the resource
      @(posedge clk);
    end
  endtask

  // Consumer task
 task consumer();
  int data;
  for (int i = 0; i < DEPTH; i++) begin
    @(posedge clk);
    if (rd_en) begin
      data = data_queue[i]; // Access the data stored in the queue
      if (rd_data !== data) begin
        $error("Data mismatch: FIFO = %0d, Queue = %0d at cycle %0d", rd_data, data, i);
      end else begin
        $display("Data matched: %0d", rd_data);
      end
    end
  end
endtask


  // Main test
  initial begin
    mb = new();           // Initialize the mailbox
    sem = new(1);         // Initialize the semaphore with 1 token
    data_queue = {};      // Initialize the dynamic queue

    // Fork producer and consumer tasks
    fork
      producer();
      consumer();
    join

    // Finish simulation
    $finish;
  end

  // Write and Read Control (controlling FIFO read and write)
 always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    wr_en <= 0;
    rd_en <= 0;
  end else begin
    if (!full && data_queue.size() > 0) begin
      wr_en <= 1;
      wr_data <= data_queue.pop_front(); // Get the next data from the queue
    end else begin
      wr_en <= 0;
    end

    if (!empty) begin
      rd_en <= 1;
    end else begin
      rd_en <= 0;
    end
  end
end

// Stop simulation when all data is consumed
always @(posedge clk) begin
  if (empty && data_queue.size() == 0) begin
    $stop;
  end
end


endmodule
