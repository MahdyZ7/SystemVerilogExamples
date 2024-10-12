# System Verilog examples

This is a set of examples of system verilog codes with the associated testbenches

The examples have been tested with and run using Questasim. It should work with Modelsim too. Some examples can be run using icarus verilog compiler and displayed using gtkwave.

A Makefile and a sim.do file is included with every example.
```bash
make help	## for a list of commands available
make all	## The default. simulate using Questasim / Modelsim and display all waves
make compile	## compile using Questasim to check for syntax errors
make cli	## Command line simulation using Questasim / Modelsim
make do		## Use sim.do file for simulation
make icarus	## simulate using icarus and display all waves
make wave	## display waveforms of prevoius simulation
make clean	## remove all simulation and graph files
make re		## clean and resimulate
```
This has been tested on Ubuntu 22.04.5 LTS. If have any problem runninig the Makefiles make sure Modelsim is installed correctly, added to execurtable path, add the command is labeld correctly in the Makefile **vsim.exe** could be changed to **vsim** and so on in the Makefile*

[ModelSim documentation](https://ww1.microchip.com/downloads/aemdocuments/documents/fpga/ProductDocuments/ReleaseNotes/modelsim_me_v105c_ref.pdf)