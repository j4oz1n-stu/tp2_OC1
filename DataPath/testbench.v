

`timescale 1ns/1ps
`include "dataPath.v"

module testbench;

    reg clk;
    reg reset;

    // Clock com período de 10 ns (5 ns alto, 5 ns baixo)
    initial clk = 0;
    always #5 clk = ~clk;


    data_path dut (
        .clk  (clk),
        .reset(reset)
    );


    integer ciclo;
    integer i;

    initial begin
        reset = 1;
        @(posedge clk); // aguarda 1 ciclo com reset
        @(posedge clk);
        reset = 0;


        for (ciclo = 0; ciclo < 30; ciclo = ciclo + 1) begin
            @(posedge clk);

            // Mostra o PC a cada ciclo para acompanhar a execução
            $display("Ciclo %0d | PC = %0d | Instrução = %b",
                     ciclo,
                     dut.pc,
                     dut.instruction);
        end


        $display("");
        $display("============================================================");
        $display("           ESTADO FINAL DOS REGISTRADORES");
        $display("============================================================");

        for (i = 0; i < 32; i = i + 1) begin
            $display("Register [ %2d]:    %0d",
                     i,
                     dut.banco_de_registradores.regs[i]);
        end

        $display("============================================================");


        $display("");
        $display("============================================================");
        $display("           ESTADO DA MEMÓRIA DE DADOS (bytes 0-31)");
        $display("============================================================");

        for (i = 0; i < 32; i = i + 1) begin
            $display("Memoria [%3d]:    %0d",
                     i,
                     dut.memory_bank.memoria[i]);
        end

        $display("============================================================");
        $display("Simulação concluída.");

        $finish; // Encerra a simulação
    end


    initial begin
        $dumpfile("simulacao.vcd");
        $dumpvars(0, testbench);
    end

endmodule
