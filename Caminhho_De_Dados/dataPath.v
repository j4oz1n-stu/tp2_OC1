module data_path(
    input clk,
    input reset
);
wire [31:0] next_pc;
wire [31:0] pc;
//calcular o pc e colocar no pc
program_counter pc_module(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc(pc)
);
//banco de instruções e pega a instruções
wire [31:0] instruction;
instruction_memory instruction_mem(
    .pc(pc),
    .instruction(instruction)
);
//control
wire branch, memread, memtoreg, memwrite, alusrc, regwrite;
wire [1:0] aluOp;
Control control(
    .opcode(instruction[6:0]),
    .branch(branch),
    .memread(memread),
    .memtoreg(memtoreg),
    .memwrite(memwrite),
    .alusrc(alusrc),
    .regwrite(regwrite),
    .aluop(aluOp)
);
wire [31:0] write_data;
wire [31:0] read_1, read_2;
BancoReg banco_de_registradores(
    .clk(clk),
    .regwrite(regwrite),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .rd(instruction[11:7]),
    .write_data(write_data),
    .read1(read_1),
    .read2(read_2)
);
wire[31:0] imm_extendido;
immgen ImmGen(
    .instruction(instruction),
    .imm_extendido(imm_extendido)
);
wire [31:0] resultadoAlusrc;
multiplexador mux(
    .control(alusrc),
    .input1(read_2),
    .input2(imm_extendido),
    .saida(resultadoAlusrc)
);
wire [3:0] aluControl;
ALUcontrol ALUControl(
    .funct3(instruction[14:12]),
    .funct7_b30(instruction[30]),
    .aluop(aluOp),
    .alucontrol(aluControl)
);
wire [31:0] alusaida;
wire zero;
ALU alu(
    .read1(read_1),
    .read2_Imm(resultadoAlusrc),
    .alucontrol(aluControl),
    .alusaida(alusaida),
    .zero(zero)
);
wire [31:0] memread_value;
mem memory_bank(
    .clk(clk),
    .memread(memread),
    .memwrite(memwrite),
    .alu_resultado(alusaida),
    .write_data(read_2),
    .mem_read(memread_value)
);

multiplexador mux2(
    .control(memtoreg),
    .input1(alusaida),
    .input2(memread_value),
    .saida(write_data)
);
assign next_pc = (branch && zero) ? (pc + imm_extendido) : (pc + 4);

//banco de registradores e pega a instruções

//leva os trem pra alu ->saida da alu

//memoria

//mux memoria e alusaida 


endmodule