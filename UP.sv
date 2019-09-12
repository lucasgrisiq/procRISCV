module UP(input logic CLK, input logic RST, input logic WR_MEM_INSTR, input logic WRITE_INSTRUCTION);
    wire WRT_PC, RST_STATE_MACHINE;                      //Declaracao dos fios de 1bit
    wire [63:0] ENTRADA_DADO,SAIDA_DADO;     //Declaracao dos fios de 64bits
    register PC (.clk(CLK), .reset(RST_STATE_MACHINE), .regWrite(WRT_PC), .DadoIn(ENTRADA_DADO), .DadoOut(SAIDA_DADO));
    Instr_Reg_Risc_V BANCO_INST ( .Instr31_0(Instr31_0), 
                                  .Clk(CLK),
                                  .Entrada(MEMORIA_OUT),
                                  .Reset(RST),
                                  .Instr11_7(Instr11_7),
                                  .Instr19_15(Instr19_15),
                                  .Instr24_20(Instr24_20),
                                  .Instr6_0(Instr6_0),
                                  .Load_ir(WRITE_INSTRUCTION));

    //variaveis da ULA
    logic [63:0] A,B,SAIDA;
    logic [2:0] SELETOR;
    logic [5:0] Instr11_7, Instr19_15,Instr24_20;
    logic [6:0] Instr6_0;
    logic [31:0] MEMORIA_IN, MEMORIA_OUT, Instr31_0;

    ula64 ULA (.A(SAIDA_DADO),.B(64'd4),.S(ENTRADA_DADO),.Seletor(SELETOR));
    Memoria32 MEM_32_INSTRUCTIONS (.Clk(CLK), .radress(SAIDA_DADO), .wadress(ENTRADA_DADO), .Datain(MEMORIA_IN), .Dataout(MEMORIA_OUT),.Wr(WR_MEM_INSTR));
    MAQUINA_DE_ESTADOS FONTE (.CLK(CLK), .RST(RST),.reset_wire(RST_STATE_MACHINE),.operacao(SELETOR),.writeReg(WRT_PC));

endmodule