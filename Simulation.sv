`timescale 1ps/1ps
module Simulation;
    localparam CLK = 100;
    localparam PERIODO = CLK/2;
    logic clock;
    logic reset;

    UP processing(.CLK(clock), .RST(reset));
    
    initial begin
        clock = 1'b1;
        reset = 1'b1;
        #CLK
        #CLK
        reset = 1'b0;   
    end

    always #(PERIODO)
    clock = ~clock;

endmodule