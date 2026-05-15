module instruction_memory (
    input  [31:0] pc, 
    output [31:0] instruction
);
    // Agora a memória tem 32 bits de largura (31:0)
    // E vamos definir, por exemplo, 32 posições de profundidade [0:31]
    reg [31:0] rom [31:0];

    initial begin
        // O arquivo "nome.txt" deve ter uma instrução de 32 bits por linha
        $readmemb("nome.txt", rom);
    end

    // Se o seu PC pula de 4 em 4, você deve usar pc[31:2] para acessar o índice 0, 1, 2...
    assign instruction = rom[pc >> 2]; 
endmodule

//retirar
module instruction_memory_paia(input [31:0] pc, output [31:0] instruction);
    reg [7:0] rom [127:0];
    initial begin
        $readmemb("nome.txt",rom);
    end
    assign instruction = {rom[pc], rom[pc+1], rom[pc+2], rom[pc+3]};
endmodule
