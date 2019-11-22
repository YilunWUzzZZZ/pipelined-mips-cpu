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
	 input [31:0] pc4,inst,wdi;		//pc4-PCֵ���ڼ���jpc��inst-��ȡ��ָ�wdi-��Ĵ���д�������
	 input we;
	 input clk,clrn;		//clk-ʱ���źţ�clrn-��λ�źţ�
	 input btaken, ebtaken;		//branch�����ź�
	 output id_btaken, beq, bne;
	 input [4:0] exe_rd,  mem_rd;
	 input  exe_wreg, mem_wreg, exe_m2reg;
	 input [4:0] wdest; //��ǰд�ؼĴ�����
	 output [31:0] bpc,jpc,a,b,imm;		//bpc-branch_pc��jpc-jump_pc��a-�Ĵ���������a��b-�Ĵ���������b��imm-������������
	 output [2:0] aluc;		//ALU�����ź�
	 output [1:0] pcsource;	//��һ��ָ���ַѡ��
	 output [1:0] store_src; 
	 output [1:0] alusrc_a, alusrc_b; //ALU a,b��MUX������
	 output wreg, m2reg,wmem;		
	 output [4:0] dest;		//��ǰָ��д�ؼĴ����ţ�������
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
	 Control_Unit cu(btaken, ebtaken, func,                          //���Ʋ���
	             op,wreg,m2reg,wmem,aluc,regrt,alusrc_b,
					 sext,pcsource,store_src, alusrc_a, stall, ldst_depen, rs, rt, exe_rd, exe_wreg, exe_m2reg, mem_rd, mem_wreg, id_btaken, beq, bne);
			 
    Regfile rf (rs,rt,wdi,wdest,we,~clk,clrn,qa,qb);//�Ĵ����ѣ���32��32λ�ļĴ�����0�żĴ�����Ϊ0
	 mux5_2_1 des_reg_num (rd,rt,regrt,dest); //ѡ��Ŀ�ļĴ�����������rd,����rt

	 assign a=qa;
	 assign b=qb;

	 assign e=sext&inst[25];//������չ��0��չ
	 assign ext16={16{e}};//������չ
	 assign imm={ext16,inst[25:10]};		//�����������з�����չ

	 assign br_offset={imm[29:0],2'b00};		//����ƫ�Ƶ�ַ
	 add32 br_addr (pc4,br_offset,bpc);		//beq,bneָ���Ŀ���ַ�ļ���
	 assign jpc={pc4[31:28],inst[25:0],2'b00};		//jumpָ���Ŀ���ַ�ļ���
	 
endmodule
