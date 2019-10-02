module MUX_DATA_REG (input logic [63:0] MEM_DATA_REG,
                     input logic [63:0] ALU_OUT,
                     input logic [3:0] SELECT,
                     input logic [63:0] PC,
                     output logic [63:0] SAIDA);

    always_comb begin
        if(SELECT == 4'b0000) 
            SAIDA = ALU_OUT;

        else if(SELECT == 4'b0001)          // ld
            SAIDA = MEM_DATA_REG;
        
        else if(SELECT == 4'b0010)
            SAIDA = 64'h0001;
        
        else if(SELECT == 4'b0011) 
            SAIDA = 64'h0000;

        else if(SELECT == 4'b0100)
            SAIDA = PC;
        else if (SELECT == 4'b0101) begin   // lb
            SAIDA[7:0] = MEM_DATA_REG[7:0];
            if(MEM_DATA_REG[7] == 1'b1) SAIDA[63:8] = 56'hffffffffffffff;
            else SAIDA[63:8] = 56'h00000000000000;
        end
        else if (SELECT == 4'b0101) begin   // lh
            SAIDA[15:0] = MEM_DATA_REG[15:0];
            if(MEM_DATA_REG[15] == 1'b1) SAIDA[63:16] = 48'hffffffffffff;
            else SAIDA[63:16] = 48'h000000000000;
        end
        else if (SELECT == 4'b0101) begin   // lw
            SAIDA[31:0] = MEM_DATA_REG[31:0];
            if(MEM_DATA_REG[31] == 1'b1) SAIDA[63:32] = 32'hffffffffff;
            else SAIDA[63:32] = 32'h0000000000;
        end
        else if (SELECT == 4'b0101) begin   // lbu
            SAIDA[7:0] = MEM_DATA_REG[7:0];
            SAIDA[63:8] = 56'h00000000000000;
        end
        else if (SELECT == 4'b0101) begin   // lhu
            SAIDA[15:0] = MEM_DATA_REG[15:0];
            SAIDA[63:16] = 48'h000000000000;
        end
        else if (SELECT == 4'b0101) begin   // lwu
            SAIDA[31:0] = MEM_DATA_REG[31:0];
            SAIDA[63:32] = 32'h0000000000;
        end
    end

endmodule