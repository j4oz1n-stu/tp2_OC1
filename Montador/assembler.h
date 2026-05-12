#ifndef ASSEMBLER_H
#define ASSEMBLER_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//estrutura que guarda valores de rotulos juntamente com suas posicoes em bytes
typedef struct rotulo
{
    char nome[50];
    int endereco;
}rotulo;
//funcao que traduz os valores dos registradores para binario de 5 bits
void binario(int valor, char binario[]);
//funcao que traduz os valores de imediato para binario de 12 bits
void binario_imediato(int valor, char binario[]);
//funcao que limpa as linhas de instrucoes (retira os caranteres inuteis)
void cleaner (char linha[]);
//funcao que cria a saida
void output_w(char comando[], int output_type, FILE* saida);
//funcao que acha os rotulos e guarda em um vetor
void labels_finder(char linha[],rotulo rotulos[],int *qntsRotulos,int* pc);
//funcao principal que busca como traduzir a instrucao pra linguagem de maquina
void assembler (char linha[], int output_type, FILE* saida,rotulo rotulos[],int *qntsRotulos,int* pc);
#endif