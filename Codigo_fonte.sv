module Codigo_fonte(input CLK, input RST, output logic reset_wire, output logic [2:0] operacao, output logic writeReg);
    enum bit[1:0] {reset, soma, espera} estado, prox_estado;

    always_ff @(posedge CLK, posedge RST) begin
        if(RST) estado <= reset;
        else estado <= prox_estado;
    end
    
    
    always_comb begin
        case(estado)
            reset:begin
                reset_wire = 1;
                operacao = 3'b000;
                writeReg = 0;
                prox_estado = espera;
            end

            soma:begin
                reset_wire = 0;
                operacao = 3'b001;
                writeReg = 1'b1;
                prox_estado = espera;
            end
            
            espera:begin
                reset_wire = 0;
                operacao = 0;
                writeReg = 0;
                prox_estado = soma;
            end
           
        
        endcase
    end
endmodule