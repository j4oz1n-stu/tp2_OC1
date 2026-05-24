`include "programCounter.v"
`include "instructionMemory.v"
`include "control_ALUcontrol.v"
`include "BancoDeRegistradores.v"
`include "immGen.v"
`include "mux.v"
`include "ALU.v"
`include "BancoDeMemoria.v"

module data_path (
    input clk,   // Clock do processador
    input reset  // Reset: volta PC para 0
);
    wire [31:0] next_pc; // Próximo endereço
    wire [31:0] pc;      // Endereço atual

    program_counter pc_module (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    wire [31:0] instruction;
    instruction_memory instruction_mem (
        .pc(pc),
        .instruction(instruction)
    );


    //Sinais de controle
    wire branch, memread, memtoreg, memwrite, alusrc, regwrite;
    wire [1:0]  aluOp;
    Control control (
        .opcode(instruction[6:0]),
        .branch(branch),
        .memread(memread),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .alusrc(alusrc),
        .regwrite(regwrite),
        .aluop(aluOp)
    );


    wire [31:0] write_data; // Dado que será escrito em rd (vem do mux2)
    wire [31:0] read_1, read_2;
    BancoReg banco_de_registradores (
        .clk       (clk),
        .regwrite  (regwrite),
        .rs1       (instruction[19:15]),
        .rs2       (instruction[24:20]),
        .rd        (instruction[11:7]),
        .write_data(write_data),
        .read1     (read_1),
        .read2     (read_2)
    );


    wire [31:0] imm_extendido;
    ImmGen ImmGen_inst (
        .instruction  (instruction),
        .imm_extendido(imm_extendido)
    );


    wire [31:0] alu_operando2;
    multiplexador mux_alusrc (
        .control(alusrc),
        .input1(read_2),         // 0 = usa rs2 (tipo R, beq)
        .input2(imm_extendido),  // 1 = usa imediato (lb, sb, ori)
        .saida(alu_operando2)
    );


    wire [3:0] aluControl;
    ALUControl alu_control (
        .funct3(instruction[14:12]),
        .funct7_b30(instruction[30]),
        .aluop(aluOp),
        .alucontrol(aluControl)
    );


    wire [31:0] alusaida;
    wire zero;
    ALU alu (
        .read1(read_1),
        .read2_Imm(alu_operando2),
        .alucontrol(aluControl),
        .alusaida(alusaida),
        .zero(zero)
    );


    wire [31:0] memread_valor;
    mem memory_bank (
        .clk(clk),
        .memread(memread),
        .memwrite(memwrite),
        .alu_resultado(alusaida),
        .write_data(read_2),      // sb escreve o valor de rs2
        .mem_read(memread_valor)
    );


    multiplexador mux_memtoreg (
        .control(memtoreg),
        .input1(alusaida),      // 0 = resultado da ALU (tipo R, ori)
        .input2(memread_value), // 1 = dado lido da memória (lb)
        .saida(write_data)
    );


    assign next_pc = (branch && zero) ? (pc + imm_extendido) : (pc + 4);

endmodule
