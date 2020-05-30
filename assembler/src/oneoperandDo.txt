force -freeze sim:/main/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/main/reset 1 0
force -freeze sim:/main/int 0 0
run
force -freeze sim:/main/reset 0 0
run
force -freeze sim:/main/IO_IN 00000000000000000000000000000101 0
run
run
run
run
run
run
run
run
force -freeze sim:/main/IO_IN 00000000000000000000000000010000 0
run
run
run
run
run
run