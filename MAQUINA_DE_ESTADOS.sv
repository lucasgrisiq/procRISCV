module MAQUINA_DE_ESTADOS  (input CLK, 
                            input RST, 
                            input logic [31:0] INSTRUCAO,
                            input logic [6:0] op_code,
                            input logic ZERO_ALU,
                            input logic IGUAL_ALU,
                            input logic MENOR_ALU,
                            output logic SELETOR_ALU,
                            output logic WR_BANCO_REG,
                            output logic [3:0] SELECT_MUX_DATA,
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
    
    enum bit [4:0] {reset,                          // Valores que Estado e prox_estado podem receber
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
                    write_mem_sw,
                    recebe_pc_wrt_pc} Estado, prox_estado;

    enum bit [2:0] {tipoR, tipoI, tipoS, tipoSB, tipoU, tipoUJ} tipoOP;

    enum bit [2:0] {ld, lb, lh, lw, lbu, lhu, lwu} tipoLoad;

    always_ff @(posedge CLK, posedge RST) begin
        if(RST) Estado  <= reset;
        else Estado     <= prox_estado;
    end
    
    
    always_comb begin
        case(op_code) 
            7'b0110011: begin                        // Instruções do Tipo R
                tipoOP = tipoR;
                 
            end

            7'b0010011: begin                        //tipo I
                tipoOP = tipoI;
            end                                          

            7'b0000011: begin
                tipoOP = tipoI;
                if(INSTRUCAO[14:12] == 3'b011) tipoLoad = ld;
                else if(INSTRUCAO[14:12] == 3'b000) tipoLoad = lb;
                else if(INSTRUCAO[14:12] == 3'b001) tipoLoad = lh;
                else if(INSTRUCAO[14:12] == 3'b010) tipoLoad = lw;
                else if(INSTRUCAO[14:12] == 3'b100) tipoLoad = lbu;
                else if(INSTRUCAO[14:12] == 3'b101) tipoLoad = lhu;
                else if(INSTRUCAO[14:12] == 3'b110) tipoLoad = lwu;
            end 
            7'b1110011: begin
                tipoOP = tipoI;
            end
            7'b0100011: begin                        // tipo S
                tipoOP = tipoS;
            end 

            7'b1100011: begin                        // tipo SB
                tipoOP = tipoSB;
            end                                           
            7'b1100111: begin       
                if (INSTRUCAO[14:12] == 3'b001) tipoOP = tipoSB;
                else tipoOP = tipoI;
            end

            7'b0110111: begin                        // tipo U
                tipoOP = tipoU;
            end

            7'b1101111: begin                        // tipo UJ
                tipoOP = tipoUJ;
            end
        endcase

        case(Estado)
            reset:begin
                wrDataMemReg        = 1'b0;         // Escrever no registrador de memória
                wrDataMem           = 1'b0;         // Escrever na memória
                WR_BANCO_REG        = 1'b0;         // Escrever no banco de registradores
                LOAD_IR             = 1'b0;         // Ler instrução da memória
                WR_MEM_INSTR        = 1'b0;         // Escrever instrução na memória
                reset_wire          = 1'b1;         // Resetar
                operacao            = 3'b000;       // Operação == não fazer nada
                WRITE_PC            = 1'b0;         // Atualizar PC (Reescrever o PC)
                WR_ALU_OUT          = 1'b0;         // Escrever na Alu_out
                SELETOR_ALU         = 1'b1;         // Selecionar entre Alu_out e PC+4
                prox_estado         = espera;       // Qual o próximo estado a ser executado no próximo clock
                write_reg_A         = 1'b0;         // Escrever no registrador A
                write_reg_B         = 1'b0;         // ******                  B
            end

            somaPC:begin
                wrDataMemReg        = 1'b0;         // Escrever no registrador de memória
                wrDataMem           = 1'b0;         // Escrever na memória
                WR_BANCO_REG        = 1'b0;         // Escrever no banco de registradores
                LOAD_IR             = 1'b1;         // Ler instrução da memória
                WR_MEM_INSTR        = 1'b0;         // Escrever instrução na memória
                reset_wire          = 1'b0;         // Resetar
                operacao            = 3'b001;       // Operação == soma
                WRITE_PC            = 1'b1;         // Atualizar PC (Reescrever o PC)
                WR_ALU_OUT          = 1'b0;         // Escrever na Alu_Out
                SELETOR_MUX_A       = 2'b00;        // Seletor de valor do MUX_A
                SELETOR_MUX_B       = 3'b001;       // Seletor de valor do MUX_B
                prox_estado         = load_reg;
                write_reg_A         = 1'b0;         // Escrever no Registrador A
                write_reg_B         = 1'b0;         // Escrever no registrador B
            end
            
            espera:begin
                wrDataMemReg        = 1'b0;         // Escrever no registrador de memória
                wrDataMem           = 1'b0;         // Escrever na memória
                WR_BANCO_REG        = 1'b0;         // Escrever no banco de registradores
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
                        SELETOR_MUX_B        = 3'b000;
                        WR_ALU_OUT          = 1'b1;
                        if(INSTRUCAO[31:25] == 7'b0000000) begin                            
                            if(INSTRUCAO[14:12] == 3'b000) operacao = 3'b001;               // add
                            else if(INSTRUCAO[14:12] == 3'b111) operacao = 3'b011;          // and
                            else if(INSTRUCAO[14:12] == 3'b010) begin 
                                operacao = 3'b110;                                          // slt
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
                        if (op_code == 7'b1100111)begin                                     // jarl
                            // rd = PC
                            // PC = (rs1 + imm)*
                            operacao                = 3'b001; // Operação de soma
                            SELETOR_MUX_A           = 2'b01;  // Valor de A
                            SELETOR_MUX_B           = 3'b010; // Saída extendida
                            WR_ALU_OUT              = 1'b1;   // Flag pra escrever na alu_Out
                            prox_estado             = recebe_pc_wrt_pc;
                        end

                        else if(INSTRUCAO[14:12] == 3'b010) begin           // slti
                            SELETOR_MUX_A        = 2'b01;
                            SELETOR_MUX_B        = 3'b010;
                            WR_ALU_OUT           = 1'b1;
                            operacao = 3'b110;
                            if(MENOR_ALU) prox_estado = wrt_1_reg;
                            else prox_estado = wrt_0_reg;
                            WR_BANCO_REG        = 1'b1;
                            wrDataMemReg        = 1'b0;
                            write_reg_A         = 1'b0; 
                            write_reg_B         = 1'b0;
                        end

                        else begin
                            if(INSTRUCAO[14:12] == 3'b000 && op_code == 7'b0010011) begin            // addi
                            // addi = rs1 + imm
                            //
                                operacao            = 3'b001;
                                SELETOR_MUX_A       = 2'b01;
                                SELETOR_MUX_B       = 3'b010;
                                WR_ALU_OUT          = 1'b1;
                                WR_BANCO_REG        = 1'b0;
                                wrDataMemReg        = 1'b0;
                                write_reg_A         = 1'b0; 
                                write_reg_B         = 1'b0;
                                prox_estado         = write_reg_alu;
                            end
                            else if(INSTRUCAO[14:12] == 3'b011                              // ld
                                 || INSTRUCAO[14:12] == 3'b000 && op_code == 7'b0000011     // lb
                                 || INSTRUCAO[14:12] == 3'b001 && op_code == 7'b0000011     // lh
                                 || INSTRUCAO[14:12] == 3'b010 && op_code == 7'b0000011     // lw
                                 || INSTRUCAO[14:12] == 3'b100 && op_code == 7'b0000011     // lbu
                                 || INSTRUCAO[14:12] == 3'b101 && op_code == 7'b0000011     // lhu
                                 || INSTRUCAO[14:12] == 3'b110 && op_code == 7'b0000011     // lwu
                                ) begin            
                                operacao            = 3'b001;
                                SELETOR_MUX_A       = 2'b01;
                                SELETOR_MUX_B       = 3'b010;
                                WR_ALU_OUT          = 1'b1;
                                WR_BANCO_REG        = 1'b0;
                                wrDataMemReg        = 1'b0;
                                write_reg_A         = 1'b0; 
                                write_reg_B         = 1'b0;
                                prox_estado         = espera_2;
                            end
                            else if(INSTRUCAO[14:12] == 3'b000 && op_code == 7'b0000011) begin  
                                operacao            = 3'b001;
                                SELETOR_MUX_A       = 2'b01;
                                SELETOR_MUX_B       = 3'b010;
                                WR_ALU_OUT          = 1'b1;
                                WR_BANCO_REG        = 1'b0;
                                wrDataMemReg        = 1'b0;
                                write_reg_A         = 1'b0; 
                                write_reg_B         = 1'b0;
                                prox_estado         = espera_2;
                            end
                        end
                        
                    end

                    tipoS: begin
                        if(INSTRUCAO[14:12] == 3'b111) begin            // sd
                            operacao            = 3'b001;
                            SELETOR_MUX_A       = 2'b01;
                            SELETOR_MUX_B       = 3'b010;
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
                            SELETOR_MUX_B       = 3'b010;
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
                            SELETOR_MUX_B       = 3'b000;
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
                            SELETOR_MUX_B       = 3'b000;
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
                        SELECT_MUX_DATA     = 4'b0000;
                        WR_BANCO_REG        = 1'b0;
                        wrDataMem           = 1'b0;
                        LOAD_IR             = 1'b0;
                        WR_MEM_INSTR        = 1'b0;
                        reset_wire          = 1'b0;
                        WRITE_PC            = 1'b0;
                        WR_ALU_OUT          = 1'b1;
                        SELETOR_MUX_A       = 2'b11;
                        SELETOR_MUX_B       = 3'b010;
                        prox_estado         = wrt_reg_lui;
                    end
                endcase
            end

            recebe_pc_wrt_pc: begin                     // rd = PC; PC = AluOut
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 4'b0100;
                WR_BANCO_REG        = 1'b1;
                wrDataMem           = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b1;
                WR_ALU_OUT          = 1'b0;
                SELETOR_MUX_A       = 2'b00;
                SELETOR_MUX_B       = 3'b000;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
                SELETOR_ALU         = 1'b0;
                prox_estado         = espera;
            end

            wrt_reg_lui: begin
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 4'b0000;
                WR_BANCO_REG        = 1'b1;
                wrDataMem           = 1'b0;
                LOAD_IR             = 1'b0;
                WR_MEM_INSTR        = 1'b0;
                reset_wire          = 1'b0;
                WRITE_PC            = 1'b0;
                WR_ALU_OUT          = 1'b0;
                SELETOR_MUX_A       = 2'b00;
                SELETOR_MUX_B       = 3'b011;
                write_reg_A         = 1'b0; 
                write_reg_B         = 1'b0;
                SELETOR_ALU         = 1'b1;
                prox_estado         = espera;
            end

            write_reg_alu: begin
                wrDataMemReg        = 1'b0;
                SELECT_MUX_DATA     = 4'b0000;
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
                SELECT_MUX_DATA     = 4'b0011;
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
                SELECT_MUX_DATA     = 4'b0010;
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
                SELECT_MUX_DATA     = 4'b0000;
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
                case (tipoLoad)
                    ld: SELECT_MUX_DATA = 4'b0101;
                    lb: SELECT_MUX_DATA = 4'b0110;
                    lh: SELECT_MUX_DATA = 4'b0111;
                    lw: SELECT_MUX_DATA = 4'b1000;
                    lbu: SELECT_MUX_DATA = 4'b1001;
                    lhu: SELECT_MUX_DATA = 4'b1010;
                    lwu: SELECT_MUX_DATA = 4'b1011;
                endcase
                wrDataMemReg        = 1'b0;
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
                SELECT_MUX_DATA     = 4'b0000;
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
                SELECT_MUX_DATA     = 4'b0000;
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