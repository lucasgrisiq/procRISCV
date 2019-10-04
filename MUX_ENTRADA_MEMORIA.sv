module MUX_ENTRADA_MEMORIA (input logic [1:0] SELETOR,
                            input logic [63:0] B,
                            input logic [63:0] VALOR_MEM, 
                            output logic [63:0] SAIDA);
    always_comb begin
            if(SELETOR == 2'b00) SAIDA = VALOR_MEM;
            else if (SELETOR == 2'b01)begin
                SAIDA[31:0] = B[31:0];
                SAIDA[63:32] = VALOR_MEM[63:32];
            end
            else if (SELETOR == 2'b10)begin
                SAIDA[15:0] = B[15:0];
                SAIDA[63:16] = VALOR_MEM[63:16];
            end
            else if (SELETOR == 2'b11)begin
                SAIDA[7:0] = B[7:0];
                SAIDA[63:8] = VALOR_MEM[63:8];
            end
    end


endmodule 