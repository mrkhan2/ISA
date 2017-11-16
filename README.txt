My phase 0 project has a working cpu, regFile, control, and ALU. 

The way to run my files are as follows:

\iverilog -o output -c files.txt
Vvl output

Files.txt has all the files to be compiled. Uncomment line 43 in cpu.v in order to see operations and inputs. Text files folder is where I saved my test outputs and performed 16 logic operations


Those two commands will run the program. The CPU runs all of my main modules:
I-Mem
RegFile
ALU
Control
D-Mem

The I-mem decodes the instruction and passes it to the register file. The control will take the data next and set the appropriate flags. ALU does the logic computations and dmem will store the appropriate words. 

