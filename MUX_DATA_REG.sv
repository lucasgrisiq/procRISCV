module MUX_DATA_REG (input logic [63:0] MEM_DATA_REG,
                     input logic [63:0] ALU_OUT,
                     input logic [2:0] SELECT,
                     input logic [63:0] PC,
                     output logic [63:0] SAIDA);

    always_comb begin
        if(SELECT == 3'b000) 
            SAIDA = ALU_OUT;

        else if(SELECT == 3'b001)
            SAIDA = MEM_DATA_REG;
        
        else if(SELECT == 3'b010)
            SAIDA = 64'h0001;
        
        else if(SELECT == 3'b011) 
            SAIDA = 64'h0000;

        else if(SELECT == 3'b100)
            SAIDA = PC;
    
    end

endmodule