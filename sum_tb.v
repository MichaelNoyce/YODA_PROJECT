`timescale 1ns / 1ps

module sum_tb();

reg clk;
reg reset_in;
//reg done;
reg [0:0] s_axis_phase_tvalid_input;
wire [31:0] Y_output;
wire [31:0] sum_out;
wire [7:0] BRAM_result;
wire [7:0] X_input;


top top(
    .CLK100MHZ(clk),
    //.done(done),
    .s_axis_phase_tvalid_input(s_axis_phase_tvalid_input),
    //.X_input(X_input),
    .Y_output(Y_output),
    .X_input(X_input),
    .sum_out(sum_out),
    .BRAM_result(BRAM_result),
    .reset_in(reset_in)
    );

initial begin

clk=0;
reset_in=0;
//done=0;
s_axis_phase_tvalid_input <= 1'b0;
#10
reset_in=1;
#10;
reset_in=0;
#10
s_axis_phase_tvalid_input <= 1'b1;
#1000000000

$finish;
end

always begin
    #5 clk = ~clk; //100x10^6 Hz clock
end

endmodule