`timescale 1ns / 1ps

module Display_tb();

//list inputs and outputs
reg CLK100MHZ;
reg success;
reg error;
reg reset_in;

wire [6:0] AN;
wire [7:0] SEG;
//instantiate uut
top uut(
.CLK100MHZ(CLK100MHZ),
.reset_in(reset_in),
.success(success),
.error(error),
.AN(AN),
.SEG(SEG)
);

initial begin
CLK100MHZ=0;
success=0;
error=0;
reset_in=0;
#10
reset_in=1;
#10
reset_in=0;
#10
success=1;
#100000
success=0;
#100
error=1;
#100000
error=0;

#40000000;
$finish;
end

always begin
    #5 CLK100MHZ = ~CLK100MHZ;
end

endmodule
