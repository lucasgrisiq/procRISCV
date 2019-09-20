module MUX_ALU_ALUOUT(output logic [1:0] SELETOR,
                 input logic [63:0] ALU_OUT,
                 input logic [63:0] ALU,
                 output logic [63:0] SAIDA);

                 always_comb begin
                    if (SELETOR == 1'b0) SAIDA = ALU_OUT;
                    else SAIDA = ALU;
                end 
endmodule