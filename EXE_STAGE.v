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
	 input [31:0] ea,eb,eimm;		//ea-由寄存器读出的操作数a；eb-由寄存器读出的操作数a；eimm-经过扩展的立即数；
	 input btaken; //跳转发生标志， 用于使指令失效
	 input [2:0] ealuc;		//ALU控制码
	 input [1:0] ealusrc_a,ealusrc_b;		//ALU输入操作数的多路选择器
	 input [31:0] malu, wbdata;
	 input [1:0] store_src;//用于store的前推，选择存储的数据
	 input ewmem, ewreg, ebeq, ebne; //可能需要清0的信号
	 output ewmem_1, ewreg_1, ebeq_1, ebne_1; //处理后的信号
	 output [31:0] ealu;		//alu操作输出
	 output [31:0] store_data;// 存储数据
	 output z;
	 output [31:0] alua,alub;
	 wire [31:0] sa;

	 assign sa={26'b0,eimm[9:5]};//移位位数的生成
    assign ewmem_1 = (~btaken) & ewmem;
	 assign ewreg_1 = (~btaken) & ewreg;
	 assign ebeq_1 = (~btaken) & ebeq;
	 assign ebne_1 = (~btaken) & ebne;
	 mux32_4_1 alu_ina (sa, malu, wbdata, ea,ealusrc_a,alua);//选择ALU a端的数据来源
	 mux32_4_1 alu_inb (eimm, malu, wbdata, eb,ealusrc_b,alub);//选择ALU b端的数据来源
	 mux32_4_1 store_sel(eb, malu, wbdata, 32'b0, store_src, store_data);
 	 alu al_unit (alua,alub,ealuc,ealu,z);//ALU
	 
endmodule