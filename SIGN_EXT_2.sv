module SIGN_EXT_2 (input logic [31:0] ENTRADA,
                   output logic [63:0] SAIDA);

    always_comb begin
        SAIDA[31:0] = ENTRADA[31:0];
        if(ENTRADA[31] == 1'b0) begin
            SAIDA[63:32] = 32'b00000000000000000000000000000000;
        end
        else SAIDA[63:32] = 32'b11111111111111111111111111111111;    
    end
endmodule