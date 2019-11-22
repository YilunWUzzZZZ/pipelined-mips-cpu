`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:19:13 05/15/2019 
// Design Name: 
// Module Name:    EXE_STAGE 
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
module EXE_STAGE(btaken, ewmem, ewreg, ebeq, ebne, ewmem_1, ewreg_1, ebeq_1, ebne_1, ealuc,ealusrc_a,ea,eb,eimm,ealusrc_b,store_src,ealu,malu, wbdata,z, store_data, alua, alub
    );
	 input [31:0] ea,eb,eimm;		//ea-�ɼĴ��������Ĳ�����a��eb-�ɼĴ��������Ĳ�����a��eimm-������չ����������
	 input btaken; //��ת������־�� ����ʹָ��ʧЧ
	 input [2:0] ealuc;		//ALU������
	 input [1:0] ealusrc_a,ealusrc_b;		//ALU����������Ķ�·ѡ����
	 input [31:0] malu, wbdata;
	 input [1:0] store_src;//����store��ǰ�ƣ�ѡ��洢������
	 input ewmem, ewreg, ebeq, ebne; //������Ҫ��0���ź�
	 output ewmem_1, ewreg_1, ebeq_1, ebne_1; //�������ź�
	 output [31:0] ealu;		//alu�������
	 output [31:0] store_data;// �洢����
	 output z;
	 output [31:0] alua,alub;
	 wire [31:0] sa;

	 assign sa={26'b0,eimm[9:5]};//��λλ��������
    assign ewmem_1 = (~btaken) & ewmem;
	 assign ewreg_1 = (~btaken) & ewreg;
	 assign ebeq_1 = (~btaken) & ebeq;
	 assign ebne_1 = (~btaken) & ebne;
	 mux32_4_1 alu_ina (sa, malu, wbdata, ea,ealusrc_a,alua);//ѡ��ALU a�˵�������Դ
	 mux32_4_1 alu_inb (eimm, malu, wbdata, eb,ealusrc_b,alub);//ѡ��ALU b�˵�������Դ
	 mux32_4_1 store_sel(eb, malu, wbdata, 32'b0, store_src, store_data);
 	 alu al_unit (alua,alub,ealuc,ealu,z);//ALU
	 
endmodule