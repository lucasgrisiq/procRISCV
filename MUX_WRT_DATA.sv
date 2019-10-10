module MUX_WRT_DATA (input logic [63:0] B,
                     input logic [1:0] SELECT,
                     output logic [63:0] SAIDA);

    always_comb begin
        if(SELECT == 2'b00) begin
            SAIDA               = B;
        end
        else if(SELECT == 2'b01) begin
            SAIDA[31:0] = B[31:0];
            if(B[31] == 1) SAIDA[63:32] = 32'hffffffff;
            else SAIDA[63:32]   = 32'h00000000;
        end
        else if(SELECT == 2'b10) begin
            SAIDA[15:0]         = B[15:0];
            if(B[15] == 1) SAIDA[63:16] = 48'hffffffffff;
            else SAIDA[63:16]   = 48'h0000000000;
        end
        else begin
            SAIDA[7:0]          = B[7:0];
            if(B[7] == 1) SAIDA[63:8] = 56'hfffffffffff;
            else SAIDA[63:8]    = 56'h00000000000000;
        end
    
    end

endmodule