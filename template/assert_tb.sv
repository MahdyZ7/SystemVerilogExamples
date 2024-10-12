module assert_tb;
 logic clock, a, b, c;
  parameter period = 2;
  
  initial begin
    clock = 0;
    forever #(period/2) clock = ~clock;
  end
  
  initial begin
    $monitor($time, ": a = %d, b = %d, c = %d", a, b, c);
	$dumpvars;
    a = 0; b = 0; c = 0;
	#1
    a = 1;
    b = 1;
	c = 1;
    #2
	a = 0;
	#3
	a = 1;
	b = 0;
	c = 0;
	#4
    $stop;
  end

  // ALL true statments
  property p;
      @(posedge clock) a |-> b;
  endproperty
  assert property(p) $display($time ,": TEST 1 SUCCSESS: b is 1 when a is 1") ;
		else $display($time ,": TEST 1_FAIL: b is not 1 when a is on");
  
  property q;
      @(posedge clock) a |-> ##1 c ;
  endproperty
  assert property(q)  $display($time ,": TEST 2 SUCCSESS: c is 1 after a is 1") ;
		else $display($time ,": TEST 2 FAIL: c is not 1, after one period of a is on");
  
  property r;
      @(posedge clock) a |=> c ;
  endproperty
  assert property(r)  $display($time ,": TEST 3 SUCCSESS: c is 1 after a is 1") ;
		else $display($time ,": TEST 3 FAIL: c is not one when a is on");

    property s;
      @(posedge clock) a |-> c;
  endproperty
  assert property(s) $display($time ,": TEST 4 SUCCSESS: c is 1 when a is 1") ;
		else $display($time ,": TEST 4 FAIL: c is not 1 when a is on");
endmodule