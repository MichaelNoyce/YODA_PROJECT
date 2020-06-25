`timescale 1ns / 1ps


module fixed_point(
input CLK100MHZ,
 output reg [7:0] c,
 output reg [7:0] d
 );
    
    parameter [7:0] a = 8'b0111_1000;
    parameter [7:0] b= 8'b0000_1000;
    parameter [15:0] ab =a*b;
    reg [7:0] temp = ab[11:4];
    
    //localparam sf = 2.0**-4.0;
    
    always @(posedge CLK100MHZ) begin
     c <= temp;
    
    
    end
    
    
    //a = 8'b01111000;  // 7.5000
    //b = 8'b0000_1000;  // 0.5000
    //ab = a * b;        // 00000011.11000000 = 3.7500
    //c <= ab[11:4];      // take middle 8 bits: 0011.1100 = 3.7500
        
endmodule
