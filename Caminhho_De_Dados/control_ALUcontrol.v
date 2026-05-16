
module Control(input [6:0] opcode,
    output reg branch, memread, memtoreg, memwrite, alusrc, regwrite,
    output reg [1:0]aluop
    );
    always @(*)begin
    casex(opcode)//lembrar de mudar pra don't care
        7'b0000011: begin
            branch = 1'b0;
            memread = 1'b1;
            memtoreg = 1'b1;
            aluop = 2'b00;
            memwrite = 1'b0;
            alusrc = 1'b1;
            regwrite = 1'b1;
        end
        7'b0100011: begin
            branch = 1'b0;
            memread = 1'b0;
            memtoreg = 1'b1;
            aluop = 2'b00;
            memwrite = 1'b1;
            alusrc = 1'b1;
            regwrite = 1'b0;
        end
        7'b0110011: begin
            branch = 1'b0;
            memread = 1'b0;
            memtoreg = 1'b0;
            aluop = 2'b10;
            memwrite = 1'b0;
            alusrc = 1'b0;
            regwrite = 1'b1;
        end
        7'b0010011: begin
            branch = 1'b0;
            memread = 1'b0;
            memtoreg = 1'b0;
            aluop = 2'b10;
            memwrite = 1'b0;
            alusrc = 1'b1;
            regwrite = 1'b1; 
        end
        7'b1100011: begin
            branch = 1'b1;
            memread = 1'b0;
            memtoreg = 1'b1;
            aluop = 2'b01;
            memwrite = 1'b0;
            alusrc = 1'b0;
            regwrite = 1'b0; 
        end
        default: begin //bolha
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

module ALUControl(
input [14:12]funct3, funct7_b30, [1:0] aluop;
output [3:0] alucontrol;
);
    assign funct = {aluop,funct3,funct7_b30};
    always @(*) begin
        casex(funct)
            6'b00000x: begin//mem
                alucontrol = 4'b0010;
            end
            6'b100001: begin//sub
                alucontrol = 4'b0110;
            end
            6'b101110: begin//and
                alucontrol = 4'b0000;
            end
            6'b10110x: begin//ori
                alucontrol = 4'b0001;
            end
            6'b101010: begin//srl
                alucontrol = 4'b1000;
            end
            6'b01xxxx: begin//beq |sub
                alucontrol = 4'b0110;
            end
            default: begin
                alucontrol = 4'b0000;
            end
        endcase
    end
endmodule