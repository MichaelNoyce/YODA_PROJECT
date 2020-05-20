module Debounce(
    input clk, 
    input DB_reset,
    input button,
    output reg button_output
);

reg [21:0]Count = 1'b0; //assume count is null on FPGA configuration
reg old_value = 1'b0;
//--------------------------------------------
always @(posedge clk) begin 
    // implement your logic here
    if (DB_reset) begin
    button_output <= 0;
    end

    if(Count==19'b1000000000000000000) begin  //change this value in order to test 
        button_output <= button;
        Count <= 0;
    end

    else if(button==old_value) begin
        Count <= Count+1'b1;
    end 

    else begin
        old_value <= button;
    end
end 


endmodule

