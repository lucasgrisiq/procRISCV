module MUX_DATA_REG (input logic [63:0] MEM_DATA_REG,
                     input logic [63:0] ALU_OUT,
                     input logic [1:0] SELECT,
                     output logic [63:0] SAIDA);

    always_comb begin
        if(SELECT == 2'b00) 
            SAIDA = ALU_OUT;

        else if(SELECT == 2'b01)
            SAIDA = MEM_DATA_REG;
        
        else if(SELECT == 2'b10)
            SAIDA = 64'h0001;
        
        else 
            SAIDA = 64'h0000;
    
    end

endmodule