module program_counter(
    input clk,
    input reset,
    input reg [31:0] next_pc,//de onde vai chegar esse next_pc
    output reg [31:0] pc
);
    if(reset) begin
        pc <= 32b'00000000;
    end else begin
always @(posedge clk) begin
        pc <= next_pc;
        end//pc sendo calculado em 4 bytes
    end
endmodule