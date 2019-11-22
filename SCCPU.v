`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:59 05/14/2019 
// Design Name: 
// Module Name:    PPCPU 
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
module PPCPU(Clock, Resetn, PC, IF_Inst, ID_Inst, EXE_Alu, EXE_ALU_A, EXE_ALU_B, ealusrc_a, ealusrc_b, MEM_Alu, data_stored, WB_Data,  rs, rt, exe_wreg, mem_wreg, exe_rd, mem_rd, stall, pcsource
    );
	 input Clock, Resetn;
	 output [31:0] PC, IF_Inst, ID_Inst, EXE_Alu, MEM_Alu, EXE_ALU_A, EXE_ALU_B, WB_Data, data_stored;
	 output[4:0] rs, rt, exe_rd, mem_rd;
	 output exe_wreg, mem_wreg;
	 wire [1:0] alusrc_a, alusrc_b;
	 output [1:0] pcsource;
	 wire [31:0] bpc, jpc, if_pc4, id_pc4; 
	 wire id_btaken, ebtaken, btaken,  beq, bne , ebeq, ebne, mbeq, mbne; //控制冒险相关标志
	 wire [31:0] ebpc, mbpc;
	 wire [31:0] wdi, ra, rb, ea, eb,  imm, eimm, WB_Alu;

	 wire wreg, ewreg, mwreg, wwreg, m2reg, em2reg, mm2reg, wm2reg, wmem, ewmem, mwmem, z, mz;
	 output [1:0] ealusrc_a, ealusrc_b;
	 wire[4:0] dest, edest, mdest, wdest;	 
	 wire [2:0] aluc, ealuc;
	 wire [31:0] edatain, memout, wmemout, datain;
	 wire [1:0] store_src, estore_src;
	 wire ldst_depen, eldst_depen, mldst_depen;
	 output stall;
	 
	 assign rs=ID_Inst[9:5];
	 assign rt=ID_Inst[4:0];
	 assign exe_wreg = ewreg_1;
	 assign mem_wreg = mwreg;
	 assign exe_rd = edest;
	 assign mem_rd = mdest;
	 assign WB_Data = wdi; // for observation
	
	 IF_STAGE stage1 (Clock, Resetn, stall, pcsource, mbpc, jpc, if_pc4, IF_Inst, PC);
	 
	 IF_ID_PipeReg IF_ID_REG(Clock, Resetn, stall, if_pc4, IF_Inst, id_pc4, ID_Inst);
	 
	 ID_STAGE stage2 (id_pc4, ID_Inst, wdest, dest, wwreg, wdi, Clock, Resetn, bpc, jpc, pcsource, store_src,  edest, ewreg_1, em2reg, mdest, mwreg, stall, ldst_depen,
				   wreg, m2reg, wmem, aluc, alusrc_b, ra, rb, imm, alusrc_a,  btaken, ebtaken, id_btaken, beq, bne);	 
					
	 ID_EXE_PipeReg ID_EXE_REG(Clock, Resetn, wreg, m2reg, wmem,  aluc, alusrc_a, alusrc_b, store_src, imm, ra, rb, dest, ldst_depen,bpc, beq, bne, id_btaken,
										ewreg, em2reg, ewmem,  ealuc, ealusrc_a, ealusrc_b, estore_src, eimm, ea, eb, edest, eldst_depen, ebpc, ebeq, ebne, ebtaken);
	 
	 EXE_STAGE stage3 (btaken,  ewmem, ewreg, ebeq, ebne, ewmem_1, ewreg_1, ebeq_1, ebne_1, ealuc, ealusrc_a, ea, eb, eimm, ealusrc_b, estore_src, EXE_Alu, MEM_Alu, wdi, z, edatain, EXE_ALU_A, EXE_ALU_B);
	 
	 EXE_MEM_PipeReg EXE_MEM_REG(Clock, Resetn, ewreg_1, em2reg, ewmem_1, z, EXE_Alu, edest, edatain, eldst_depen, ebpc, ebeq_1, ebne_1, 
	                            mwreg, mm2reg, mwmem, mz, MEM_Alu, mdest,datain,  mldst_depen, mbpc, mbeq, mbne);
	 
	 MEM_STAGE stage4 (mwmem, mldst_depen, MEM_Alu, wdi, datain, Clock, memout, data_stored, mz, mbeq, mbne, btaken );
	 
	 MEM_WB_PipeReg  MEM_WB_REG(Clock, Resetn, mwreg, mm2reg, memout, MEM_Alu, mdest, wwreg, wm2reg, wmemout, WB_Alu, wdest);
	 
	 WB_STAGE stage5 (WB_Alu, wmemout, wm2reg, wdi);


endmodule
