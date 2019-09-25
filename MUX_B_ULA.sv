module MUX_B_ULA (input logic [2:0] SELECT,
                  input logic [63:0] B,
                  input logic [63:0] S_EXT,
                  input logic [63:0] S_EXT_SH_LEFT,
                  input logic [63:0] EXTENSOR,
                  output logic [63:0] SAIDA);

    always_comb begin

        if(SELECT == 3'b000) SAIDA[63:0] = B[63:0];
        else if(SELECT == 3'b001) SAIDA[63:0] = 64'd4;
        else if(SELECT == 3'b010) SAIDA[63:0] = S_EXT[63:0];
        else if(SELECT == 3'b011) SAIDA[63:0] = S_EXT_SH_LEFT[63:0];
        else SAIDA[63:0] = EXTENSOR[63:0];
    end
endmodule