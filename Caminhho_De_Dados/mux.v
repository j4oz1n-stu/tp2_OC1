module mux (
    input control,
    input [31:0] input1, [31:0] input2,
    output reg [31:0] saida
);
    always @(*) begin
        if (control)
            saida = input2;
        else
            saida = input1;
    end
endmodule