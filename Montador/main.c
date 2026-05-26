#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "assembler.h"
int main(int argc, char *argv[]){
    if (argc < 3) {
        return 1;
    }
    FILE *entrada = fopen(argv[1], "r");
    FILE *saida = fopen(argv[2], "w");

    if (entrada == NULL || saida == NULL) {
        perror("Erro ao abrir os arquivos");
        return 1;
    }
    char linha [70];
    int output_type;
    printf("Escolha a forma que voce gostaria de receber a saida,\n");
    printf("Digite 1 para saida em arquivo ou 2 pra saida no terminal!\n");
    scanf("%d",&output_type);
    rotulo rotulos[100];
    int qntsRotulos = 0;
    int pc = 0;

    while(fgets(linha, 70, entrada)!=NULL){
        labels_finder(linha,rotulos,&qntsRotulos,&pc);
        // Incrementa pc para instrucoes (nao para linhas so de label)
        char primeira[50];
        sscanf(linha, "%s", primeira);
        int len = strlen(primeira);
        if (primeira[len-1] != ':') {
            pc += 4;
        } else {
            // linha pode ter instrucao apos o label na mesma linha
            char *resto = strchr(linha, ':');
            if (resto != NULL) {
                resto++;
                while (*resto == ' ' || *resto == '\t') resto++;
                if (*resto != '\0' && *resto != '\n') {
                    pc += 4;
                }
            }
        }
    }

    rewind(entrada);
    pc = 0;
    while(fgets(linha, 70, entrada)!=NULL){
        assembler(linha, output_type, saida,rotulos,&qntsRotulos,&pc);
    }
    fclose(entrada);
    fclose(saida);
    return 0;

}