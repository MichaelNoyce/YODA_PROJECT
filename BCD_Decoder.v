module BCD_Decoder(
    input [2:0]BCD,
    output reg [6:0]SevenSegment
);
//------------------------------------------------------------------------------
// Combinational circuit to convert BCD input to seven-segment output
always @(BCD) 
begin
case(BCD)
    // gfedcba
    
    4'd0 : SevenSegment <= 7'b1111001; //letter E //     a
    4'd1 : SevenSegment <= 7'b1110111; //letter R //    ----
    4'd2 : SevenSegment <= 7'b0111111; //letter O //   |   |
    4'd3 : SevenSegment <= 7'b1101101; //letter S //  f| g |b
    4'd4 : SevenSegment <= 7'b0111110; //letter U //    ----
    4'd5 : SevenSegment <= 7'b0111001; //letter C //   |   |
    4'd6 : SevenSegment <= 7'b1111111; //all off  //  e|   |c
                                                  //    ----
                                                  //      d
    //These letters can be used in combination to output
    //SUCCESS or
    //ERROR
default: SevenSegment <= 7'b0000000;
endcase
end
//--------------------------------------------------------------
endmodule 
