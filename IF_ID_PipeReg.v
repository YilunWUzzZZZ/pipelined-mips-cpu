`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:32:50 06/01/2019 
// Design Name: 
// Module Name:    IF_ID_PipeReg 
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
module IF_ID_PipeReg(
	 input clk,
	 input clrn,
	 input stall,
	 input[31:0] if_pc4,
    input[31:0] if_inst,
	 output reg[31:0] id_pc4,
    output reg[31:0] id_inst
    );

	
	always@(negedge clrn or posedge clk)
		if(clrn == 0)
			begin
				id_inst <= 0;
				id_pc4 <= 0;
			end
		else if(stall != 1)
			begin
				id_inst <= if_inst;
				id_pc4 <= if_pc4;
			end

			
endmodule
