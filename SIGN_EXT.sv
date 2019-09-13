module SIGN_EXT (input logic [31:0] ENTRADA
                 output logic [63:0] SAIDA);

    enum bit [2:0] {tipoI, tipoS, tipoSB, tipoU, tipoUJ} tipo;
    logic [6:0] op_code;

    
    always_comb begin
        op_code = ENTRADA[6:0];
        
        case (op_code) begin
            7'b0010011: begin tipo = tipoI; end
            7'b1100111: begin tipo = tipoI; end
            7'b0000011: begin tipo = tipoI; end
            7'b1110011: begin tipo = tipoI; end
            7'b0100011: begin tipo = tipoS; end
            7'b1100011: begin tipo = tipoSB; end
            7'b1100111: begin tipo = tipoSB; end
            7'b0110111: begin tipo = tipoU; end
            7'b1101111: begin tipo = tipoUJ; end
        end

        case (tipo)
            
            tipoI: begin
                SAIDA[11:0] = ENTRADA[31:20];
                if (ENTRADA[31] == 1) SAIDA[63:12] = 1;
                else SAIDA[63:12] = 0;
            end

            tipoS: begin
                SAIDA[4:0] = ENTRADA[11:7];
                SAIDA[11:5] = ENTRADA[31:25];
                if (ENTRADA[31] == 1) SAIDA[63:12] = 1;
                else SAIDA[63:12] = 0;
            end
            
            tipoSB: begin
                SAIDA[4:1] = ENTRADA[11:8];
                SAIDA[0] = 0;
                SAIDA[11] = ENTRADA[7];
                SAIDA[12] = ENTRADA[31];
                SAIDA[10:5] = ENTRADA[31:25];
                if (ENTRADA[31] == 1) SAIDA[63:13] = 1;
                else SAIDA[63:13] = 0;
            end
            
            tipoUJ: begin
                SAIDA[20] = ENTRADA[31];
                SAIDA[10:1] = ENTRADA[30:21];
                SAIDA[11] = ENTRADA[20];
                SAIDA[19:12] = ENTRADA[19:12];
                SAIDA[0] = 0;
                if (ENTRADA[31] == 1) SAIDA[63:21] = 1;
                else SAIDA[63:21] = 0;
            end
            
            tipoU: begin
                SAIDA[31:12] = ENTRADA[31:12];
                SAIDA[11:0] = 0;
                if (ENTRADA[31] == 1) SAIDA[63:32] = 1;
                else SAIDA[63:32] = 0;
            end
    end


endmodule