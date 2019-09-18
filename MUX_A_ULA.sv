module MUX_A_ULA (input logic [63:0] PC,
                 input logic [1:0] SELECT,
                 input logic [63:0] A,
                 output logic [63:0] SAIDA);
    always_comb begin
        if(SELECT==2'b00) SAIDA[63:0] = PC[63:0];
        else if(SELECT==2'b01) SAIDA[63:0] = A[63:0];
        else SAIDA[63:0] = 0;
    end
endmodule