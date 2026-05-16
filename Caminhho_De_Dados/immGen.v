module ImmGen(
    input clk,
    input [11:0] imm,
    output [31:0] imm_extendido
);
assign imm_extendido = {{20{imm[11]}}, imm};
endmodule