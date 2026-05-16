module mem(
    input clk,
    input memread, memwrite,
    input [31:0] alu_resultado,
    input [31:0] write_data,
    output reg [31:0] mem_read
);
reg [7:0] memoria [0:127];//nao sei direito o tamanho da memoria
initial begin
 $readmemb("memoria.txt",memoria);
end
always @(*)begin
if(memread)begin
    mem_read = {{24{memoria[alu_resultado][7]}}, memoria[alu_resultado]};//porque eh o byte em 32 bits
end else begin
        mem_read = 32'b0;
    end
end
always @(posedge clk) begin
    if(memwrite)begin
        memoria[alu_resultado] <= write_data[7:0];
    end
end
endmodule
//lembrar que a funcao e lb e sb