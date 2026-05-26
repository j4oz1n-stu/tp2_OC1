EXECUTAVEL = simulador
ARQUIVO_ONDAS = simulacao.vcd
TESTBENCH = testbench.v
COMPILADOR = iverilog
FLAGS_COMPILADOR = -g2012

all: sim

sim: $(EXECUTAVEL)
	vvp $(EXECUTAVEL)

$(EXECUTAVEL): $(TESTBENCH)
	$(COMPILADOR) $(FLAGS_COMPILADOR) -o $(EXECUTAVEL) $(TESTBENCH)

wave: $(ARQUIVO_ONDAS)
	gtkwave $(ARQUIVO_ONDAS) &

clean:
	rm -f $(EXECUTAVEL) $(ARQUIVO_ONDAS)

.PHONY: all sim wave clean