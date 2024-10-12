`timescale 1ns/1ns
module block_nonblock;
  logic [2:0]a,b;
  initial begin
	$dumpvars;
    a = 0;
    #5 a = 1;
    #5 a = 2;
    #5 a <= 3;
    #5 a = 4;
  end
  initial begin
    b = 0;
     b <= #5  1;
     b <= #10 2;
     b = #15 3;
     b <= #20 4;
  end
  initial  $monitor("Time: %0t | a = %0d| b = %0d", $time, a,b);
endmodule

