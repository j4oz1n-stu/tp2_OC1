module ImmGen(
    input [31:0] instruction,
    output reg [31:0] imm_extendido
);
//pegar o imediato na instrucao temos alguns tipos de instrucoes com imediato
//{lb,ori => tipo i} {sb => tipo s} {beq => tipo b}
always @(*)begin
case (instruction[6:0])
    //tipo b
    7'b1100011:begin 
        imm_extendido = {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0};
    end
    //tipo i
    7'b0000011,
    7'b0010011:begin
        imm_extendido = {{20{instruction[31]}},instruction[31:20]};
    end
    //tipo s
    7'b0100011:begin
        imm_extendido = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
    end
    default:begin
        imm_extendido = 32'b0;
    end
endcase
end
endmodule