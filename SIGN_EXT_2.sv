module SIGN_EXT_2 (input logic [31:0] ENTRADA,
                   output logic [63:0] SAIDA);

    if(ENTRADA[31] == 0)begin
        SAIDA[63:32] == 32'b0;
    end
    else SAIDA[63:32] == 32'hffffffff;