module MUX_DATA_REG (input logic [63:0] B,
                     input logic [1:0] SELECT,
                     output logic [63:0] SAIDA);

    always_comb begin
        if(SELECT == 2'b00) begin
            SAIDA = B;
        end
        else if(SELECT == 2'b01)
            SAIDA[31:0] = B[31:0];
            if(B[31] == 1) SAIDA[63:32] = 32'hffff;
            else SAIDA[63:32] = 32'h0000;
        end
        else if(SELECT == 2'b10) begin
            SAIDA[15:0] = B[15:0];
            if(B[15] == 1) SAIDA[63:16] = 48'hffffff;
            else SAIDA[63:16] = 48'h000000;
        end
        else begin
            SAIDA[7:0] = B[7:0];
            if(B[7] == 1) SAIDA[63:8] = 56'hfffffff;
            else SAIDA[63:8] = 56'h0000000;
        end
    
    end

endmodule