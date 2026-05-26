module mem (
    input             clk,          // Clock
    input             memread,      // 1 = lê da memória (lb)
    input             memwrite,     // 1 = escreve na memória (sb)
    input      [31:0] alu_resultado, // Endereço calculado pela ALU
    input      [31:0] write_data,   // Dado a ser escrito (usamos só [7:0])
    output reg [31:0] mem_read      // Dado lido (byte com extensão de sinal)
);

    reg [7:0] memoria [0:127]; // Memória byte a byte, 128 posições

    integer i;
    initial begin
        $readmemb("memorias/memoria.txt", memoria);
    end

    always @(*) begin
        if (memread)
            // Extensão de sinal: replica o bit 7 (MSB do byte) nos 24 bits superiores
            mem_read = {{24{memoria[alu_resultado[6:0]][7]}}, memoria[alu_resultado[6:0]]};
        else
            mem_read = 32'b0;
    end

    always @(posedge clk) begin
        if (memwrite)
            memoria[alu_resultado[6:0]] <= write_data[7:0];
    end

endmodule
