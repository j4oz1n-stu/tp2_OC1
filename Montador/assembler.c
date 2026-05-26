#include "assembler.h"
void binario(int valor, char binario[]) {
    for (int i = 4; i >= 0; i--) {
        binario[4 - i] = ((valor >> i) & 1) + '0';
    }
    binario[5] = '\0';
}

void binario_imediato(int valor, char binario[]) {
    for (int i = 11; i >= 0; i--) {
        binario[11 - i] = ((valor >> i) & 1) + '0';
    }
    binario[12] = '\0';
}
void cleaner (char linha[]){
    for(int i = 1; linha[i]!='\0'; i++){
        if(linha[i]==',' || linha[i]=='x' || linha[i]=='(' || linha[i]==')') linha[i]=' ';
    }
}
void output_w(char comando[], int output_type, FILE* saida){
    if(output_type==1){
        //saida de arquivo
        fprintf(saida, "%s\n", comando);
    }
    else{
        printf("%s\n", comando);
    }
}
void labels_finder(char linha[],rotulo rotulos[],int *qntsRotulos,int* pc){
    char primeira[50];
        sscanf(linha,"%s",primeira);
        int len = strlen(primeira);
        if(primeira[len-1] == ':'){
            primeira[len - 1] = '\0';
            strcpy(rotulos[*qntsRotulos].nome,primeira);
            rotulos[*qntsRotulos].endereco = *pc;
            (*qntsRotulos)++;
        }
}
void assembler (char linha[], int output_type, FILE* saida,rotulo rotulos[],int *qntsRotulos,int* pc){
    //com essa parte
    char primeira[50];
    sscanf(linha,"%s",primeira);
    int len = strlen(primeira);
    if(primeira[len-1] == ':'){
    char *resto = strchr(linha, ':');
    if(resto != NULL){
                resto++;
                while (*resto == ' ' || *resto == '\t') {
                    resto++;
                }       

                if (*resto == '\0' || *resto == '\n') {
                    return;
                }
                strcpy(linha, resto);
            
        
        }

    }
    cleaner(linha);
    char comando [3];
    char output [33];
    sscanf(linha, "%s", comando);
    if (strcmp(comando, "sub")==0){
        unsigned int rd;
        char rd_bin [6];
        unsigned int rs1;
        char rs1_bin[6];
        unsigned int rs2;
        char rs2_bin[6];
        sscanf(linha, "%*s  %d  %d  %d", &rd, &rs1, &rs2);
        binario(rd, rd_bin);
        binario(rs1, rs1_bin);
        binario(rs2, rs2_bin);
        // RISC-V SUB: funct7 | rs2 | rs1 | funct3 | rd | opcode
        sprintf(output, "0100000%s%s000%s0110011", rs2_bin, rs1_bin, rd_bin);
        output_w(output, output_type, saida);

    }
    else if(strcmp(comando, "ori")==0){
        unsigned int rd,rs1;
        signed int imm;
        char rd_bin[6];char rs1_bin[6];char imm_bin[13];
        sscanf(linha,"%*s %d %d %d",&rd,&rs1,&imm);
        binario(rd, rd_bin);
        binario(rs1, rs1_bin);
        binario_imediato(imm, imm_bin);
        // RISC-V ORI: imm[11:0] | rs1 | funct3 | rd | opcode
        sprintf(output, "%s%s110%s0010011", imm_bin, rs1_bin, rd_bin);
        output_w(output, output_type, saida);
    }
    else if(strcmp(comando, "beq")==0){
        unsigned int rs1,rs2;
        char rotulo_nome[50];
        int rotulo_endereco = -1;
        char rs1_bin[6];char rs2_bin[6];char offset_bin[13];
        sscanf(linha,"%*s %d %d %s",&rs1,&rs2,rotulo_nome);
        for(int i=0;i<*qntsRotulos;i++){
                int resultado = strcmp(rotulos[i].nome,rotulo_nome);
                if(resultado==0){rotulo_endereco = rotulos[i].endereco;break;}
        }
        int offset;
        //calcular offset
        offset = ((rotulo_endereco-(*pc))/2);
        binario(rs1,rs1_bin);
        binario(rs2,rs2_bin);
        binario_imediato(offset,offset_bin);
        char bit12 = offset_bin[0];char bit11 = offset_bin[1];
        char bits10_5[7];char bits4_1[5];
        strncpy(bits10_5, &offset_bin[2], 6);
        bits10_5[6] = '\0';
        strncpy(bits4_1, &offset_bin[8], 4);
        bits4_1[4] = '\0';
        sprintf(output, "%c%s%s%s000%s%c1100011",bit12,bits10_5, rs2_bin, rs1_bin,bits4_1,bit11);
        output_w(output, output_type, saida);
    }
    else if(strcmp(comando, "lb")==0){
        unsigned int rd;
        char rd_bin[6];
        unsigned int rs1;
        char rs1_bin[6];
        signed int imm;
        char imm_bin[13];
        sscanf(linha, "%*s %d %d %d", &rd, &imm, &rs1);
        binario(rd, rd_bin);
        binario(rs1, rs1_bin);
        binario_imediato(imm, imm_bin);
        // RISC-V LB: imm[11:0] | rs1 | funct3 | rd | opcode
        sprintf(output, "%s%s000%s0000011", imm_bin, rs1_bin, rd_bin);
        output_w(output, output_type, saida);

    }
    else if(strcmp(comando, "sb")==0){ //meu
        unsigned int rs2;
        char rs2_bin[6];
        unsigned int rs1;
        char rs1_bin[6];
        signed int imm;
        char imm_bin[13];
        sscanf(linha, "%*s %d %d %d", &rs2, &imm, &rs1);
        binario(rs2, rs2_bin);
        binario(rs1, rs1_bin);
        binario_imediato(imm, imm_bin);
        char imm_5_11_bin [8];
        char imm_0_4_bin [6];
        for (int i = 0; i < 7; i++){
            imm_5_11_bin[i] = imm_bin[i];
        }
        imm_5_11_bin[7] = '\0';
        for (int i = 0; i < 5; i++){
            imm_0_4_bin[i] = imm_bin[i + 7]; 
        }
        imm_0_4_bin[5] = '\0';
        // RISC-V SB: imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode
        sprintf(output, "%s%s%s000%s0100011", imm_5_11_bin, rs2_bin, rs1_bin, imm_0_4_bin);
        output_w(output, output_type, saida);

    }
    else if(strcmp(comando, "and")==0){
        unsigned int rd;
        char rd_bin [6];
        unsigned int rs1;
        char rs1_bin[6];
        unsigned int rs2;
        char rs2_bin[6];
        sscanf(linha, "%*s  %d  %d  %d", &rd, &rs1, &rs2);
        binario(rd, rd_bin);
        binario(rs1, rs1_bin);
        binario(rs2, rs2_bin);
        // RISC-V AND: funct7 | rs2 | rs1 | funct3 | rd | opcode
        sprintf(output, "0000000%s%s111%s0110011", rs2_bin, rs1_bin, rd_bin);
        output_w(output, output_type, saida);
    }
    else if(strcmp(comando, "srl")==0){ //meu
                    unsigned int rd;
        char rd_bin [6];
        unsigned int rs1;
        char rs1_bin[6];
        unsigned int rs2;
        char rs2_bin[6];
        sscanf(linha, "%*s  %d  %d  %d", &rd, &rs1, &rs2);
        binario(rd, rd_bin);
        binario(rs1, rs1_bin);
        binario(rs2, rs2_bin);
        // RISC-V SRL: funct7 | rs2 | rs1 | funct3 | rd | opcode
        sprintf(output, "0000000%s%s101%s0110011", rs2_bin, rs1_bin, rd_bin);
        output_w(output, output_type, saida);
    }
    (*pc) += 4;
}

