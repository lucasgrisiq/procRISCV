module MUX_DATA_REG (input logic [63:0] MEM_DATA_REG,
                     input logic [63:0] ALU_OUT,
                     input logic SELECT,
                     output logic [63:0] SAIDA);

    if(SELECT == 0) SAIDA = ALU_OUT;
    else SAIDA = MEM_DATA_REG;

endmodule