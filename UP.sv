module UP  (input logic CLK,
            input logic RST);
    
    logic [1:0]     SELETOR_MUX_B;
    logic           SELETOR_MUX_A;
    logic [63:0]    A,B, SAIDA_MUX_A, INSTR_EXT, DeslocValue, SAIDA_MUX_B;
    logic [2:0]     OPERATION;
    logic [4:0]     WriteRegister, INSTR19_15,INSTR24_20;
    logic [6:0]     OP_CODE;
    logic [31:0]    WriteDataMem, MemOutInst, INSTR31_0;
    logic           wrInstMem, IRWrite;
    wire            WRT_PC, RST_STATE_MACHINE;                      //Declaracao dos fios de 1bit
    wire [63:0]     Alu, rAdressInst, WriteDataReg, AluOut;                 //Declaracao dos fios de 64bits
    
    register PC (.clk(CLK),
                 .reset(RST),
                 .regWrite(WRT_PC),
                 .DadoIn(Alu),
                 .DadoOut(rAdressInst));
    
    Instr_Reg_Risc_V BANCO_INST ( .Instr31_0(INSTR31_0), 
                                  .Clk(CLK),
                                  .Entrada(MemOutInst),
                                  .Reset(RST),
                                  .Instr11_7(WriteRegister),
                                  .Instr19_15(INSTR19_15),
                                  .Instr24_20(INSTR24_20),
                                  .Instr6_0(OP_CODE),          // op_code sai aqui
                                  .Load_ir(IRWrite));

    //variaveis da ULA

    register Alu_Out (.clk(CLK),
                     .reset(RST),
                     .regWrite(),
                     .DadoIn(Alu),
                     .DadoOut(AluOut));

    SIGN_EXT SIGN_EXT (.ENTRADA(INSTR31_0),
                       .SAIDA(INSTR_EXT));

    ShiftLeft ShiftLeft (.ENTRADA(INSTR_EXT),
                         .SAIDA(DeslocValue));

    MUX_A_ULA MUX_A_ULA (.SELECT(SELETOR_MUX_A),
                         .A(A),
                         .PC(rAdressInst),
                         .SAIDA(SAIDA_MUX_A));

    MUX_B_ULA MUX_B_ULA (.SELECT(SELETOR_MUX_B),
                         .B(B),
                         .S_EXT(INSTR_EXT)),
                         .S_EXT_SH_LEFT(DeslocValue),
                         .SAIDA(SAIDA_MUX_B));

    MUX_DATA_REG MUX_DATA_REG (.MEM_DATA_REG(),
                               .ALU_OUT(AluOut),
                               .SELECT(),
                               .SAIDA());



    bancoReg BANCO_REG (.write(),
                        .clock(CLK),
                        .reset(RST),
                        .regreader1(INSTR19_15),
                        .regreader2(INSTR24_20),
                        .regwriteaddress(WriteRegister),
                        .datain(WriteDataReg),
                        .dataout1(A),
                        .dataout2(B));

    ula64 ULA ( .A(SAIDA_MUX_A),
                .B(SAIDA_MUX_B),
                .S(Alu),
                .Seletor(OPERATION));
    
    Memoria32 MEM_32_INSTRUCTIONS ( .Clk(CLK),
                                    .raddress(rAdressInst),
                                    .waddress(Alu),
                                    .Datain(WriteDataMem),
                                    .Dataout(MemOutInst),
                                    .Wr(wrInstMem));
    
    MAQUINA_DE_ESTADOS FONTE (.CLK(CLK),
                              .RST(RST),
                              .op_code(OP_CODE),
                              .reset_wire(RST_STATE_MACHINE),
                              .operacao(OPERATION),
                              .WRITE_PC(WRT_PC),
                              .WR_MEM_INSTR(wrInstMem),
                              .LOAD_IR(IRWrite),
                              .SELETOR_MUX_A(SELETOR_MUX_A),
                              .SELETOR_MUX_B(SELETOR_MUX_B));

endmodule