
module Control(input [6:0] opcode);
    output branch, memread, memtoreg, [1:0]aluop, memwrite, alusrc, regwrite;
    case(opcode)//lembrar de mudar pra don't care
        7'b0000011: 
            branch = 1'b0;
            memread = 1'b1;
            memtoreg = 1'b1;
            aluop = 2'b00;
            memwrite = 1'b0;
            alusrc = 1'b1;
            regwrite = 1'b1;
        7'b0100011: 
            branch = 1'b0;
            memread = 1'b0;
            memtoreg = 1'bx;
            aluop = 2'b00;
            memwrite = 1'b1;
            alusrc = 1'b1;
            regwrite = 1'b0;
        7'b0110011: 
            branch = 1'b0;
            memread = 1'b0;
            memtoreg = 1'b0;
            aluop = 2'b10;
            memwrite = 1'b0;
            alusrc = 1'b0;
            regwrite = 1'b1;
        7'b0010011: 
            branch = 1'b0;
            memread = 1'b0;
            memtoreg = 1'b0;
            aluop = 2'b10;
            memwrite = 1'b0;
            alusrc = 1'b1;
            regwrite = 1'b1; 
        7'b1100011: 
            branch = 1'b1;
            memread = 1'b0;
            memtoreg = 1'bx;
            aluop = 2'b01;
            memwrite = 1'b0;
            alusrc = 1'b0;
            regwrite = 1'b0; 
    endcase
endmodule

module ALUControl(
input [14:12]funct3, funct7_b30, [1:0] aluop;
output [3:0] alucontrol;
);
    assign funct = {aluop,funct3,funct7_b30};
    always @(*) begin
        casex(funct)
            6'b00000x://mem
                alucontrol = 4'b0010;
            6'b100001: //sub
                alucontrol = 4'b0110;
            6'b101110: //and
                alucontrol = 4'b0000;
            6'b10110x: //ori
                alucontrol = 4'b0001;
            6'b101010: //srl
                alucontrol = 4'b1000;
            6'b01xxxx: //beq |sub
                alucontrol = 4'b0110;
            default:   
                alucontrol = 4'b0000;
        endcase
    end
endmodule