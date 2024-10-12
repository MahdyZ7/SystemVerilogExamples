module fifo #(parameter DATA_WIDTH = 8, parameter DEPTH = 16) (
  input logic clk,
  input logic rst_n,
  input logic wr_en,
  input logic rd_en,
  input logic [DATA_WIDTH-1:0] wr_data,
  output logic [DATA_WIDTH-1:0] rd_data,
  output logic full,
  output logic empty
);

  logic [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
  logic [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr;
  logic [$clog2(DEPTH):0] count;

  // Write operation
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr <= 0;
    end else if (wr_en && !full) begin
      fifo_mem[wr_ptr] <= wr_data;
      wr_ptr <= (wr_ptr + 1) % DEPTH; // Wrap around
    end
  end

  // Read operation
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_ptr <= 0;
    end else if (rd_en && !empty) begin
      rd_data <= fifo_mem[rd_ptr];
      rd_ptr <= (rd_ptr + 1) % DEPTH; // Wrap around
    end
  end

  // FIFO status (count management)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= 0;
    end else begin
      if (wr_en && rd_en && !full && !empty) begin
        // No change in count
        count <= count;
      end else if (wr_en && !full) begin
        count <= count + 1;
      end else if (rd_en && !empty) begin
        count <= count - 1;
      end
    end
  end

  assign full = (count == DEPTH);
  assign empty = (count == 0);

endmodule
