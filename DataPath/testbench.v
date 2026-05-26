// =============================================================================
// Testbench: RISC-V Grupo 4
//
// Programa de teste (4 instruções):
//   PC=0:  beq  x1, x0, -2    → x1≠0 → NÃO desvia, vai para PC=4
//   PC=4:  sub  x5, x5, x6    → x5 = x5 - x6
//   PC=8:  and  x7, x8, x9    → x7 = x8 & x9
//   PC=12: srl  x10, x11, x12 → x10 = x11 >> x12
//
// Para rodar: make sim
// =============================================================================

`timescale 1ns/1ps
`include "dataPath.v"

module testbench;

    reg clk;
    reg reset;

    // CORREÇÃO: reset já começa em 1 na declaração, antes de qualquer borda
    // de clock. Isso garante que o PC zera corretamente no primeiro ciclo.
    initial clk  = 0;
    initial reset = 1;          // <-- inicia em 1 direto, sem esperar clock

    always #5 clk = ~clk;

    data_path dut (
        .clk  (clk),
        .reset(reset)
    );

    integer i;

    initial begin
        // Aguarda a primeira borda para garantir que o PC síncrono vá para 0
        @(posedge clk); #1;
        
        // Libera o reset aqui! Assim, na próxima borda, o PC já poderá
        // calcular o next_pc (PC + 4) em vez de ficar preso em 0 de novo.
        reset = 0;              

        // Executa as instruções
        repeat(100) begin
            @(posedge clk); #1;
        end

        // Imprime os registradores
        for (i = 0; i < 32; i = i + 1)
            $display("Register [ %2d]:    %0d", i, dut.banco_de_registradores.regs[i]);
        $finish;
    end
    
endmodule