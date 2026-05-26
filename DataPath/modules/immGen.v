module ImmGen (
    input      [31:0] instruction,   // Instrução completa de 32 bits
    output reg [31:0] imm_extendido  // Imediato com extensão de sinal (32 bits)
);

    always @(*) begin
        case (instruction[6:0])

            // Tipo B: beq 
            // Imediato = [31][7][30:25][11:8],
            7'b1100011: begin
                imm_extendido = {{20{instruction[31]}},
                                  instruction[7],
                                  instruction[30:25],
                                  instruction[11:8],
                                  1'b0};
            end

            // Tipo I: lb e ori
            // Imediato = [31:20]
            7'b0000011,
            7'b0010011: begin
                imm_extendido = {{20{instruction[31]}}, instruction[31:20]};
            end

            // Tipo S: sb
            // Imediato = [31:25] e [11:7]
            7'b0100011: begin
                imm_extendido = {{20{instruction[31]}},
                                  instruction[31:25],
                                  instruction[11:7]};
            end

            // instruções sem imediato (tipo R: sub, and, srl)
            default: begin
                imm_extendido = 32'b0;
            end

        endcase
    end

endmodule
