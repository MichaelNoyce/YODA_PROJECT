`timescale 1ns / 1ps

module top(

    input CLK100MHZ,
    input BTNA, //start checksum
    input BTNB, //reset module

    output reg [7:0] SEG, //to display 'Error' or 'Done'
    output reg [6:0] AN, 
    output reg [0:0] s_axis_phase_input,
    output reg [7:0] s_axis_phase_tdata_input,
    output reg [31:0] Y_output
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
    reg [2:0]letter1=4'd0; //S //E
	reg [2:0]letter2=4'd0; //U //R
	reg [2:0]letter3=4'd0; //C //R
	reg [2:0]letter4=4'd0; //C //O
	reg [2:0]letter5=4'd0; //E //R
	reg [2:0]letter6=4'd0; //S
	reg [2:0]letter7=4'd0; //S
    
    //Initialize seven segment
	wire [7:0] SegmentDrivers;
	wire [6:0] SevenSegment;
	
	SS_Driver SS_Driver1(
		CLK100MHZ, reset_in, letter1, letter2, letter3, letter4, letter5, letter6,letter7,
		SegmentDrivers, SevenSegment
	);
	
	//BRAM_A contains the input .coe file
	//Memory A IO
    reg ena = 1; //Port A clock enable (enables read, write and reset)
    reg wea = 0; //Port A write disabled
    reg [3:0] addra=0; //Port A address  
    reg [7:0] dina=0; //We're not putting data in, so we can leave this unassigned
    wire [7:0] douta; //Port A data output (to read) 
    reg reset = 1'b1;
    	
	//instantiate BRAM_A    
    blk_mem_gen_0 new_BRAM (
    CLK100MHZ,    // input wire clka
    ena,      // input wire ena
    wea,      // input wire [0 : 0] wea
    addra,  // input wire [7 : 0] addra
    dina,    // input wire [10 : 0] dina
    douta  // output wire [7 : 0] douta
    );
    
    //TODO instantiate BRAM_B	
	
//cordic core
cordic_0 sine_instance(
   CLK100MHZ,                  // input wire aclk
   s_axis_phase_input,         // input wire s_axis_phase_tvalid
   s_axis_phase_tdata_input,   // input wire [7 : 0] s_axis_phase_tdata
   m_axis_dout_tvalid_output,  // output wire m_axis_dout_tvalid
   m_axis_dout_tdata_output    // output wire [31 : 0] m_axis_dout_tdata
);

	//checksum variables
	reg [31:0] sum=0;
	reg [7:0] X_input; //8 bit input
	reg [0:0] success =0;
	reg [0:0] error=0;
	integer i=0;
	//The main logic
	always @(posedge CLK100MHZ) begin
	    
	   AN<= SegmentDrivers;
	   SEG<=SevenSegment;
	   
	   X_input <=douta; //read input byte from BRAM_A
	   
	   s_axis_phase_input <= 1'b1; // input wire s_axis_phase_tvalid
	   s_axis_phase_tdata_input <= X_input; //input byte to sine module  
	
	   Y_output <= m_axis_dout_tdata_output;
	   
	   if (addra<9)begin
	       addra=addra+1;
	   end else begin
	       addra<=0;
	   end
	   //se tthe display values
	   if(success)begin
	       letter1<=3;//S
	       letter2<=4;//U
	       letter3<=5;//C
	       letter4<=5;//C
	       letter5<=0;//E
	       letter6<=3;//S
	       letter7<=3;//S
	   end 
	   
	   if(error)begin
	       letter1<=0;//E
	       letter2<=1;//R
	       letter3<=1;//R
	       letter4<=2;//O
	       letter5<=1;//R
	       letter6<=6;//off
	       letter7<=6;//off
	       
	   
	   end
	   
       if (reset_in)begin
       //TODO reset logic
       sum<=0;
       end else begin
       //TODO implement main logic 
       end


    end
endmodule
