#quit current sim session
quit -sim

#Design path cd {C:\Users\hani.saleh\OneDrive - ku.ac.ae\Desktop\Vivado\mul_sample_TB}

set RTL_DIR       ./.

#for full debug set this variable to 1
set INCLUDE_ACC  1           ;# Set to 1 for full debug mode (include teh command option +acc) but could slow the simulation for big designs
                               # Set to 0 to exclude +acc= from command line, will give faster simulation but 
			       # no visibility for all kind of signals the design has, not good for debugging

# Determine the access control option based on the variable
if {$INCLUDE_ACC} {
    set ACC_OPTION "+acc"
} else {
    set ACC_OPTION ""
}


vlib count
vmap count count
   --------  Access Control and Debug Options  --------

vlog -sv  -work count  $ACC_OPTION  $RTL_DIR/up_down_counter.sv
vlog -sv  -work count  $ACC_OPTION  $RTL_DIR/tb_up_down_counter.sv


####-novopt
vsim     -voptargs=+acc count.tb_up_down_counter

#############################################
#top module
#vlog +define+SIM=1 -work work   $RTL_DIR/exp.v;
#############################################
#Load signals in wave window


do wave.do

##Run simulation
run -all
