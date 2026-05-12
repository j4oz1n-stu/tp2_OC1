# Variáveis para facilitar mudanças
CC = gcc
CFLAGS = -Wall
TARGET = montador
INPUT = assembly.asm
OUTPUT = saida.txt

# Regra padrão: apenas compila o programa
all: $(TARGET)

$(TARGET): main.c assembler.c
	$(CC) $(CFLAGS) main.c assembler.c -o $(TARGET)

# Regra para rodar o programa automaticamente com os arquivos que você definiu
run: $(TARGET)
	./$(TARGET) $(INPUT) $(OUTPUT)

# Regra para apagar o executável e a saída antiga
clean:
	rm -f $(TARGET) $(OUTPUT)