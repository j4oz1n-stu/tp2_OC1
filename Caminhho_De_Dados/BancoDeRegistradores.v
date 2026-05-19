module BancoReg(
input clk,
input regwrite, memtoreg,
input [4:0] rs1,[4:0] rs2,[4:0] rd,
input [31:0] write_data, //isso aqui e a saida de algum multiplexador
output reg [31:0] read1,[31:0] read2
);

reg [7:0] regs [0:127]; //0 primeiro pra ficar em ordem de leitura de vetor
initial begin 
    $readmemb("memoria.txt",regs);
end
always @(*)begin
    read1 = {regs[rs1*4+3],regs[rs1*4+2],regs[rs1*4+1],regs[rs1*4]};
    read2 = {regs[rs2*4+3],regs[rs2*4+2],regs[rs2*4+1],regs[rs2*4]};
end
always @(posedge clk)begin
    if(regwrite && rd != 0)begin //se mandou escrever no registrador e o registrador nao e 0 (constante)
            regs[rd*4]   <= write_data[7:0];
            regs[rd*4+1] <= write_data[15:8];
            regs[rd*4+2] <= write_data[23:16];
            regs[rd*4+3] <= write_data[31:24];
    end
end

endmodule