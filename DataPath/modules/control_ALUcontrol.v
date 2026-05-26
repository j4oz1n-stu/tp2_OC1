module Control (
    input [6:0] opcode,  
    output reg branch,   
    output reg memread,  
    output reg memtoreg, 
    output reg memwrite, 
    output reg alusrc,   
    output reg regwrite,
    output reg [1:0] aluop     
);

    always @(*) begin
        case (opcode)

            // lb: tipo I
            7'b0000011: begin
                branch   = 1'b0;
                memread  = 1'b1; 
                memtoreg = 1'b1; 
                aluop    = 2'b00; 
                memwrite = 1'b0;
                alusrc   = 1'b1; 
                regwrite = 1'b1; 
            end

            // sb: tipo S
            7'b0100011: begin
                branch   = 1'b0;
                memread  = 1'b0;
                memtoreg = 1'b0;
                aluop    = 2'b00;
                memwrite = 1'b1; 
                alusrc   = 1'b1; 
                regwrite = 1'b0; 
            end

            // Tipo R: sub, and, srl
            7'b0110011: begin
                branch   = 1'b0;
                memread  = 1'b0;
                memtoreg = 1'b0; 
                aluop    = 2'b10;
                memwrite = 1'b0;
                alusrc   = 1'b0; 
                regwrite = 1'b1; 
            end

            // Tipo I com imediato: ori
            7'b0010011: begin
                branch   = 1'b0;
                memread  = 1'b0;
                memtoreg = 1'b0;
                aluop    = 2'b10; 
                memwrite = 1'b0;
                alusrc   = 1'b1; 
                regwrite = 1'b1;
            end

            // beq: tipo B
            7'b1100011: begin
                branch   = 1'b1;
                memread  = 1'b0;
                memtoreg = 1'b0; 
                aluop    = 2'b01; 
                memwrite = 1'b0;
                alusrc   = 1'b0; 
                regwrite = 1'b0;
            end

            // Default: NOP
            default: begin
                branch   = 1'b0;
                memread  = 1'b0;
                memtoreg = 1'b0;
                aluop    = 2'b00;
                memwrite = 1'b0;
                alusrc   = 1'b0;
                regwrite = 1'b0;
            end

        endcase
    end

endmodule


// ========================
// Tabela de alucontrol:
//   0000= and
//   0001= or 
//   0010= add 
//   0110= sub 
//   1000= srl 
// ========================
module ALUControl (
    input [2:0] funct3,
    input funct7_b30, 
    input [1:0] aluop, 
    output reg [3:0] alucontrol 
);

    //concatenamos aluop, funct3 e o bit30 da funct7
    wire [5:0] funct;
    assign funct = {aluop, funct3, funct7_b30};


    always @(*) begin
        casex (funct)
            // aluop=00 memória, ALU soma endereço
            6'b00xxxx: alucontrol = 4'b0010;

            // aluop=01 beq: ALU subtrai e compara
            6'b01xxxx: alucontrol = 4'b0110; 

            // sub: funct3=000, funct7[30]=1
            6'b10_000_1: alucontrol = 4'b0110; 

            // and: funct3=111, funct7[30]=0
            6'b10_111_0: alucontrol = 4'b0000; 

            // ori: funct3=110 funct7[30]=x
            6'b10_110_x: alucontrol = 4'b0001; 

            // srl: funct3=101, funct7[30]=0
            6'b10_101_0: alucontrol = 4'b1000; 

            default:    alucontrol = 4'b0010; //add
        endcase
    end

endmodule
