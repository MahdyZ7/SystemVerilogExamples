//First, let's define a class with random variables:
class MyClass;
    rand bit [2:0] my_rand_var;  // 3-bit random variable
    randc bit [2:0] my_randc_var; // 3-bit cyclic random variable
    randc bit [2:0] my_inline_var; // 3-bit cyclic random variable
 
 // Constraints
     constraint my_constraint {
        my_rand_var > 1;  // Ensure my_rand_var is greater than 1
        my_rand_var < 6;  // Ensure my_rand_var is less than 6
        my_randc_var inside {0, 1, 2, 4, 5, 6, 7}; // Ensure my_randc_var is not equal to 3
} 
   
endclass

// Next, we'll create a testbench module to instantiate the class and randomize the variables:

module rand_randc_const;
     initial begin
        automatic MyClass obj = new(); // Declare obj as automatic
        // Randomize and display values for a few iterations
        repeat (10) begin
            if (obj.randomize() with {obj.my_inline_var inside {1,2,3};}) begin
                if (obj.my_rand_var inside {2, 3, 4, 5} && obj.my_randc_var inside {0, 1, 2, 4, 5, 6, 7}) begin
                    $display("rand: %0d, randc: %0d, inline: %d", obj.my_rand_var, obj.my_randc_var,obj.my_inline_var);
                end else begin
                    $display("Constraint violation: rand = %0d, randc = %0d, inline = %0d", obj.my_rand_var, obj.my_randc_var,obj.my_inline_var);
                end
            end else begin
                $display("Randomization failed");
            end
        end
    end
endmodule