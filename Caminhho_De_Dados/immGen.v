module ImmGen(
    input clk,
    input [11:0] imm,
    output [31:0] imm_extendido
);
always @(posedge clk)begin
    if(imm[1]== 1'b1)begin
        imm_extendido = {20'h1111, imm};
    end 
    else begin
        imm_extendido = {20'h0000, imm};
    end
end
endmodule