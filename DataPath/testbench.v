`timescale 1ns/1ps
`include "dataPath.v"

module testbench;

    reg clk;
    reg reset;

    initial clk  = 0;
    initial reset = 1;      

    always #5 clk = ~clk;

    data_path dut (
        .clk  (clk),
        .reset(reset)
    );

    integer i;

    initial begin
        @(posedge clk); #1;
        
        reset = 0;              

        repeat(100) begin
            @(posedge clk); #1;
        end

        for (i = 0; i < 32; i = i + 1)
            $display("Register [ %2d]:    %0d", i, dut.banco_de_registradores.regs[i]);
        $finish;
    end
    
endmodule