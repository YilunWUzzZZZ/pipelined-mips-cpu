`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:04:15 06/01/2019 
// Design Name: 
// Module Name:    EXE_MEM_PipeReg 
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
module EXE_MEM_PipeReg(
	 input clk,
	 input clrn,
    input ewreg,
    input em2reg,
    input ewmem,
	 input z,
    input[31:0] aluout,
    input[4:0] edest,
    input[31:0] store_data,
	 input eldst_depen,
	 input[31:0] ebpc,
	 input ebeq,
	 input ebne,
    output reg mwreg,
    output reg mm2reg,
    output reg mwmem,
	 output reg mz,
    output reg[31:0] maluout,
    output reg[4:0] mdest,
    output reg[31:0] datain,
	 output reg mldst_depen,
	 output reg [31:0] mbpc,
	 output reg mbeq,
	 output reg mbne
    );
	always@(negedge clrn or posedge clk)
		if(clrn == 0)
			begin
				mwreg <= 0;
				mm2reg <=0;
				mwmem <= 0;
				mz <= 0;
				maluout <= 0;
				mdest <= 0;
				datain <= 0;
				mldst_depen <= 0;
				mbpc <= 0;
				mbeq <= 0;
				mbne <= 0;
			end
		else
			begin
				mwreg <= ewreg;
				mm2reg <= em2reg;
				mwmem <= ewmem;
				mz <= z;
				maluout <= aluout;
				mdest <= edest;
				datain <= store_data;
				mldst_depen <= eldst_depen;
				mbpc <= ebpc;
				mbeq <= ebeq;
				mbne <= ebne;
			end

endmodule
