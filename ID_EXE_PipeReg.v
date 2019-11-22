`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:45:46 06/01/2019 
// Design Name: 
// Module Name:    ID_EXE_PipeReg 
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
module ID_EXE_PipeReg(
	 input clk,
    input clrn,
    input wreg,
    input m2reg,
    input wmem,
    input[2:0] aluc,
    input [1:0] alusrc_a,
    input [1:0] alusrc_b,
	 input [1:0] store_src,
    input[31:0] imm,
    input[31:0] a,
    input[31:0] b,
    input[4:0] dest,
	 input ldst_depen,
	 input[31:0] bpc,
	 input beq,
	 input bne,
	 input id_btaken,
    output reg ewreg,
    output reg em2reg,
    output reg ewmem,
    output reg[2:0] ealuc,
    output reg[1:0] ealusrc_a,
    output reg[1:0] ealusrc_b,
	 output reg[1:0] estore_src,
    output reg[31:0] eimm,
    output reg[31:0] ea,
    output reg[31:0] eb,
    output reg[4:0] edest,
	 output reg eldst_depen,
	 output reg[31:0] ebpc,
	 output reg ebeq,
	 output reg ebne,
	 output reg ebtaken
    );
	
	always@(negedge clrn or posedge clk)
		if(clrn == 0)
			begin
				ewreg <= 0;
				em2reg <= 0;
				ewmem <= 0;
				ealuc <= 0;
				ealusrc_a <= 0;
				ealusrc_b <= 0;
				estore_src <= 0;
				eimm <= 0;
				ea <= 0;
				eb <= 0;
				edest <= 0;
				eldst_depen <= 0;
				ebpc <= 0;
				ebeq <= 0;
				ebne <= 0;
				ebtaken <= 0;
			end
		else
			begin
				ewreg <= wreg;
				em2reg <= m2reg;
				ewmem <= wmem;
				ealuc <= aluc;
				ealusrc_a <= alusrc_a;
				ealusrc_b <= alusrc_b;
				estore_src <= store_src;
				eimm <= imm;
				ea <= a;
				eb <= b;
				edest <= dest;
				eldst_depen <= ldst_depen;
				ebpc <= bpc;
				ebeq <= beq;
				ebne <= bne;
				ebtaken <= id_btaken;
			end

endmodule
