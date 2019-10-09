module MUX_ALU_ALUOUT(input logic [1:0] SELETOR,
                 input logic [63:0] ALU_OUT,
                 input logic [63:0] ALU,
                 input logic [63:0] MEM_REG,
                 input logic [63:0] SAIDA_MEMORIA,
                 output logic [63:0] SAIDA);

    always_comb begin
        if (SELETOR == 2'b00)     SAIDA = ALU_OUT;
        else if(SELETOR == 2'b01) SAIDA = ALU;
        else if(SELETOR == 2'b10) begin
            SAIDA[63:8] = 56'h000000000000000000000000;
            SAIDA[7:0] = MEM_REG[7:0];
        end
        else if(SELETOR == 2'b11) begin
            SAIDA[63:0] = SAIDA_MEMORIA[63:0];
        end
    end 
endmodule