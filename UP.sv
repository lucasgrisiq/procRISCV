module UP;
    wire CLK, RST, WRT, RST_STATE_MACHINE;                      //Declaração dos fios de 1bit
    wire [63:0] ENTRADA_DADO,SAIDA_DADO;     //Declaração dos fios de 64bits
    register PC (.clk(CLK), .reset(RST_STATE_MACHINE), .regWrite(WRT), .DadoIn(ENTRADA_DADO), .DadoOut(SAIDA_DADO));
    
    //variaveis da ULA
    wire [63:0] A,B,SAIDA;
    wire [2:0] SELETOR;
    ula64 ULA (.A(SAIDA_DADO),.B(64'd4),.S(ENTRADA_DADO),.Seletor(SELETOR));

    Codigo_fonte FONTE (.CLK(CLK), .RST(RST),.reset_wire(RST_STATE_MACHINE),.operacao(SELETOR),.writeReg(WRT));
endmodule