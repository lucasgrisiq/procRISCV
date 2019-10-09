module MUX_DATA_REG (input logic [63:0] MEM_DATA_REG,
                     input logic [63:0] ALU_OUT,
                     input logic [3:0] SELECT,
                     input logic [63:0] PC,
                     input logic [63:0] SAIDA_DESLOCAMENTO,
                     output logic [63:0] SAIDA);

    always_comb begin
        if(SELECT == 4'b0000) 
            SAIDA[63:0]          = ALU_OUT[63:0];

        else if(SELECT == 4'b0101)          // ld
            SAIDA[63:0]         = MEM_DATA_REG[63:0];
        
        else if(SELECT == 4'b0010)
            SAIDA[63:0]          = 64'h0001;
        
        else if(SELECT == 4'b0011) 
            SAIDA[63:0]          = 64'h0000;

        else if(SELECT == 4'b0100)
            SAIDA[63:0]          = PC;
        else if (SELECT == 4'b0110) begin   // lb
            SAIDA[7:0]          = MEM_DATA_REG[7:0];
            if(MEM_DATA_REG[7] == 1'b1) SAIDA[63:8] = 56'hffffffffffffff;
            else SAIDA[63:8]    = 56'h00000000000000;
        end
        else if (SELECT == 4'b0111) begin   // lh
            SAIDA[15:0]         = MEM_DATA_REG[15:0];
            if(MEM_DATA_REG[15] == 1'b1) SAIDA[63:16] = 48'hffffffffffff;
            else SAIDA[63:16]   = 48'h000000000000;
        end
        else if (SELECT == 4'b1000) begin   // lw
            SAIDA[31:0]         = MEM_DATA_REG[31:0];
            if(MEM_DATA_REG[31] == 1'b1) SAIDA[63:32] = 32'hffffffffff;
            else SAIDA[63:32]   = 32'h0000000000;
        end
        else if (SELECT == 4'b1001) begin   // lbu
            SAIDA[7:0]          = MEM_DATA_REG[7:0];
            SAIDA[63:8]         = 56'h00000000000000;
        end
        else if (SELECT == 4'b1010) begin   // lhu
            SAIDA[15:0]         = MEM_DATA_REG[15:0];
            SAIDA[63:16]        = 48'h000000000000;
        end
        else if (SELECT == 4'b1011) begin   // lwu
            SAIDA[31:0]         = MEM_DATA_REG[31:0];
            SAIDA[63:32]        = 32'h0000000000;
        end
        else if (SELECT == 4'b1100) begin  // Shift
            SAIDA[63:0]         = SAIDA_DESLOCAMENTO[63:0];
        end
    end

endmodule