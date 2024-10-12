//First, let's define a class with random variables:
class MyClass;
    rand bit [2:0] my_rand_var;  // 3-bit random variable
    randc bit [2:0] my_randc_var; // 3-bit cyclic random variable
endclass

// Next, we'll create a testbench module to instantiate the class and randomize the variables:

module rand_randc;
    initial begin
		//use automatic by default
        automatic MyClass obj = new();
        // Randomize and display values for a few iterations
        repeat (10) begin
            if (obj.randomize()) begin
                $display("rand: %0d, 	randc: %0d", obj.my_rand_var, obj.my_randc_var);
            end else begin
                $display("Randomization failed");
            end
        end
		$stop;
	end
endmodule

