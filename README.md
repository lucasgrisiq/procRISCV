
# procRISCV
Project assinged by *Infraestrutura de Hardware* discipline on cin-UFPE. 
RISCV multicycle architecture implemented in System Verilog language.

![alt text](https://raw.githubusercontent.com/lucasgrisiq/procRISCV/master/imageMaps/spec/arct.png)

## Instructions and Memory

- Instructions

To make the set of instructions write on *instructions.txt* with the right spacing, for example:

    lbu x2,0(x0)
    slli x3,x2,8
    sh x3,0(x0)
    break
And then run the *montador.exe*

- Memory

Write on the *dados.txt* file, **position in bytes** followed by **data**:

    1 4
    5 6
After that, run *montador_dados.py*

## Run
To start the simulation you should open the project on the ModelSim Software and run the script `do Script`

## Instruction Set
![alt text](https://raw.githubusercontent.com/lucasgrisiq/procRISCV/master/imageMaps/spec/instSet1.png)
![alt text](https://raw.githubusercontent.com/lucasgrisiq/procRISCV/master/imageMaps/spec/instSet2.png)
![alt text](https://raw.githubusercontent.com/lucasgrisiq/procRISCV/master/imageMaps/spec/instSet3.png)
![alt text](https://raw.githubusercontent.com/lucasgrisiq/procRISCV/master/imageMaps/spec/instSet4.png)
![alt text](https://raw.githubusercontent.com/lucasgrisiq/procRISCV/master/imageMaps/spec/instSet5.png)
![alt text](https://raw.githubusercontent.com/lucasgrisiq/procRISCV/master/imageMaps/spec/instSet6.png)
![alt text](https://raw.githubusercontent.com/lucasgrisiq/procRISCV/master/imageMaps/spec/instSet7.png)

 
