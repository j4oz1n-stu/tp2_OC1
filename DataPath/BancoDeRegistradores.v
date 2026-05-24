module BancoReg (
    input             clk,        // Clock
    input             regwrite,   // Habilitação de escrita (1 = escreve em rd)
    input      [4:0]  rs1,        // Índice do registrador fonte 1
    input      [4:0]  rs2,        // Índice do registrador fonte 2
    input      [4:0]  rd,         // Índice do registrador destino
    input      [31:0] write_data, // Dado a ser escrito em rd
    output reg [31:0] read1,      // Valor lido de rs1
    output reg [31:0] read2       // Valor lido de rs2
);


    reg [31:0] regs [0:31]; // 32 registradores de 32 bits

    integer i;
    initial begin
        // Inicializa todos os registradores com zero
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
        // Se quiser pré-carregar valores (ex: para testes sem ADDI),
        // descomente a linha abaixo e crie o arquivo:
        // $readmemh("registradores.txt", regs);
    end

    // Leitura combinacional (sem clock) — qualquer mudança em rs1/rs2
    // reflete imediatamente na saída
    always @(*) begin
        read1 = (rs1 == 5'b0) ? 32'b0 : regs[rs1]; // x0 sempre retorna 0
        read2 = (rs2 == 5'b0) ? 32'b0 : regs[rs2];
    end

    // Escrita síncrona na borda de subida do clock
    always @(posedge clk) begin
        if (regwrite && rd != 5'b0) begin // Nunca escreve em x0
            regs[rd] <= write_data;
        end
    end

endmodule
