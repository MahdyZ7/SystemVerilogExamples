`timescale 1ns/1ns
module block_nonblock_2;
 logic a=0, b=0, c=0;
  initial begin
	$dumpvars;
	$monitor("Time: %0t | a = %0d| b = %0d| c = %0d| d = %0d | e = %0d| f = %0d", $time, a,b,c,d,e,f);
	#5 a = 1;
    b = a; // b gets the value of a (1) immediately
    c = b; // c gets the value of b (1) immediately
	#5;
  end

  logic d=0, e=0, f=0;
  initial begin
    #5 d <= 1;
    e <= d; // b gets the value of a (1) at the end of the time step
    f <= e; // c gets the value of b (1) at the end of the time step
	#5;
  end
endmodule
