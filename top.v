`timescale 1ns / 1ps

module top(

    input CLK100MHZ,
    
    //IO
    input BTNA, //start checksum
    input BTNB, //reset module
    input reset_in, //reset module
    //input done,
    input success,
    input error,
    
    //CORDIC core
    input s_axis_phase_tvalid_input,
    output reg [7:0] X_input, //input to the module
    output reg [31:0] Y_output,
    output reg [31:0] sum_out,
    //display
    output reg [7:0] SEG, //to display 'Error' or 'Done'
    output reg [6:0] AN, 
    
    //BRAM
    output reg [7:0] BRAM_result
);

    //BUTTONS
    //Add the reset  
    //wire reset_in;
    //Delay_Reset resetTop(CLK100MHZ, BTNA, reset_in);

    //Add and debounce the button
    wire StartButton; //Debounced button output
	
    // Instantiate Debounce modules here
    //Debounce StartButton_Debounce(CLK100MHZ, reset_in, BTNA, StartButton);
    
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
	
	//TODO get the correct letters displayed in BCD_Decoder
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
	//currently it has 256 samples stored    
    blk_mem_gen_0 new_BRAM (
    CLK100MHZ,    // input wire clka
    ena,      // input wire ena
    wea,      // input wire [0 : 0] wea
    addra,  // input wire [7 : 0] addra
    dina,    // input wire [7 : 0] dina
    douta  // output wire [7 : 0] douta
    );
    	
	//cordic core
    reg [7:0]  s_axis_phase_tdata_input;
    wire m_axis_dout_tvalid_output;
    wire [63:0] m_axis_dout_tdata_output;

    cordic_0 sine_instance(
    CLK100MHZ,                  // input wire aclk
    s_axis_phase_tvalid_input,         // input wire s_axis_phase_tvalid
    s_axis_phase_tdata_input,   // input wire [7 : 0] s_axis_phase_tdata
    m_axis_dout_tvalid_output,  // output wire m_axis_dout_tvalid
    m_axis_dout_tdata_output    // output wire [31 : 0] m_axis_dout_tdata
    );
    
    //reg [7:0] BRAM_result;
    reg [31:0] sum;
    //reg [7:0] X_input;
    //reg [1:0] done;
    //reg[1:0] yes;
    
	//The main logic
	always @(posedge CLK100MHZ) begin
	   AN<= SegmentDrivers;
	   SEG<=SevenSegment;
	   BRAM_result <=douta; //read input byte from BRAM_A
	   //sum <= Y_output + sum;
	   //sum<=temp;
	   sum_out<=sum;
	  
	   
	   if(reset_in)begin
	       sum<=0;
	       //done<=0;
	   end else begin
	       X_input <=douta;
	       s_axis_phase_tdata_input<= douta;
	        Y_output <= m_axis_dout_tdata_output[63:32];
	        sum=sum+Y_output;
	        if (addra<9)begin
	           addra=addra+1;
	        end else begin
	           
	           addra<=0;
	           sum<=0;
	        end 
	   end
	   
	   /*if(done) begin
	       sum_out<=sum;
	   end else begin*/
	       /*if (done)begin
	           Y_output<=0;
	       end else begin*/
	           //Sine core 
	           /*if(s_axis_phase_tvalid_input) begin
	               X_input <=douta;
	               s_axis_phase_tdata_input<= douta; //input byte to sine module 
	             if (addra<9)begin
	                   addra=addra+1;
	               end else begin
	                   sum<=0;
	                   addra<=0;
	               end  
	               
           
	           end
	           
	     end */
	     
	     /*if (m_axis_dout_tvalid_output) begin
	               yes<=1;
	               Y_output <= m_axis_dout_tdata_output[63:32];
	                if (addra<9)begin
	                   addra=addra+1;
	               end else begin
	                   done<=1;
	                   addra<=0;
	               end 
	               //sum=sum+Y_output;
	     end  else begin
	       yes<=0;
	     end      */
	   
	   
	           
		   
	   //set the display values
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

       
       
end
endmodule
