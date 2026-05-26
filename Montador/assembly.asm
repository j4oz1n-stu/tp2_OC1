sub x5, x5, x6
and x7, x8, x9
srl x10, x11, x12
sub x5, x5, x12 
lb x4, 0(x3)
beq x0,x0, loop
sub x5, x5, x5
loop:
sub x5, x5, x12