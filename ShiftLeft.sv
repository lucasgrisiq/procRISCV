module ShiftLeft (input logic [63:0] ENTRADA,
                  input logic [63:0] SAIDA);

    SAIDA = ENTRADA << 2;

endmodule