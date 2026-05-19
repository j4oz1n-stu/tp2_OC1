module ImmGen(
    input [31:0] instruction,
    output [31:0] imm_extendido
);
assign imm_extendido = {{20{imm[11]}}, imm};
endmodule