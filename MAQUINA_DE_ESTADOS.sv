module MAQUINA_DE_ESTADOS  (input CLK, 
                            input RST, 
                            output logic reset_wire, 
                            output logic [2:0] operacao, 
                            output logic WRITE_PC,
                            output logic WRITE_INSTRUCTION, 
                            output logic WR_MEM_INSTR);
    
    enum bit[2:0] {reset, soma, espera, load_reg} estado, prox_estado;

    always_ff @(posedge CLK, posedge RST) begin
        if(RST) estado  <= reset;
        else estado <= prox_estado
    end
    
    
    always_comb begin
        case(estado)
            reset:begin
                WRITE_INSTRUCTION   = 0;
                WR_MEM_INSTR        = 1;
                reset_wire          = 1;
                operacao            = 3'b000;
                WRITE_PC            = 0;
                prox_estado         = espera;
            end

            soma:begin
                WRITE_INSTRUCTION   = 0;
                WR_MEM_INSTR        = 0;
                reset_wire          = 0;
                operacao            = 3'b001;
                WRITE_PC            = 1'b1;
                prox_estado         = load_reg;
            end
            
            espera:begin
                WRITE_INSTRUCTION   = 0;
                WR_MEM_INSTR        = 1'b1;
                reset_wire          = 0;
                operacao            = 0;
                WRITE_PC            = 0;
                prox_estado         = soma;
            end
           
           load_reg:begin
                WRITE_INSTRUCTION   = 0;
                WR_MEM_INSTR        = 1'b1;
                prox_estado         = espera;
                operacao            = 3'b000;
                reset_wire          = 0;
                WRITE_PC            = 0;
            end

        endcase
    end
endmodule