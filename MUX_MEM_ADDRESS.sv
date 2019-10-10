module MUX_MEM_ADDRESS(input logic [1:0] SELETOR,
                       input logic [63:0] ALU_OUT,
                       output logic [63:0] address);
    
    always_comb begin
        if(SELETOR == 2'b00) address = ALU_OUT;
        else if(SELETOR == 2'b01) address = 64'h00000000000000fe;
        else if(SELETOR == 2'b10) address = 64'h00000000000000ff;
    end

endmodule