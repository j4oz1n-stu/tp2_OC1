module ALU(
    input [31:0] read1 , [31:0] read2_Imm,
    input [3:0] alucontrol,
    output [31:0] alusaida
    output zero
);
always @(*)begin
casex
    4'b0110:begin //beq|sub
        alusaida = rs1 - rs2_Imm;
    end
    4'b0000:begin //and
        alusaida = rs1 & rs2_Imm;
    end
    4'b1000:begin //srl
        alusaida = rs1 >> rs2_Imm;
    end
    4'b0001:begin //ori
        alusaida = rs1 | rs2_Imm;
    end
    4'b0010:begin //lb,sb
        alusaida = rs1 + rs2_Imm;
    end
endcase
end
endmodule