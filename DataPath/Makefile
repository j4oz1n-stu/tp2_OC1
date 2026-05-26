# =============================================================================
# Makefile — RISC-V Grupo 4
# Ferramenta: Icarus Verilog (iverilog) + vvp
#
# Comandos disponíveis:
#   make sim     → compila e executa a simulação (mostra registradores no terminal)
#   make wave    → abre o GTKWave para visualizar as ondas (requer GTKWave instalado)
#   make clean   → apaga os arquivos gerados pela compilação
#   make help    → mostra esta ajuda
# =============================================================================

# Nome do executável gerado pelo iverilog
EXEC = simulador

# Arquivo de ondas para GTKWave
VCD = simulacao.vcd

# Arquivo principal de simulação
TB = testbench.v

# Compilador Verilog
IVERILOG = iverilog

# Flags do compilador (-g2012 habilita SystemVerilog básico)
FLAGS = -g2012

# -------------------------------------------------------
# Alvo padrão: compila e executa
# -------------------------------------------------------
sim: $(EXEC)
	@echo ""
	@echo ">>> Executando simulação..."
	@echo ""
	vvp $(EXEC)

# -------------------------------------------------------
# Compila o testbench (que já inclui todos os outros módulos via `include)
# -------------------------------------------------------
$(EXEC): $(TB)
	@echo ">>> Compilando com iverilog..."
	$(IVERILOG) $(FLAGS) -o $(EXEC) $(TB)

# -------------------------------------------------------
# Abre o GTKWave com o arquivo de ondas (execute após 'make sim')
# -------------------------------------------------------
wave: $(VCD)
	gtkwave $(VCD) &

# -------------------------------------------------------
# Remove arquivos gerados
# -------------------------------------------------------
clean:
	@echo ">>> Limpando arquivos gerados..."
	rm -f $(EXEC) $(VCD)

# -------------------------------------------------------
# Ajuda
# -------------------------------------------------------
help:
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make sim    - Compila e roda a simulação"
	@echo "  make wave   - Abre GTKWave (execute depois de 'make sim')"
	@echo "  make clean  - Remove arquivos gerados"
	@echo ""

.PHONY: sim wave clean help

