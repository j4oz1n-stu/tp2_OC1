
module multiplexador (
    input             control, // 0 = input1; 1 =input2
    input      [31:0] input1,  // Entrada 0
    input      [31:0] input2,  // Entrada 1
    output reg [31:0] saida    // Saída selecionada
);

    always @(*) begin
        if (control)
            saida = input2;
        else
            saida = input1;
    end

endmodule
