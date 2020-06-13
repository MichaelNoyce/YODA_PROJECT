`timescale 1ns / 1ps

module top(

    input CLK100MHZ,
    input BTNA, //start checksum
    input BTNB, //reset module

    output reg [7:0] SEG, //to display 'Error' or 'Done'
    output reg [3:0] AN 
);

    //Add the reset  
    wire reset_in;
    Delay_Reset resetTop(CLK100MHZ, BTNA, reset_in);

    //Add and debounce the button
    wire StartButton; //Debounced button output
	
    // Instantiate Debounce modules here
    Debounce StartButton_Debounce(CLK100MHZ, reset_in, BTNA, StartButton);
    
    //Edge Detector 
	reg Old_StartButton;
	wire rising_edge_Start;
		
	assign rising_edge_Start = StartButton & !Old_StartButton; 
	
	always @(posedge CLK100MHZ)begin
        if (reset_in)begin
            Old_StartButton <= 1'b0;
        end else begin
            Old_StartButton <= StartButton;
        end
    end
      
    //Counters 
    reg Start_event;
   
    always @(posedge CLK100MHZ)begin
        if (reset_in)begin
        Start_event <= 1'b0;
        end
        else if(rising_edge_Start) begin
            Start_event <= 1'b1;
            end
        else Start_event <= 1'b0;
    end 
    
    // registers for storing output message 
    reg [3:0]letter1=4'd0;
	reg [3:0]letter2=4'd0;
	reg [3:0]letter3=4'd0;
	reg [3:0]letter4=4'd0;
    
    //Initialize seven segment
	wire [3:0] SegmentDrivers;
	wire [7:0] SevenSegment;
	
	//TODO get the correct letters displayed in BCD_Decoder
	SS_Driver SS_Driver1(
		CLK100MHZ, reset_in, letter1, letter2, letter3, letter4,
		SegmentDrivers, SevenSegment
	);
	
	//BRAM_A contains the input .coe file
	//Memory A IO
    reg ena = 1; //Port A clock enable (enables read, write and reset)
    reg wea = 0; //Port A write disabled
    reg [7:0] addra=0; //Port A address //TODO depth of BRAM_A 
    reg [7:0] dina=0; //We're not putting data in, so we can leave this unassigned
    wire [7:0] douta; //Port A data output (to read) //TODO width of BRAM_A
    reg reset = 1'b1;
       	
	//instantiate BRAM_A
	//currently it has 256 samples stored    
    blk_mem_gen_0 new_BRAM (
    CLK100MHZ,    // input wire clka
    ena,      // input wire ena
    wea,      // input wire [0 : 0] wea
    addra,  // input wire [7 : 0] addra
    dina,    // input wire [7 : 0] dina
    douta  // output wire [7 : 0] douta
    );
    	
	//TODO instantiate CORDIC Core
	
	//checksum variables
	reg [31:0] sum=0;
	reg [7:0] X_input; //8 bit input X
	reg [31:0] Y_output; //32 bit output Y 
	
	//The main logic
	always @(posedge CLK100MHZ) begin
	   AN<= SegmentDrivers;
	   SEG<=SevenSegment;
	   X_input <=douta; //read input byte from BRAM_A
	   
	   if(Start_event)begin
	   //TODO start logic
	   end
	   
       if (reset_in)begin
       //TODO reset logic
       sum<=0;
       end else begin
       //TODO implement main logic 
       end


    end
endmodule
