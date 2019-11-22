`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:46:15 05/15/2019 
// Design Name: 
// Module Name:    Control_Unit 
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
module Control_Unit(btaken, ebtaken, func,
	             op,wreg,m2reg,wmem,aluc,regrt,alusrc_b,
					 sext,pcsource,store_src, alusrc_a,stall,ldst_depen, rs, rt, exe_rd, exe_wreg, exe_m2reg, mem_rd, mem_wreg, id_btaken, beq, bne
    );
	 input btaken, ebtaken; 		//��ת�Ƿ���
	 output id_btaken; //��ǰ�����Ƿ���jump����������ת����
	 input [5:0] func,op;		//ָ������Ӧ�������ֶ�
	 input [4:0] exe_rd, mem_rd; // EXE, MEM��Ŀ��Ĵ���
	 input [4:0] rs, rt; //��ǰrs, rt
	 input exe_wreg, mem_wreg, exe_m2reg; // EXE, MEM��д�Ĵ�����־,EXE��LOAD��־
	 output wreg,m2reg,wmem,regrt,sext;	 
	 output [2:0] aluc;		//ALU������
	 output reg[1:0]  store_src, alusrc_a, alusrc_b;		//ALU, �洢��ѡ��, a,b�˶�·ѡ����������
	 output [1:0] pcsource; //PC��·ѡ����������
	 output stall;
	 output ldst_depen;
	 
	 reg [2:0] aluc;
	 
	 wire shift, aluimm;
	 wire i_add,i_and,i_or,i_xor,i_sll,i_srl,i_sra;            //�Ĵ��������־
	 wire i_addi,i_andi,i_ori,i_xori;		//�����������־
	 wire i_lw,i_sw;		//�洢�������־
	 wire i_beq,i_bne;		//branch�����־
	 wire i_j;		//jump�����־
    output beq, bne;
    ////////////////////////////////////////////�����־������/////////////////////////////////////////////////////////
	 and(i_add,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0],~func[2],~func[1],func[0]);		//add�����־
	 and(i_and,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],~func[1],func[0]);		//and�����־
	 and(i_or,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],func[1],~func[0]);		//or�����־
	 and(i_xor,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],func[2],~func[1],~func[0]);		//xor�����־
	 
	 and(i_sra,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],~func[1],func[0]);		//sra�����־
	 and(i_srl,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],~func[0]);		//srl�����־
	 and(i_sll,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],func[0]);		//sll�����־
	 
	 and(i_addi,~op[5],~op[4],~op[3],op[2],~op[1],op[0]);		//addi�����־
	 and(i_andi,~op[5],~op[4],op[3],~op[2],~op[1],op[0]);		//andi�����־
	 and(i_ori,~op[5],~op[4],op[3],~op[2],op[1],~op[0]);		//ori�����־
	 and(i_xori,~op[5],~op[4],op[3],op[2],~op[1],~op[0]);		//xori�����־
	 
	 and(i_lw,~op[5],~op[4],op[3],op[2],~op[1],op[0]);		//load�����־
	 and(i_sw,~op[5],~op[4],op[3],op[2],op[1],~op[0]);		//store�����־

	 and(i_beq,~op[5],~op[4],op[3],op[2],op[1],op[0]);		//beq�����־
	 and(i_bne,~op[5],op[4],~op[3],~op[2],~op[1],~op[0]);		//bne�����־

	 and(i_j,~op[5],op[4],~op[3],~op[2],op[1],~op[0]);		//jump�����־

	 wire i_rs=i_add|i_and|i_or|i_xor|i_addi|i_andi|i_ori|i_xori|i_lw|i_sw|i_beq|i_bne;		//rs�ֶΣ�Դ��������ʹ�ñ�־
	 wire i_rt=i_add|i_and|i_or|i_xor|i_sra|i_srl|i_sll|i_beq|i_bne;		//rt�ֶΣ�Դ��������ʹ�ñ�־
	 wire exe_rdrs_equ, exe_rdrt_equ, mem_rdrs_equ, mem_rdrt_equ, exe_rdrd_equ, mem_rdrd_equ;//�Ĵ�������ر�־
	 
	 comparator_5 comp_1(exe_rdrs_equ, exe_rd, rs);
	 comparator_5 comp_2(exe_rdrt_equ, exe_rd, rt);
	 comparator_5 comp_3(mem_rdrs_equ, mem_rd, rs);
	 comparator_5 comp_4(mem_rdrt_equ, mem_rd, rt);
	 comparator_5 comp_5(exe_rdrd_equ, exe_rd, rt);
	 comparator_5 comp_6(mem_rdrd_equ, mem_rd, rt);
	 
	 wire exe_a_depen = exe_rdrs_equ & exe_wreg & i_rs;
	 wire exe_b_depen = exe_rdrt_equ & exe_wreg & i_rt;
	 wire mem_a_depen = mem_rdrs_equ & mem_wreg & i_rs;
	 wire mem_b_depen = mem_rdrt_equ & mem_wreg & i_rt;
	 wire exe_store_depen = i_sw & exe_rdrd_equ & exe_wreg;
	 wire mem_store_depen = i_sw & mem_rdrd_equ & mem_wreg;
	 wire load_exe_depen = exe_m2reg&(exe_a_depen|exe_b_depen);
	 assign ldst_depen = exe_m2reg & exe_store_depen; //load-store ���
	 wire dependency = exe_a_depen | exe_b_depen | mem_a_depen | mem_b_depen | exe_store_depen | mem_store_depen;
	 assign stall = load_exe_depen;
	 assign beq = (~ebtaken)&(~btaken)&(~stall) & i_beq; // ��������ת����ǰ������ת��ͣ��ʱ���
	 assign bne = (~ebtaken)&(~btaken)&(~stall) & i_bne; 
    ////////////////////////////////////////////�����źŵ�����/////////////////////////////////////////////////////////
    assign wreg= (i_add|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_addi|i_andi|i_ori|i_xori|i_lw) & (~stall) & (~btaken) & (~ebtaken) ;		//�Ĵ���д�ź�
	 assign regrt=i_addi|i_andi|i_ori|i_xori|i_lw;    //regrtΪ1ʱĿ�ļĴ�����rt������Ϊrd
	 assign m2reg=i_lw;  //������д�ؼĴ�����Ϊ1ʱ���洢������д��Ĵ���������ALU���д��Ĵ���
	 assign shift=i_sll|i_srl|i_sra;//ALUa��������ѡ��Ϊ1ʱALUa�����ʹ����λλ���ֶ�inst[19:15]
	 assign aluimm=i_addi|i_andi|i_ori|i_xori|i_lw|i_sw;//ALUb��������ѡ��Ϊ1ʱALUb�����ʹ��������
 	 assign sext=i_addi|i_lw|i_sw|i_beq|i_bne;//Ϊ1ʱ������չ����������չ
 	 assign wmem=i_sw & (~stall) & (~btaken) & (~ebtaken);//�洢��д�źţ�Ϊ1ʱд�洢��������д
	 assign id_btaken = btaken | (i_j & (~ebtaken)); //��ת����

	 always@(*)
	 begin
		 case({exe_a_depen, mem_a_depen, shift})
				3'b001:  alusrc_a = 2'b00;
				3'b100:  alusrc_a = 2'b01;
				3'b110:  alusrc_a = 2'b01;
				3'b010:  alusrc_a = 2'b10;
				3'b000:  alusrc_a = 2'b11;
		 endcase
		
		 case({exe_b_depen, mem_b_depen, aluimm})
				3'b001:  alusrc_b = 2'b00;
				3'b100:  alusrc_b = 2'b01;
				3'b110:  alusrc_b = 2'b01;
				3'b010:  alusrc_b = 2'b10;
				3'b000:  alusrc_b = 2'b11;
		 endcase
		 
		 case({exe_store_depen, mem_store_depen})
			2'b00: store_src = 2'b00;
		   2'b01: store_src = 2'b10;
			2'b10: store_src = 2'b01;
			2'b11: store_src = 2'b01;
		 endcase
    end
	 
	 assign pcsource =           btaken? 2'b01:
							 i_j & (~ebtaken)? 2'b10:
							                   2'b00;
	 
	always @(op or func)
		case (op)
			6'b000000: begin aluc<=3'b000; end		//+; pc=pc+4
			6'b000001: 
				case (func[2:0])
					3'b001: begin aluc<=3'b001;  end		//and; pc=pc+4
					3'b010: begin aluc<=3'b010;  end		//or; pc=pc+4
					3'b100: begin aluc<=3'b011; end		//xor; pc=pc+4
				endcase
			6'b000010: 
				case (func[2:0])
					3'b010: begin aluc<=3'b100;  end		//srl; pc=pc+4
					3'b011: begin aluc<=3'b101; ; end		//sll; pc=pc+4
				endcase				
			6'b000101: begin aluc<=3'b000;  end		//addi; pc=pc+4
			6'b001001: begin aluc<=3'b001; end		//andi; pc=pc+4
			6'b001010: begin aluc<=3'b010; end		//ori; pc=pc+4
			6'b001100: begin aluc<=3'b011;  end		//xori; pc=pc+4

			6'b001101: begin aluc<=3'b000; end		//load; pc=pc+4
			6'b001110: begin aluc<=3'b000;  end		//store; pc=pc+4
			6'b001111: begin aluc<=3'b110;  end		//beq; pc=bpc
			6'b010000: begin aluc<=3'b110; end		//beq; pc=bpc
			//6'b010010: pcsource<=2'b10;		//beq; pc=jpc
		endcase

endmodule
