`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:36:26 06/01/2019 
// Design Name: 
// Module Name:    MEM_WB_PipeReg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MEM_WB_PipeReg(
	 input clk,
	 input clrn,
    input mwreg,
    input mm2reg,
    input[31:0] dataout,
    input[31:0] maluout,
    input[4:0] mdest,
    output reg wwreg,
    output reg wm2reg,
    output reg[31:0] wdataout,
    output reg[31:0] waluout,
    output reg[4:0] wdest
    );
	 
	 always@(posedge clk or negedge clrn)
		if(clrn == 0)
			begin
				wwreg <= 0;
				wm2reg <= 0;
				wdataout <= 0;
				waluout <= 0;
				wdest <= 0;
			end
		else
			begin
				wwreg <= mwreg;
				wm2reg <= mm2reg;
				wdataout <= dataout;
				waluout <= maluout;
				wdest <= mdest;
			end

endmodule
