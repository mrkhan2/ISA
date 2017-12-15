My phase 2 project attempts to implement a cache and cache controller into my existing ISA design. The snapshots the 3 generic tests and my 1 created test can be found in the 'register outputs' folder. If you would like to any of the 5 test cases, go to instructionMem.v and change the file name. I've included test1.list -> test4.list in this directory so you may test to your liking. test4.list is my own created scenario. 


I was not able to get my unified mem working with my exisiting design, so I continued using Imem and Dmem for this project. I do have a cache controller that attempts to get the correct data to the register files, but it is not fully working. Please check the folder named 'register outputs' to view all of the register files and you will see they are at least partially correct. 


The way to run my files are as follows:

\iverilog -o output -c files.txt
Vvl output



Files.txt has all the files to be compiled. Uncomment line 80 in cpu.v in order to see operations and inputs. If you want to change the test, please go to instructionMem.v and change the test file there.



FOR MY CREATED SCENARIO TEST:

I have created a cache conflict, similar to test scenario 1 that was given. It will store and load constantly and check if my cache can keep up. 