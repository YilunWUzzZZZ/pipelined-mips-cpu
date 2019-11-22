`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:48 05/15/2019 
// Design Name: 
// Module Name:    ID_STAGE 
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
module ID_STAGE(pc4,inst,wdest,dest,
              we, wdi,clk,clrn,bpc,jpc,pcsource, store_src, exe_rd, exe_wreg, exe_m2reg, mem_rd, mem_wreg, stall, ldst_depen, wreg,
				  m2reg,wmem,aluc,alusrc_b,a,b,imm,
				  alusrc_a,btaken, ebtaken, id_btaken, beq, bne
    );
	 input [31:0] pc4,inst,wdi;		//pc4-PC值用于计算jpc；inst-读取的指令；wdi-向寄存器写入的数据
	 input we;
	 input clk,clrn;		//clk-时钟信号；clrn-复位信号；
	 input btaken, ebtaken;		//branch控制信号
	 output id_btaken, beq, bne;
	 input [4:0] exe_rd,  mem_rd;
	 input  exe_wreg, mem_wreg, exe_m2reg;
	 input [4:0] wdest; //当前写回寄存器号
	 output [31:0] bpc,jpc,a,b,imm;		//bpc-branch_pc；jpc-jump_pc；a-寄存器操作数a；b-寄存器操作数b；imm-立即数操作数
	 output [2:0] aluc;		//ALU控制信号
	 output [1:0] pcsource;	//下一条指令地址选择
	 output [1:0] store_src; 
	 output [1:0] alusrc_a, alusrc_b; //ALU a,b端MUX控制码
	 output wreg, m2reg,wmem;		
	 output [4:0] dest;		//当前指令写回寄存器号，译码结果
	 output stall, ldst_depen;
	 
	 wire [5:0] op,func;
	 wire [4:0] rs,rt,rd;
	 wire [31:0] qa,qb,br_offset;
	 wire [15:0] ext16;
	 wire regrt,sext,e;
	 
	 assign func=inst[25:20];  
	 assign op=inst[31:26];
	 assign rs=inst[9:5];
	 assign rt=inst[4:0];
	 assign rd=inst[14:10];
	 Control_Unit cu(btaken, ebtaken, func,                          //控制部件
	             op,wreg,m2reg,wmem,aluc,regrt,alusrc_b,
					 sext,pcsource,store_src, alusrc_a, stall, ldst_depen, rs, rt, exe_rd, exe_wreg, exe_m2reg, mem_rd, mem_wreg, id_btaken, beq, bne);
			 
    Regfile rf (rs,rt,wdi,wdest,we,~clk,clrn,qa,qb);//寄存器堆，有32个32位的寄存器，0号寄存器恒为0
	 mux5_2_1 des_reg_num (rd,rt,regrt,dest); //选择目的寄存器是来自于rd,还是rt

	 assign a=qa;
	 assign b=qb;

	 assign e=sext&inst[25];//符号拓展或0拓展
	 assign ext16={16{e}};//符号拓展
	 assign imm={ext16,inst[25:10]};		//将立即数进行符号拓展

	 assign br_offset={imm[29:0],2'b00};		//计算偏移地址
	 add32 br_addr (pc4,br_offset,bpc);		//beq,bne指令的目标地址的计算
	 assign jpc={pc4[31:28],inst[25:0],2'b00};		//jump指令的目标地址的计算
	 
endmodule
