module SIGN_EXT_2 (input logic [31:0] ENTRADA,
                   output logic [63:0] SAIDA);

    always_comb begin
        if(ENTRADA[31] == 1'b0) begin
            SAIDA[63:32] = 32'h00;
        end
        else SAIDA[63:32] = 32'hff;    
    end
endmodule