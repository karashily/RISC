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
run
run
run
run
run
run
run
run
force -freeze sim:/main/IO_IN 00000000000000000000000000000101 0
run
run
force -freeze sim:/main/IO_IN 00000000000000000000000000010000 0
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