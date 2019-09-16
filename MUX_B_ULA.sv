module MUX_B_ULA (input logic [1:0] SELECT,
                  input logic [63:0] B,
                  input logic [63:0] S_EXT,
                  input logic [63:0] S_EXT_SH_LEFT,
                  output logic [63:0] SAIDA);

    always_comb begin

        if(SELECT == 2'b00) SAIDA[63:0] = B[63:0];
        else if(SELECT == 2'b01) SAIDA[63:0] = 64'd4;
        else if(SELECT == 2'b10) SAIDA[63:0] = S_EXT[63:0];
        else                     SAIDA[63:0] = S_EXT_SH_LEFT[63:0];

    end
endmodule