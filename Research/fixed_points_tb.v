`timescale 1ns / 1ps

module fixed_points_tb();

//list inputs and outputs
reg CLK100MHZ;
wire [7:0] c;


fixed_point uut(
.CLK100MHZ(CLK100MHZ),
.c(c)
);

localparam sf = 2.0**-4.0;
initial begin
CLK100MHZ=0;
#100

$display("%f" ,$itor(c)*sf);

$finish;
end

always begin
    #5 CLK100MHZ = ~CLK100MHZ;
end

endmodule
