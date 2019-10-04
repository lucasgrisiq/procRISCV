module UP  (input logic CLK,
            input logic RST);
    
    logic [1:0]     SELETOR_MUX_A, SELETOR_MUX_MEM, SELETOR_P_SHIFT, SAIDA_MUX_SHIFT;
    logic           wrDataMem, RegWrite_banco, WR_ALU_OUT, WRITE_REG_A, WRITE_REG_B,MENOR_ALU;
    logic [63:0]    A,B, SAIDA_MUX_A, INSTR_EXT, DeslocValue, SAIDA_MUX_B, SAIDA_EXTENSOR;
    logic [2:0]     OPERATION, SELETOR_MUX_B;
    logic [3:0]     SELECT_MUX_DATA;
    logic [4:0]     WriteRegister, INSTR19_15,INSTR24_20;
    logic [6:0]     OP_CODE;
    logic [31:0]    WriteDataMem, MemOutInst, INSTR31_0;
    logic           wrInstMem, IRWrite,Seletor_Alu;
    logic            WRT_PC, RST_STATE_MACHINE, ZERO, IGUAL;                      //Declaracao dos fios de 1bit
    logic [63:0]     Alu, PC,SAIDA_MUX_ALU, WriteDataReg, AluOut, SAIDA_MEM_64, MEM_REGISTER64, A_OUT, B_OUT, MUX_TO_MEM,SAIDA_DESLOCAMENTO;                 //Declaracao dos fios de 64bits
    
    register PCreg (.clk(CLK),
                   .reset(RST),
                   .regWrite(WRT_PC),
                   .DadoIn(SAIDA_MUX_ALU),
                   .DadoOut(PC));
   
    register Areg (.clk(CLK),
                .reset(RST),
                .regWrite(WRITE_REG_A),
                .DadoIn(A),
                .DadoOut(A_OUT));

    register Breg (.clk(CLK),
                .reset(RST),
                .regWrite(WRITE_REG_B),
                .DadoIn(B),
                .DadoOut(B_OUT));
    
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

    SIGN_EXT_2 Extensor (.ENTRADA(B_OUT),
                         .SAIDA(SAIDA_EXTENSOR));

    register Alu_Out (.clk(CLK),
                     .reset(RST),
                     .regWrite(WR_ALU_OUT),
                     .DadoIn(Alu),
                     .DadoOut(AluOut));

    register MEM_DATA_REG (.clk(CLK),
                           .reset(RST),
                           .regWrite(wrDataMemReg),
                           .DadoIn(SAIDA_MEM_64),
                           .DadoOut(MEM_REGISTER64));

    SIGN_EXT SIGN_EXT (.ENTRADA(INSTR31_0),
                       .SAIDA(INSTR_EXT));

                       
    Deslocamento ShiftLeft (.Shift(2'b00),
                            .Entrada(INSTR_EXT),
                            .N(6'b000001),
                            .Saida(DeslocValue));
    
    MUX_TIPO_SHIFT MUX_DESLOCAMENTO(.seletor(SELETOR_P_SHIFT),
                                    .Valor_Shift(SAIDA_MUX_SHIFT));
    
    Deslocamento SHIFT_MUX (.Shift(SAIDA_MUX_SHIFT),           // saida Mux_tipo_shift
                            .Entrada(A_OUT),	        //rs1
                            .N(Instr31_0[25:19]), 	        // shamt
                            .Saida(SAIDA_DESLOCAMENTO));	        //rs2

    MUX_A_ULA MUX_A_ULA (.SELECT(SELETOR_MUX_A),
                         .A(A_OUT),
                         .PC(PC),
                         .SAIDA(SAIDA_MUX_A));

    MUX_B_ULA MUX_B_ULA (.SELECT(SELETOR_MUX_B),
                         .B(B_OUT),
                         .S_EXT(INSTR_EXT),
                         .S_EXT_SH_LEFT(DeslocValue),
                         .EXTENSOR(SAIDA_EXTENSOR),
                         .SAIDA(SAIDA_MUX_B));

    MUX_ENTRADA_MEMORIA MUX_ENTRADA_MEMORIA (.SELETOR(SELETOR_MUX_MEM),
                                             .B(B_OUT),
                                             .VALOR_MEM(MEM_REGISTER64),
                                             .SAIDA(MUX_TO_MEM));

    MUX_DATA_REG MUX_DATA_REG2 (.MEM_DATA_REG(MEM_REGISTER64),
                                .ALU_OUT(AluOut),
                                .PC(PC),
                                .SELECT(SELECT_MUX_DATA),
                                .SAIDA_DESLOCAMENTO(SAIDA_DESLOCAMENTO),
                                .SAIDA(WriteDataReg));

    MUX_ALU_ALUOUT MUX_SAIDA_ALU (.SELETOR(Seletor_Alu),
                                  .ALU_OUT(AluOut),
                                  .ALU(Alu),
                                  .SAIDA(SAIDA_MUX_ALU));        

    bancoReg BANCO_REG (.write(RegWrite_banco),
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
                .Seletor(OPERATION),
                .Igual(IGUAL),
                .z(ZERO),
                .Menor(MENOR_ALU));
    
    Memoria32 MEM_32_INSTRUCTIONS ( .Clk(CLK),
                                    .raddress(PC),
                                    .waddress(Alu),
                                    .Datain(WriteDataMem),
                                    .Dataout(MemOutInst),
                                    .Wr(wrInstMem));

    
    Memoria64 MEM_DATA (.raddress(AluOut),
                        .waddress(AluOut),
                        .Clk(CLK),
                        .Datain(MUX_TO_MEM),
                        .Dataout(SAIDA_MEM_64),
                        .Wr(wrDataMem));
    
    MAQUINA_DE_ESTADOS FONTE (.CLK(CLK),
                              .RST(RST),
                              .INSTRUCAO(INSTR31_0),
                              .wrDataMem(wrDataMem),
                              .wrDataMemReg(wrDataMemReg),
                              .WR_BANCO_REG(RegWrite_banco),
                              .WR_ALU_OUT(WR_ALU_OUT),
                              .SELECT_MUX_DATA(SELECT_MUX_DATA),
                              .op_code(OP_CODE),
                              .reset_wire(RST_STATE_MACHINE),
                              .operacao(OPERATION),
                              .WRITE_PC(WRT_PC),
                              .WR_MEM_INSTR(wrInstMem),
                              .LOAD_IR(IRWrite),
                              .SELETOR_MUX_A(SELETOR_MUX_A),
                              .SELETOR_MUX_B(SELETOR_MUX_B),
                              .ZERO_ALU(ZERO),
                              .IGUAL_ALU(ALU),
                              .write_reg_A(WRITE_REG_A),
                              .write_reg_B(WRITE_REG_B),
                              .SELETOR_ALU(Seletor_Alu),
                              .MENOR_ALU(MENOR_ALU),
                              .SELECT_MUX_MEM(SELETOR_MUX_MEM),
                              .SELETOR_SHIFT(SELETOR_P_SHIFT);

endmodule