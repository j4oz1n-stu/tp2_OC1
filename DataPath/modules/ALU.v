module ALU (
    input      [31:0] read1,      // Operando 1 (sempre rs1)
    input      [31:0] read2_Imm,  // Operando 2 (rs2 ou imediato, já selecionado pelo mux)
    input      [3:0]  alucontrol, // Operação a executar
    output reg [31:0] alusaida,   // Resultado da operação
    output            zero        // 1 se alusaida == 0 (para beq)
);

    always @(*) begin
        casex (alucontrol)
            4'b0000: alusaida = read1 & read2_Imm;  // AND
            4'b0001: alusaida = read1 | read2_Imm;  // OR (ori)
            4'b0010: alusaida = read1 + read2_Imm;  // ADD (lb, sb — cálculo de endereço)
            4'b0110: alusaida = read1 - read2_Imm;  // SUB (sub, beq)
            4'b1000: alusaida = read1 >> read2_Imm; // SRL (shift right logical)
            default: alusaida = 32'b0;
        endcase
    end

    assign zero = (alusaida == 32'b0) ? 1'b1 : 1'b0;

endmodule
