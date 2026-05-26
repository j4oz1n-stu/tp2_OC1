compilar:
	gcc -Wall Montador/main.c Montador/assembler.c -o Montador/montador

run: compilar
	./Montador/montador Montador/assembly.asm DataPath/memorias/instrucoes.txt

compilar-v:
	iverilog -g2012 -IDataPath -IDataPath/modules -o DataPath/simulador DataPath/testbench.v

run-v: compilar-v
	vvp DataPath/simulador

wave:
	gtkwave DataPath/simulacao.vcd &

clean:
	rm -f montador/montador DataPath/simulador DataPath/simulacao.vcd

.PHONY: all compile-c run-c compile-v run-v wave clean