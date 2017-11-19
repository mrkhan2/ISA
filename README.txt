My phase 1 project implents data bypassing/forwarding. The snapshots the 3 generic tests and my 1 created test can be found in the 'text files' folder. If you would like to any of the 5 test cases, go to instructionMem.v and change the file name. I've included test1.list -> test4.list in this directory so you may test to your liking. test4.list is my own created scenario.


During my phase 0 project, my output was not coming out correctly and I had to fix that before beginning on Phase 1. I used a small component of the RegFile module in the phase 0 reference you released. I only imitated the way you used writeData in my register file.


The way to run my files are as follows:

\iverilog -o output -c files.txt
Vvl output



Files.txt has all the files to be compiled. Uncomment line 80 in cpu.v in order to see operations and inputs. 


Those two commands will run the program. The CPU runs all of my main modules:
I-Mem
RegFile
Hazard.v
Forward.v
ALU
Control
D-Mem

The I-mem decodes the instruction and passes it to the register file, control unit. and hazard unit. The control will take the data next and set the appropriate flags. ALU does the logic computations and dmem will store the appropriate words. Meanwhile, if a hazard is detected, it will push that concern to the forwarding unit and that will move data to the correct location. 

