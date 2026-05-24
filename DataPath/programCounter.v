module program_counter (
    input             clk,      // Clock do processador
    input             reset,    // Reset síncrono (1 = volta para endereço 0)
    input      [31:0] next_pc,  // Próximo valor do PC (calculado no datapath)
    output reg [31:0] pc        // Endereço atual sendo executado
);

    always @(posedge clk) begin
        if (reset)
            pc <= 32'b0;       // Volta ao início do programa
        else
            pc <= next_pc;     // Avança para a próxima instrução
    end

endmodule
