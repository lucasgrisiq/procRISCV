module MAQUINA_DE_ESTADOS  (input CLK, 
                            input RST, 
                            input logic [31:0] INSTRUCAO,
                            input logic [6:0] op_code,
                            output logic WR_BANCO_REG,
                            output logic SELECT_MUX_DATA,
                            output logic wrDataMemReg,
                            output logic WR_ALU_OUT,
                            output logic wrDataMem,
                            output logic reset_wire, 
                            output logic [2:0] operacao, 
                            output logic WRITE_PC,
                            output logic LOAD_IR, 
                            output logic WR_MEM_INSTR,
                            output logic SELETOR_MUX_A,
                            output logic [1:0] SELETOR_MUX_B);
    
    enum bit [4:0] {reset, somaPC, espera, load_reg, load_AB, add, sub, write_reg_alu, load_addi} Estado, prox_estado;
    enum bit [2:0] {tipoR, tipoI, tipoS, tipoSB, tipoU, tipoUJ} tipoOP;

    always_ff @(posedge CLK, posedge RST) begin
        if(RST) Estado  <= reset;
        else Estado     <= prox_estado;
    end
    
    
    always_comb begin
        case(op_code) 
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
        endcase
        case(Estado)
            reset:begin
                wrDataMemReg        = 1'b0;
                wrDataMem           = 1'b0;
                WR_BANCO_REG        = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b1;
                operacao            = 3'b000;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                prox_estado         = espera;
            end

            somaPC:begin
                wrDataMemReg        = 1'b0;
                wrDataMem           = 1'b0;
                WR_BANCO_REG        = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                operacao            = 3'b001;
                WRITE_PC            = 1'b1;
                WR_ALU_OUT          = 1'b0;
                SELETOR_MUX_A        = 1'b0;
                SELETOR_MUX_B        = 2'b01;
                prox_estado         = load_reg;
            end
            
            espera:begin
                wrDataMemReg        = 1'b0;
                wrDataMem           = 1'b0;
                WR_BANCO_REG        = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                operacao            = 3'b000;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                prox_estado         = somaPC;
            end
           
           load_reg:begin
                wrDataMemReg        = 1'b0;
                wrDataMem           = 1'b0;
                WR_BANCO_REG        = 1'b0;
                LOAD_IR             = 1'b1;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                case(tipoOP)
                    tipoR: begin
                        SELETOR_MUX_A        = 1'b1;
                        SELETOR_MUX_B        = 2'b00;
                        WR_ALU_OUT          = 1'b1;
                        if(INSTRUCAO[31:25] == 7'b0000000) begin
                            if(INSTRUCAO[14:12] == 3'b000) operacao = 3'b001;
                        end
                        else operacao       = 3'b010;
                        prox_estado         = write_reg_alu;
                    end
                    tipoI: begin
                        
                        operacao            = 3'b001;
                        SELETOR_MUX_A       = 1'b1;
                        SELETOR_MUX_B       = 2'b10;
                        WR_ALU_OUT          = 1'b1;
                        prox_estado         = write_reg_alu;
                    end
                endcase
            end

            write_reg_alu: begin
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 1'b0;
                WR_BANCO_REG        = 1'b1;
                wrDataMem           = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                prox_estado         = somaPC;
            end


        endcase
    end
endmodule