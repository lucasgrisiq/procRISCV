module MAQUINA_DE_ESTADOS  (input CLK, 
                            input RST, 
                            input logic [31:0] INSTRUCAO,
                            input logic [6:0] op_code,
                            input logic ZERO_ALU,
                            input logic IGUAL_ALU,
                            input logic MENOR_ALU,
                            output logic SELETOR_ALU,
                            output logic WR_BANCO_REG,
                            output logic [1:0] SELECT_MUX_DATA,
                            output logic wrDataMemReg,
                            output logic WR_ALU_OUT,
                            output logic wrDataMem,
                            output logic reset_wire, 
                            output logic [2:0] operacao, 
                            output logic WRITE_PC,
                            output logic LOAD_IR, 
                            output logic WR_MEM_INSTR,
                            output logic [1:0] SELETOR_MUX_A,
                            output logic [2:0] SELETOR_MUX_B,
                            output logic write_reg_A,
                            output logic write_reg_B);
    
    enum bit [4:0] {reset, 
                    somaPC, 
                    espera, 
                    load_reg, 
                    load_AB, 
                    write_reg_alu, 
                    write_mem,
                    read_mem, 
                    write_reg_mux1,
                    pulaPC,
                    salva_reg,
                    wrt_reg_lui,
                    enrolaPC,
                    espera_2,
                    check_tipo,
                    wrt_1_reg,
                    wrt_0_reg,
                    write_mem_sw} Estado, prox_estado;

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
                if (INSTRUCAO[14:12] == 3'b001) tipoOP = tipoSB;
                else tipoOP = tipoI;
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
                SELETOR_ALU         = 1'b1;
                prox_estado         = espera;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0; 
            end

            somaPC:begin
                wrDataMemReg        = 1'b0;
                wrDataMem           = 1'b0;
                WR_BANCO_REG        = 1'b0;
                LOAD_IR             = 1'b1;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                operacao            = 3'b001;
                WRITE_PC            = 1'b1;
                WR_ALU_OUT          = 1'b0;
                SELETOR_MUX_A       = 2'b00;
                SELETOR_MUX_B       = 3'b001;
                prox_estado         = load_reg;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
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
                SELETOR_ALU         = 1'b1;
                prox_estado         = somaPC;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
            end
           
            espera_2:begin
                wrDataMemReg        = 1'b0;
                wrDataMem           = 1'b0;
                WR_BANCO_REG        = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                operacao            = 3'b000;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                SELETOR_ALU         = 1'b1;
                prox_estado         = read_mem;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
            end

            load_reg: begin
                wrDataMemReg        = 1'b0;
                wrDataMem           = 1'b0;
                WR_BANCO_REG        = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                WRITE_PC            = 1'b0;
                reset_wire          = 1'b0;
                operacao            = 3'b001;
                SELETOR_MUX_A       = 2'b00;
                SELETOR_MUX_B       = 3'b011;
                WR_ALU_OUT          = 1'b1;
                write_reg_A         = 1'b1;                 // só é 1 aq
                write_reg_B         = 1'b1;                 // so é 1 aq
                prox_estado         = check_tipo;
            end 

            check_tipo :begin
                wrDataMemReg        = 1'b0;
                wrDataMem           = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                operacao            = 3'b001;
                SELETOR_MUX_A       = 2'b00;
                SELETOR_MUX_B       = 3'b011;
                case(tipoOP)
                    tipoR: begin
                        prox_estado         = write_reg_alu;
                        SELETOR_MUX_A        = 2'b01;
                        SELETOR_MUX_B        = 2'b00;
                        WR_ALU_OUT          = 1'b1;
                        if(INSTRUCAO[31:25] == 7'b0000000) begin                            // add
                            if(INSTRUCAO[14:12] == 3'b000) operacao = 3'b001;
                            else if(INSTRUCAO[14:12] == 3'b111) operacao = 3'b011;          // and
                            else if(INSTRUCAO[14:12] == 3'b010) begin 
                                operacao = 3'b110;
                                if(MENOR_ALU) prox_estado = wrt_1_reg;
                                else prox_estado = wrt_0_reg;
                            end
                        end
                        else operacao       = 3'b010;                                       // sub
                        
                        WR_BANCO_REG        = 1'b1;
                        wrDataMemReg        = 1'b0;
                        write_reg_A         = 1'b0; 
                        write_reg_B         = 1'b0;
                    end

                    tipoI: begin
                        if (op_code == 7'b1100111)begin
                            //Operação == Jarl
                            // rd = PC
                            // PC = (rs1 + imm)*
                            operacao                = 3'b001;
                            SELETOR_MUX_A           = 2'b01;
                            SELETOR_MUX_B           = 3'b010;
                            WR_ALU_OUT              = 1'b1;

                        end

                        else begin
                            if(INSTRUCAO[14:12] == 3'b000) begin            // addi
                                operacao            = 3'b001;
                                SELETOR_MUX_A       = 2'b01;
                                SELETOR_MUX_B       = 3'b010;
                                WR_ALU_OUT          = 1'b1;
                                WR_BANCO_REG        = 1'b0;
                                wrDataMemReg        = 1'b0;
                                write_reg_A         = 0'b1; 
                                write_reg_B         = 0'b1;
                                prox_estado         = write_reg_alu;
                            end
                            else if(INSTRUCAO[14:12] == 3'b011) begin            // ld
                                operacao            = 3'b001;
                                SELETOR_MUX_A       = 2'b01;
                                SELETOR_MUX_B       = 3'b010;
                                WR_ALU_OUT          = 1'b1;
                                WR_BANCO_REG        = 1'b0;
                                wrDataMemReg        = 1'b0;
                                write_reg_A         = 0'b1; 
                                write_reg_B         = 0'b1;
                                prox_estado         = espera_2;
                            end
                        end
                        else if(INSTRUCAO[14:12] == 3'b010) begin           // slti
                            SELETOR_MUX_A        = 2'b01;
                            SELETOR_MUX_B        = 2'b10;
                            WR_ALU_OUT           = 1'b1;
                            operacao = 3'b110;
                            if(MENOR_ALU) prox_estado = wrt_1_reg;
                            else prox_estado = wrt_0_reg;
                            WR_BANCO_REG        = 1'b1;
                            wrDataMemReg        = 1'b0;
                            write_reg_A         = 1'b0; 
                            write_reg_B         = 1'b0;
                        end
                    end

                    tipoS: begin
                        if(INSTRUCAO[14:12] == 3'b111) begin            // sd
                            operacao            = 3'b001;
                            SELETOR_MUX_A       = 2'b01;
                            SELETOR_MUX_B       = 2'b10;
                            WR_ALU_OUT          = 1'b1;
                            WR_BANCO_REG        = 1'b0;
                            wrDataMemReg        = 1'b0;
                            write_reg_A         = 1'b0; 
                            write_reg_B         = 1'b0;
                            prox_estado         = write_mem;
                        end
                        else if(INSTRUCAO[14:12] == 3'b111) begin
                            operacao            = 3'b001;
                            SELETOR_MUX_A       = 2'b01;
                            SELETOR_MUX_B       = 2'b10;
                            WR_ALU_OUT          = 1'b1;
                            WR_BANCO_REG        = 1'b0;
                            wrDataMemReg        = 1'b0;
                            write_reg_A         = 1'b0; 
                            write_reg_B         = 1'b0;
                            prox_estado         = write_mem_sw;
                        end
                    end

                    tipoSB: begin
                        write_reg_A             = 1'b0; 
                        write_reg_B             = 1'b0;
                        if(INSTRUCAO[14:12] == 3'b000) begin            // beq
                            operacao            = 3'b010;
                            SELETOR_MUX_A       = 2'b01;
                            SELETOR_MUX_B       = 2'b00;
                            WR_ALU_OUT          = 1'b0;
                            if(ZERO_ALU) begin
                                SELETOR_ALU     = 1'b0;
                                WRITE_PC        = 1'b1;
                            end
                            else begin
                                SELETOR_ALU = 1'b1; // seletor ALU tem que ser 1 sempre
                            end
                                prox_estado     = espera;
                        end
                        else if (INSTRUCAO[14:12] == 3'b001) begin      // bne
                            operacao            = 3'b010;
                            SELETOR_MUX_A       = 2'b01;
                            SELETOR_MUX_B       = 2'b00;
                            WR_ALU_OUT          = 1'b0;
                            if(ZERO_ALU) begin
                                SELETOR_ALU = 1'b1;
                            end
                            else begin
                                SELETOR_ALU = 1'b0;
                                WRITE_PC        = 1'b1; 
                            end
                                prox_estado     = espera;
                        end
                    end

                    tipoU: begin
                        write_reg_A         = 1'b0; 
                        write_reg_B         = 1'b0;
                        wrDataMemReg        = 1'b0;
                        SELECT_MUX_DATA     = 2'b00;
                        WR_BANCO_REG        = 1'b0;
                        wrDataMem           = 1'b0;
                        LOAD_IR             = 1'b0;
                        WR_MEM_INSTR        = 1'b0;
                        reset_wire          = 1'b0;
                        WRITE_PC            = 1'b0;
                        WR_ALU_OUT          = 1'b1;
                        SELETOR_MUX_A       = 2'b11;
                        SELETOR_MUX_B       = 2'b10;
                        prox_estado         = wrt_reg_lui;
                    end
                endcase
            end

            wrt_reg_lui: begin
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 2'b00;
                WR_BANCO_REG        = 1'b1;
                wrDataMem           = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                SELETOR_MUX_A       = 2'b00;
                SELETOR_MUX_B       = 3'b011;
                write_reg_A         = 0'b1; 
                write_reg_B         = 0'b1;
                SELETOR_ALU         = 1'b1;
                prox_estado         = espera;
            end

            write_reg_alu: begin
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 2'b00;
                WR_BANCO_REG        = 1'b1;
                wrDataMem           = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
                SELETOR_ALU         = 1'b1;
                prox_estado         = espera;
            end

            wrt_0_reg: begin
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 2'b11;
                WR_BANCO_REG        = 1'b1;
                wrDataMem           = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
                SELETOR_ALU         = 1'b1;
                prox_estado         = espera;
            end

            wrt_1_reg: begin
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 2'b10;
                WR_BANCO_REG        = 1'b1;
                wrDataMem           = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
                SELETOR_ALU         = 1'b1;
                prox_estado         = espera;
            end


            read_mem: begin                             // ld passo 2
                wrDataMemReg        = 1'b1;
                SELECT_MUX_DATA     = 2'b00;
                WR_BANCO_REG        = 1'b0;
                wrDataMem           = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
                SELETOR_ALU         = 1'b1;
                prox_estado         = salva_reg;
            end

            salva_reg: begin
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 2'b01;
                WR_BANCO_REG        = 1'b1;
                wrDataMem           = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
                SELETOR_ALU         = 1'b1;
                prox_estado         = espera;
            end

            write_mem: begin                          // sd passo 2
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 2'b00;
                WR_BANCO_REG        = 1'b0;
                wrDataMem           = 1'b1;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
                SELETOR_ALU         = 1'b1;
                prox_estado         = espera;
            end

            write_mem_sw: begin
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 2'b00;
                WR_BANCO_REG        = 1'b0;
                wrDataMem           = 1'b1;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
                SELETOR_ALU         = 1'b1;
                prox_estado         = espera;
            end


        endcase
    end
endmodule