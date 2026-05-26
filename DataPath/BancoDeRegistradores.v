module BancoReg (
    input             clk, 
    input             reset,       
    input             regwrite,  
    input      [4:0]  rs1,       
    input      [4:0]  rs2,       
    input      [4:0]  rd,        
    input      [31:0] write_data,
    output reg [31:0] read1,     
    output reg [31:0] read2      
);
 
    reg [31:0] regs [0:31]; // 32 registradores de 32 bits
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
        $readmemb("memorias/registradores.txt", regs);
        // Garante que x0 sempre vale 0
        regs[0] = 32'b0;
    end
 
    always @(*) begin
        read1 = (rs1 == 5'b0) ? 32'b0 : regs[rs1]; // x0 sempre retorna 0
        read2 = (rs2 == 5'b0) ? 32'b0 : regs[rs2];
    end

    always @(posedge clk) begin
        if (!reset && regwrite && (rd != 5'b0)) // Nunca escreve em x0
            regs[rd] <= write_data;
    end
 
endmodule