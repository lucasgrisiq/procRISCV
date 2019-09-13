module MAQUINA_DE_ESTADOS  (input CLK, 
                            input RST, 
                            input logic [6:0] op_code,
                            output logic reset_wire, 
                            output logic [2:0] operacao, 
                            output logic WRITE_PC,
                            output logic LOAD_IR, 
                            output logic WR_MEM_INSTR,
                            output logic SELECT_MUX_A,
                            output logic [1:0] SELECT_MUX_B);
    
    enum bit [2:0] {reset, somaPC, espera, load_reg} estado, prox_estado;
    enum bit [2:0] {tipoR, tipoI, tipoS, tipoSB, tipoU, tipoUJ} tipoOP;

    always_ff @(posedge CLK, posedge RST) begin
        if(RST) estado  <= reset;
        else estado     <= prox_estado;
    end
    
    
    always_comb begin
        case(op_code) begin
            7'b0110011: begin                                       // tipo R
                tipoOP = tipoR;
            end

            7'b0010011: begin                                       //tipo I
                tipoOP = tipoI;
            end                                          
            7'b1100111: begin
                tipoOP = tipoI;
            end                            
            7'b0000011: begin
                tipoOP = tipoI;
            end 
            7'b1110011: begin
                tipoOP = tipoI;
            end
            7'b0100011: begin                                      // tipo S
                tipoOP = tipoS;
            end 

            7'b1100011: begin                                      // tipo SB
                tipoOP = tipoSB;
            end                                           
            7'b1100111: begin                       
                tipoOP = tipoSB;
            end

            7'b0110111: begin                                      // tipo U
                tipoOP = tipoU;
            end

            7'b1101111: begin                                      // tipo UJ
                tipoOP = tipoUJ;
            end
        end
        case(estado)
            reset:begin
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b1;
                operacao            = 3'b000;
                WRITE_PC            = 1'b0;
                prox_estado         = espera;
            end

            somaPC:begin
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                operacao            = 3'b001;
                WRITE_PC            = 1'b1;
                prox_estado         = load_reg;
            end
            
            espera:begin
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                operacao            = 3'b000;
                WRITE_PC            = 1'b0;
                prox_estado         = somaPC;
            end
           
           load_reg:begin
                LOAD_IR             = 1'b1;
                WR_MEM_INSTR        = 1'b0;
                prox_estado         = espera;
                operacao            = 3'b000;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
            end

        endcase
    end
endmodule