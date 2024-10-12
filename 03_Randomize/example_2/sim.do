#quit current sim session
quit -sim

#Design path cd {C:\Users\hani.saleh\OneDrive - ku.ac.ae\Desktop\Vivado\mul_sample_TB}

set RTL_DIR       ./.
set LIB_NAME    RAND_RANDC_CONST
set FILE_NAME   rand_randc_const.sv
set TB_MODULE_NAME rand_randc_const 

vlib $LIB_NAME

vmap $LIB_NAME $LIB_NAME 
 
vlog -sv  -work $LIB_NAME  +acc  $RTL_DIR/$FILE_NAME

vsim     -voptargs=+acc $LIB_NAME.$TB_MODULE_NAME

#############################################

#create a wave window with all signals in the design
#add wave -r /*

#Load signals in wave window
#do wave.do

##Run simulation
run -all
