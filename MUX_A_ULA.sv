module MUX_A_ULA (input logic [63:0] PC,
                 input logic SELECT,
                 input logic [63:0] A,
                 output logic [63:0] SAIDA);

    if(SELECT==0) SAIDA = PC;
    else SAIDA = A;

endmodule