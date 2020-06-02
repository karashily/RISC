vsim -gui work.main
add wave -position insertpoint  \
sim:/main/ALU_output_selector \
sim:/main/FDRegIn \
sim:/main/FDRegOut \
sim:/main/FD_intr_out \
sim:/main/FD_ir_out \
sim:/main/FD_pc_out \
sim:/main/FD_rst_out \
sim:/main/FD_unpred_pc_out \
sim:/main/ForwardUnit_src1_sel \
sim:/main/ForwardUnit_src2_sel \
sim:/main/INT_EM \
sim:/main/IO_IN \
sim:/main/IO_OUT \
sim:/main/IO_output_selector \
sim:/main/IR \
sim:/main/JZ_signal \
sim:/main/PC \
sim:/main/PC_flags_mem \
sim:/main/PC_load \
sim:/main/PC_unpredicted \
sim:/main/RAM_INS_ADDR \
sim:/main/RAM_INS_IN \
sim:/main/RAM_INS_OUT \
sim:/main/RAM_INS_WR \
sim:/main/RESET_DE \
sim:/main/Rdst_DE_code \
sim:/main/Rdst_EM_code \
sim:/main/Rdst_FD_code \
sim:/main/Rdst_MW_code \
sim:/main/Rdst_val \
sim:/main/Rsrc1_DE_code \
sim:/main/Rsrc1_EM_code \
sim:/main/Rsrc1_MW_code \
sim:/main/Rsrc2_DE_code \
sim:/main/ZF \
sim:/main/clk \
sim:/main/control_unit_mux \
sim:/main/dec_PC_out \
sim:/main/dec_Rsrc1_val \
sim:/main/dec_Rsrc2_val \
sim:/main/dec_branch_regcode \
sim:/main/dec_branch_val \
sim:/main/dec_dst_code \
sim:/main/dec_ea \
sim:/main/dec_ex_cs \
sim:/main/dec_extended_imm \
sim:/main/dec_intr_out \
sim:/main/dec_mem_cs \
sim:/main/dec_opcode \
sim:/main/dec_rst_out \
sim:/main/dec_src1_code \
sim:/main/dec_src2_code \
sim:/main/dec_swap_flag \
sim:/main/dec_unpred_PC_out \
sim:/main/dec_wb_cs \
sim:/main/ex_dst_code_out \
sim:/main/ex_ea_out \
sim:/main/ex_flag_reg_out \
sim:/main/ex_flags_out \
sim:/main/ex_intr_mem_out \
sim:/main/ex_mem_cs_out \
sim:/main/ex_mem_dst_code_in \
sim:/main/ex_mem_ea_in \
sim:/main/ex_mem_extended_imm_out \
sim:/main/ex_mem_flags_in \
sim:/main/ex_mem_intr_mem_in \
sim:/main/ex_mem_output_in \
sim:/main/ex_mem_pc_in \
sim:/main/ex_mem_reset_mem_in \
sim:/main/ex_mem_src1_code_in \
sim:/main/ex_mem_src2_code_in \
sim:/main/ex_mem_unpred_pc_in \
sim:/main/ex_opcode_out \
sim:/main/ex_output_out \
sim:/main/ex_pc_out \
sim:/main/ex_reset_mem_out \
sim:/main/ex_src1_code_out \
sim:/main/ex_src1_value_in \
sim:/main/ex_src1_value_out \
sim:/main/ex_src2_code_out \
sim:/main/ex_swap_flag_in \
sim:/main/ex_swap_flag_out \
sim:/main/ex_unpred_pc_out \
sim:/main/ex_wb_cs_out \
sim:/main/fetch_stall \
sim:/main/flag_reg_in \
sim:/main/flag_reg_out \
sim:/main/forward_WB_val_out \
sim:/main/forward_mem_val_out \
sim:/main/idex_csFlush_out \
sim:/main/idex_dst_code_out \
sim:/main/idex_ea_out \
sim:/main/idex_ex_cs_out \
sim:/main/idex_extended_imm_out \
sim:/main/idex_intr_out \
sim:/main/idex_mem_cs_out \
sim:/main/idex_opcode_out \
sim:/main/idex_pc_out \
sim:/main/idex_reset_out \
sim:/main/idex_src1_code_out \
sim:/main/idex_src1_val_out \
sim:/main/idex_src2_code_out \
sim:/main/idex_src2_val_out \
sim:/main/idex_swap_flag_out \
sim:/main/idex_unpred_pc_out \
sim:/main/idex_wb_cs_out \
sim:/main/instruction \
sim:/main/int \
sim:/main/load_FD \
sim:/main/load_ret_PC \
sim:/main/load_ret_PC_int \
sim:/main/mem_dst_code_out \
sim:/main/mem_exe_out \
sim:/main/mem_intr_wb_out \
sim:/main/mem_opcode_out \
sim:/main/mem_out \
sim:/main/mem_reset_wb_out \
sim:/main/mem_result_out \
sim:/main/mem_src1_code_out \
sim:/main/mem_src2_code_out \
sim:/main/mem_src_val_out \
sim:/main/mem_swap_flag_out \
sim:/main/mem_wb_cs_out \
sim:/main/mimic_mem_reg_code \
sim:/main/mimic_wb_reg_code \
sim:/main/n \
sim:/main/opcode_DE \
sim:/main/opcode_EM \
sim:/main/opcode_FD \
sim:/main/opcode_MW \
sim:/main/pc_flags \
sim:/main/pred_pc \
sim:/main/prediction_bit \
sim:/main/regCode_in_dec \
sim:/main/reg_code \
sim:/main/regcode_in_exec \
sim:/main/reset \
sim:/main/src1_sel \
sim:/main/src2_sel \
sim:/main/unpred_pc \
sim:/main/unpredicted_PC_E \
sim:/main/wb_addr_out \
sim:/main/wb_en_out \
sim:/main/wb_mem_out \
sim:/main/wb_val_out \
sim:/main/wrong_prediction_bit \
sim:/main/zeros
add wave -position insertpoint  \
sim:/main/execution_stage/Rsrc2_sel_forward
add wave -position insertpoint  \
sim:/main/execution_stage/Rsrc1_sel_forward
add wave -position insertpoint  \
sim:/main/hazard_unit/stall_bit_8_bef
add wave -position insertpoint  \
sim:/main/hazard_unit/regcode_in_exec
add wave -position insertpoint  \
sim:/main/hazard_unit/stall_bit_8
force -freeze sim:/main/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/main/reset 1 0
force -freeze sim:/main/int 0 0
force -freeze sim:/main/hazard_unit/stall_bit_8 0 0
force -freeze sim:/main/hazard_unit/regcode_in_exec 0 0
# ** Warning: (vsim-8780) Forcing /main/regcode_in_exec as root of /main/hazard_unit/regcode_in_exec specified in the force.
# 
force -freeze sim:/main/hazard_unit/stall_bit_8_bef 0 0
force -freeze sim:/main/execution_stage/Rsrc1_sel_forward 00 0
# ** Warning: (vsim-8780) Forcing /main/ForwardUnit_src1_sel as root of /main/execution_stage/Rsrc1_sel_forward specified in the force.
# 
force -freeze sim:/main/execution_stage/Rsrc2_sel_forward 00 0
# ** Warning: (vsim-8780) Forcing /main/ForwardUnit_src2_sel as root of /main/execution_stage/Rsrc2_sel_forward specified in the force.
# 
run
force -freeze sim:/main/reset 0 0
run
force -freeze sim:/main/IO_IN 00001100110110101111111000011001 0
run
run
run
run
run
run
run
force -freeze sim:/main/IO_IN 11111111111111111111111111111111 0
run
force -freeze sim:/main/IO_IN 00000000000000001111001100100000 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run