module MUX_A_ULA (input logic [63:0] PC,
                 input logic SELECT,
                 input logic [63:0] A,
                 output logic [63:0] SAIDA);
    always_comb begin
        if(SELECT==0) SAIDA[63:0] = PC[63:0];
        else SAIDA[63:0] = A[63:0];
    end
endmodule