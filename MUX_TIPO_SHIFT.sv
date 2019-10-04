module MUX_TIPO_SHIFT (input logic [1:0]    seletor,
                       output logic [1:0]   Valor_Shift);

    always_comb begin
        if(seletor == 2'b00)        Valor_Shift = 2'b00; 
        else if(seletor == 2'b01)   Valor_Shift = 2'b01; 
        else                        Valor_Shift = 2'b10;
    end

endmodule