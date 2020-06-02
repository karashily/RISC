vsim -gui work.main
add wave -position end  sim:/main/decode_stage/regs/q0
add wave -position end  sim:/main/decode_stage/regs/q1
add wave -position end  sim:/main/decode_stage/regs/q2
add wave -position end  sim:/main/decode_stage/regs/q3
add wave -position end  sim:/main/decode_stage/regs/q4
add wave -position end  sim:/main/decode_stage/regs/q5
add wave -position end  sim:/main/decode_stage/regs/q6
add wave -position end  sim:/main/decode_stage/regs/q7
add wave -position end  sim:/main/PC
add wave -position end  sim:/main/memory/sp_out_s
add wave -position end  sim:/main/execution_stage/flag_reg_out
add wave -position end  sim:/main/clk
add wave -position end  sim:/main/reset
add wave -position end  sim:/main/int
add wave -position end  sim:/main/IO_IN
add wave -position end  sim:/main/IO_OUT
add wave -position end  sim:/main/fetch_component/PC_pred/prediction_bit
add wave -position end  sim:/main/hazard_unit/stall_bit_8_bef
add wave -position end  sim:/main/hazard_unit/stall_bit_8
add wave -position end  sim:/main/hazard_unit/regcode_in_exec
add wave -position end  sim:/main/hazard_unit/regCode_in_dec
add wave -position end  sim:/main/execution_stage/Rsrc1_sel_forward
add wave -position end  sim:/main/execution_stage/Rsrc2_sel_forward

mem load -i mem/Branch.mem /main/memory/r/RAM

force -freeze sim:/main/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/main/reset 1 0
force -freeze sim:/main/int 0 0
run
force -freeze sim:/main/reset 0 0
run
force -freeze sim:/main/IO_IN 00000000000000000000000000110000 0
run
run
run
run
run
force -freeze sim:/main/IO_IN 00000000000000000000000001010000 0
run
force -freeze sim:/main/IO_IN 00000000000000000000000100000000 0
run
force -freeze sim:/main/IO_IN 00000000000000000000001100000000 0
run
force -freeze sim:/main/IO_IN 11111111111111111111111111111111 0
run
run
force -freeze sim:/main/int 1 0
run
force -freeze sim:/main/int 0 0
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
force -freeze sim:/main/IO_IN 00000000000000000000001000000000 0

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
force -freeze sim:/main/int 1 0
run
force -freeze sim:/main/int 0 0
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