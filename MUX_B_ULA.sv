module MUX_B_ULA (input logic [1:0] SELECT,
                  input logic [63:0] B,
                  input logic [63:0] S_EXT,
                  input logic [63:0] S_EXT_SH_LEFT,
                  output logic [63:0] SAIDA);

    if(SELECT == 2'b00) SAIDA = B;
    else if(SELECT == 2'b01) SAIDA = 64'd4;
    else if(SELECT == 2'b10) SAIDA = S_EXT;
    else                     SAIDA = S_EXT_SH_LEFT;


endmodule