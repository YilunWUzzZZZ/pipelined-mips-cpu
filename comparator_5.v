`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:09:21 06/02/2019 
// Design Name: 
// Module Name:    comparator_5 
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
module comparator_5(
	 output Z,
    input[4:0] A,
    input[4:0] B
    );
	
	assign Z = (A==B)?1'b1:1'b0;
	
	
endmodule
