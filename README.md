
# procRISCV
RISCV multicycle architecture implemented in System Verilog language.



## Instructions and Memory

Instructions

To make the set of instructions write on *instructions.txt* with the right spacing, for example:

    lbu x2,0(x0)
    slli x3,x2,8
    sh x3,0(x0)
    break
And then run the *montador.exe*

Memory
Write on the *dados.txt* file, **position in bytes** followed by **data**:

    1 4
    5 6
After that, run *montador_dados.py*

## Run
To start the simulation you should open the project on the Quartus Software and run the script `do Script`

## Instruction Set


 
