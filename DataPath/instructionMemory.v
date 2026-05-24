module instruction_memory (
    input      [31:0] pc,          // Endereço da instrução atual
    output     [31:0] instruction  // Instrução de 32 bits lida
);

    // Memória com 32 posições de 32 bits cada (32 instruções no máximo)
    reg [31:0] rom [0:31];

    initial begin
        // CORREÇÃO: Nome do arquivo corrigido para um padrão claro.
        // O arquivo deve ter uma instrução de 32 bits por linha, em binário.
        $readmemb("instrucoes.txt", rom);
    end

    // PC vem em bytes (0, 4, 8...), dividimos por 4 para acessar índice (0, 1, 2...)
    assign instruction = rom[pc >> 2];

endmodule
